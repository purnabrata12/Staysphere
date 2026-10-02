import os, uuid
from datetime import datetime, timedelta, date
from functools import wraps
import bcrypt, jwt, pymysql
from dotenv import load_dotenv
from flask import Flask, request, jsonify
from flask_cors import CORS
from pymysql.cursors import DictCursor
from otp_email import generate_otp, hash_otp, verify_otp, send_otp_email

load_dotenv()
app=Flask(__name__)
CORS(app,resources={r"/api/*":{"origins":os.getenv("FRONTEND_URL","http://localhost:5173")}})
SECRET=os.getenv("JWT_SECRET","dev-secret")

def db():
    return pymysql.connect(host=os.getenv("DB_HOST","localhost"),port=int(os.getenv("DB_PORT","3306")),user=os.getenv("DB_USER","root"),password=os.getenv("DB_PASSWORD",""),database=os.getenv("DB_NAME","staysphere"),cursorclass=DictCursor,autocommit=True)

def query(sql,args=(),one=False):
    con=db()
    try:
        with con.cursor() as cur:
            cur.execute(sql,args)
            return cur.fetchone() if one else cur.fetchall()
    finally: con.close()

def execute(sql,args=()):
    con=db()
    try:
        with con.cursor() as cur:
            cur.execute(sql,args)
            return cur.lastrowid
    finally: con.close()

def issue_otp(user, purpose):
    last = query(
        """
        SELECT created_at
        FROM email_otps
        WHERE user_id=%s AND purpose=%s
        ORDER BY id DESC
        LIMIT 1
        """,
        (user['id'], purpose),
        True
    )

    if last and last['created_at'] > datetime.now() - timedelta(seconds=60):
        return False

    execute(
        """
        UPDATE email_otps
        SET used_at=NOW()
        WHERE user_id=%s
          AND purpose=%s
          AND used_at IS NULL
        """,
        (user['id'], purpose)
    )

    otp = generate_otp()

    otp_id = execute(
        """
        INSERT INTO email_otps
        (
            user_id,
            purpose,
            otp_hash,
            expires_at
        )
        VALUES
        (
            %s,
            %s,
            %s,
            DATE_ADD(NOW(), INTERVAL 10 MINUTE)
        )
        """,
        (
            user['id'],
            purpose,
            hash_otp(otp)
        )
    )

    try:
        send_otp_email(
            user['email'],
            user['full_name'],
            otp,
            purpose
        )

    except Exception:
        execute(
            """
            UPDATE email_otps
            SET used_at=NOW()
            WHERE id=%s
            """,
            (otp_id,)
        )

        raise

    return True


def consume_otp(user_id, purpose, otp):
    row = query(
        """
        SELECT *
        FROM email_otps
        WHERE user_id=%s
          AND purpose=%s
          AND used_at IS NULL
          AND expires_at > NOW()
        ORDER BY id DESC
        LIMIT 1
        """,
        (
            user_id,
            purpose
        ),
        True
    )

    if not row:
        return False, 'OTP is invalid or expired.'

    if int(row['attempts']) >= 5:
        return False, 'Too many incorrect attempts. Request a new OTP.'

    if not verify_otp(
        otp,
        row['otp_hash']
    ):
        execute(
            """
            UPDATE email_otps
            SET attempts=attempts+1
            WHERE id=%s
            """,
            (row['id'],)
        )

        return False, 'Incorrect OTP.'

    execute(
        """
        UPDATE email_otps
        SET used_at=NOW()
        WHERE id=%s
        """,
        (row['id'],)
    )

    return True, None

def serial(r):
    if not r:
        return r

    def convert(v):
        if isinstance(v, (datetime, date)):
            return v.isoformat()

        if isinstance(v, timedelta):
            total_seconds = int(v.total_seconds())

            hours, remainder = divmod(total_seconds, 3600)
            minutes, seconds = divmod(remainder, 60)

            return f"{hours:02d}:{minutes:02d}:{seconds:02d}"

        if hasattr(v, "as_tuple"):
            return float(v)

        return v

    return {k: convert(v) for k, v in r.items()}

def make_token(uid,role='user'):
    return jwt.encode({'sub':str(uid),'role':role,'exp':datetime.utcnow()+timedelta(days=7)},SECRET,algorithm='HS256')

def auth(role=None):
    def deco(fn):
        @wraps(fn)
        def inner(*a,**kw):
            h=request.headers.get('Authorization','')
            if not h.startswith('Bearer '):return jsonify({'message':'Authentication required'}),401
            try:p=jwt.decode(h[7:],SECRET,algorithms=['HS256'])
            except Exception:return jsonify({'message':'Invalid or expired token'}),401
            if role and p.get('role')!=role:return jsonify({'message':'Forbidden'}),403
            request.identity=p
            return fn(*a,**kw)
        return inner
    return deco

@app.get('/api/health')
def health():return jsonify({'status':'ok','service':'StaySphere API'})

@app.post('/api/auth/register')
def register():
    d = request.get_json() or {}

    for x in [
        'full_name',
        'email',
        'phone',
        'password'
    ]:
        if not d.get(x):
            return jsonify({
                'message': 'All required fields must be filled'
            }), 400

    email = d['email'].strip().lower()
    phone = d['phone'].strip()

    if len(d['password']) < 8:
        return jsonify({
            'message': 'Password must contain at least 8 characters'
        }), 400

    existing = query(
        '''
        SELECT id
        FROM users
        WHERE email=%s OR phone=%s
        ''',
        (
            email,
            phone
        ),
        True
    )

    if existing:
        return jsonify({
            'message': 'Email or phone already registered'
        }), 409

    password_hash = bcrypt.hashpw(
        d['password'].encode(),
        bcrypt.gensalt()
    ).decode()

    user_id = execute(
        '''
        INSERT INTO users
        (
            full_name,
            email,
            phone,
            password_hash,
            address,
            email_verified
        )
        VALUES
        (
            %s,%s,%s,%s,%s,0
        )
        ''',
        (
            d['full_name'],
            email,
            phone,
            password_hash,
            d.get('address')
        )
    )

    user = query(
        '''
        SELECT
            id,
            full_name,
            email
        FROM users
        WHERE id=%s
        ''',
        (user_id,),
        True
    )

    try:
        issue_otp(
            user,
            'verify_email'
        )

    except Exception as e:
        app.logger.exception(e)

        return jsonify({
            'message':
            'Account created, but verification email could not be sent. '
            'Check SMTP configuration and use Resend OTP.'
        }), 500

    return jsonify({
        'message':
        'Account created. Verification OTP sent to your email.',
        'email': email
    }), 201

@app.post('/api/auth/login')
def login():
    d = request.get_json() or {}

    identifier = d.get(
        'identifier',
        ''
    ).strip()

    user = query(
        """
        SELECT *
        FROM users
        WHERE email=%s OR phone=%s
        """,
        (
            identifier.lower(),
            identifier
        ),
        True
    )

    if not user or not bcrypt.checkpw(
        d.get(
            'password',
            ''
        ).encode(),
        user['password_hash'].encode()
    ):
        return jsonify({
            'message':
            'Invalid email/mobile or password'
        }), 401

    if user['account_status'] != 'active':
        return jsonify({
            'message':
            'Your account has been deactivated'
        }), 403

    if not user['email_verified']:
        return jsonify({
            'message':
            'Please verify your email before logging in.',
            'email_verification_required': True,
            'email': user['email']
        }), 403

    execute(
        """
        UPDATE users
        SET last_login_at=NOW(),
            login_count=login_count+1
        WHERE id=%s
        """,
        (user['id'],)
    )

    return jsonify({
        'token':
        make_token(
            user['id']
        ),

        'user': {
            'id':
            user['id'],

            'full_name':
            user['full_name'],

            'email':
            user['email'],

            'phone':
            user['phone']
        }
    })

@app.post('/api/auth/resend-verification')
def resend_verification():
    d = request.get_json() or {}

    email = d.get(
        'email',
        ''
    ).strip().lower()

    user = query(
        """
        SELECT
            id,
            full_name,
            email,
            email_verified
        FROM users
        WHERE email=%s
        """,
        (email,),
        True
    )

    if not user:
        return jsonify({
            'message':
            'Account not found'
        }), 404

    if user['email_verified']:
        return jsonify({
            'message':
            'Email is already verified'
        }), 400

    try:
        sent = issue_otp(
            user,
            'verify_email'
        )

        if not sent:
            return jsonify({
                'message':
                'Please wait 60 seconds before requesting another OTP.'
            }), 429

    except Exception as e:
        app.logger.exception(e)

        return jsonify({
            'message':
            'Could not send verification email'
        }), 500

    return jsonify({
        'message':
        'A new verification OTP was sent.'
    })

@app.post('/api/auth/verify-email')
def verify_email_route():
    d = request.get_json() or {}

    email = d.get(
        'email',
        ''
    ).strip().lower()

    otp = d.get(
        'otp',
        ''
    ).strip()

    user = query(
        """
        SELECT *
        FROM users
        WHERE email=%s
        """,
        (email,),
        True
    )

    if not user:
        return jsonify({
            'message':
            'Account not found'
        }), 404

    if user['email_verified']:
        return jsonify({
            'token':
            make_token(
                user['id']
            ),

            'user': {
                'id':
                user['id'],

                'full_name':
                user['full_name'],

                'email':
                user['email'],

                'phone':
                user['phone']
            }
        })

    ok, error = consume_otp(
        user['id'],
        'verify_email',
        otp
    )

    if not ok:
        return jsonify({
            'message':
            error
        }), 400

    execute(
        """
        UPDATE users
        SET email_verified=1,
            email_verified_at=NOW()
        WHERE id=%s
        """,
        (user['id'],)
    )

    return jsonify({
        'message':
        'Email verified successfully.',

        'token':
        make_token(
            user['id']
        ),

        'user': {
            'id':
            user['id'],

            'full_name':
            user['full_name'],

            'email':
            user['email'],

            'phone':
            user['phone']
        }
    })

@app.post('/api/auth/forgot-password')
def forgot_password():
    d = request.get_json() or {}

    email = d.get(
        'email',
        ''
    ).strip().lower()

    user = query(
        """
        SELECT
            id,
            full_name,
            email
        FROM users
        WHERE email=%s
        """,
        (email,),
        True
    )

    if user:
        try:
            issue_otp(
                user,
                'reset_password'
            )

        except Exception as e:
            app.logger.exception(e)

            return jsonify({
                'message':
                'Could not send reset email. '
                'Check SMTP configuration.'
            }), 500

    return jsonify({
        'message':
        'If that email is registered, '
        'a password reset OTP has been sent.'
    })

@app.post('/api/auth/reset-password')
def reset_password():
    d = request.get_json() or {}

    email = d.get(
        'email',
        ''
    ).strip().lower()

    otp = d.get(
        'otp',
        ''
    ).strip()

    password = d.get(
        'password',
        ''
    )

    if len(password) < 8:
        return jsonify({
            'message':
            'Password must contain at least 8 characters'
        }), 400

    user = query(
        """
        SELECT id
        FROM users
        WHERE email=%s
        """,
        (email,),
        True
    )

    if not user:
        return jsonify({
            'message':
            'Invalid or expired reset request'
        }), 400

    ok, error = consume_otp(
        user['id'],
        'reset_password',
        otp
    )

    if not ok:
        return jsonify({
            'message':
            error
        }), 400

    new_hash = bcrypt.hashpw(
        password.encode(),
        bcrypt.gensalt()
    ).decode()

    execute(
        """
        UPDATE users
        SET password_hash=%s
        WHERE id=%s
        """,
        (
            new_hash,
            user['id']
        )
    )

    execute(
        """
        UPDATE email_otps
        SET used_at=NOW()
        WHERE user_id=%s
          AND used_at IS NULL
        """,
        (user['id'],)
    )

    return jsonify({
        'message':
        'Password reset successfully. '
        'You can now log in.'
    })

@app.get('/api/profile')
@auth()
def profile():return jsonify(serial(query('SELECT id,full_name,email,phone,date_of_birth,address,profile_image FROM users WHERE id=%s',(request.identity['sub'],),True)))

@app.put('/api/profile')
@auth()
def profile_update():
    d=request.get_json() or {}
    execute('UPDATE users SET full_name=%s,phone=%s,date_of_birth=%s,address=%s WHERE id=%s',(d.get('full_name'),d.get('phone'),d.get('date_of_birth') or None,d.get('address'),request.identity['sub']))
    return jsonify({'message':'Profile updated'})

@app.get('/api/cities')
def cities():
    rows=query('SELECT c.*,COUNT(h.id) hotel_count FROM cities c LEFT JOIN hotels h ON h.city_id=c.id AND h.status="active" WHERE c.status="active" GROUP BY c.id ORDER BY c.name')
    return jsonify([serial(x) for x in rows])

@app.get('/api/hotels')
def hotels():
    city=request.args.get('city'); q=request.args.get('q'); stars=request.args.get('stars'); minp=request.args.get('min_price'); maxp=request.args.get('max_price'); sort=request.args.get('sort','recommended')
    sql="""SELECT h.*,c.name city,c.state,COALESCE(MIN(r.price*(1-r.discount_percentage/100)),0) starting_price,COALESCE(AVG(rv.rating),0) guest_rating,COUNT(DISTINCT rv.id) review_count FROM hotels h JOIN cities c ON c.id=h.city_id LEFT JOIN rooms r ON r.hotel_id=h.id AND r.status='active' LEFT JOIN reviews rv ON rv.hotel_id=h.id WHERE h.status='active'"""
    args=[]
    if city:
        if str(city).isdigit():sql+=' AND c.id=%s';args.append(city)
        else:sql+=' AND LOWER(c.name)=LOWER(%s)';args.append(city)
    if q:sql+=' AND (h.name LIKE %s OR c.name LIKE %s)';args += [f'%{q}%',f'%{q}%']
    if stars:sql+=' AND h.star_rating=%s';args.append(stars)
    sql+=' GROUP BY h.id'
    hs=[]
    if minp:hs.append('starting_price >= %s');args.append(minp)
    if maxp:hs.append('starting_price <= %s');args.append(maxp)
    if hs:sql+=' HAVING '+' AND '.join(hs)
    order={'price_asc':'starting_price ASC','price_desc':'starting_price DESC','rating':'guest_rating DESC','recommended':'h.featured DESC,guest_rating DESC'}.get(sort,'h.featured DESC')
    sql+=' ORDER BY '+order
    return jsonify([serial(x) for x in query(sql,tuple(args))])

@app.get('/api/hotels/<int:hid>')
def hotel(hid):
    h=query("""SELECT h.*,c.name city,c.state,COALESCE(AVG(rv.rating),0) guest_rating,COUNT(DISTINCT rv.id) review_count FROM hotels h JOIN cities c ON c.id=h.city_id LEFT JOIN reviews rv ON rv.hotel_id=h.id WHERE h.id=%s GROUP BY h.id""",(hid,),True)
    if not h:return jsonify({'message':'Hotel not found'}),404
    h=serial(h);h['images']=[x['image_url'] for x in query('SELECT image_url FROM hotel_images WHERE hotel_id=%s',(hid,))];h['amenities']=[x['name'] for x in query('SELECT a.name FROM amenities a JOIN hotel_amenities ha ON ha.amenity_id=a.id WHERE ha.hotel_id=%s',(hid,))];h['rooms']=[serial(x) for x in query('SELECT * FROM rooms WHERE hotel_id=%s AND status="active" ORDER BY price',(hid,))];h['reviews']=[serial(x) for x in query('SELECT rv.*,u.full_name FROM reviews rv JOIN users u ON u.id=rv.user_id WHERE rv.hotel_id=%s ORDER BY rv.created_at DESC LIMIT 10',(hid,))]
    return jsonify(h)

@app.get('/api/rooms/<int:hotel_id>/availability')
def availability(hotel_id):
    ci=request.args.get('check_in');co=request.args.get('check_out')
    if not ci or not co:return jsonify({'message':'check_in and check_out required'}),400
    out=[]
    for r in query('SELECT * FROM rooms WHERE hotel_id=%s AND status="active"',(hotel_id,)):
        n=query("SELECT COALESCE(SUM(rooms),0) n FROM bookings WHERE room_id=%s AND booking_status IN ('pending','confirmed') AND check_in < %s AND check_out > %s",(r['id'],co,ci),True)['n']
        x=serial(r);x['available_rooms']=max(0,int(r['total_rooms'])-int(n));out.append(x)
    return jsonify(out)

@app.post('/api/bookings')
@auth()
def create_booking():
    d=request.get_json() or {}
    for x in ['hotel_id','room_id','check_in','check_out','guests','rooms','guest_name','guest_email','guest_phone']:
        if d.get(x) in (None,''):return jsonify({'message':'Missing booking information'}),400
    ci=datetime.fromisoformat(d['check_in']).date();co=datetime.fromisoformat(d['check_out']).date()
    if co<=ci:return jsonify({'message':'Check-out date must be after check-in date'}),400
    room=query('SELECT * FROM rooms WHERE id=%s AND hotel_id=%s',(d['room_id'],d['hotel_id']),True)
    if not room:return jsonify({'message':'Room not found'}),404
    n=query("SELECT COALESCE(SUM(rooms),0) n FROM bookings WHERE room_id=%s AND booking_status IN ('pending','confirmed') AND check_in < %s AND check_out > %s",(d['room_id'],co,ci),True)['n']
    if int(n)+int(d['rooms'])>room['total_rooms']:return jsonify({'message':'Requested rooms are not available for these dates'}),409
    nights=(co-ci).days;rate=float(room['price'])*(1-float(room['discount_percentage'])/100);sub=round(rate*nights*int(d['rooms']),2);tax=round(sub*.12,2);service=round(sub*.03,2);total=round(sub+tax+service,2);code='STAY'+datetime.now().strftime('%Y%m%d')+uuid.uuid4().hex[:6].upper()
    bid=execute("""INSERT INTO bookings(booking_code,user_id,hotel_id,room_id,check_in,check_out,guests,rooms,guest_name,guest_email,guest_phone,guest_address,special_request,subtotal,tax,service_charge,total_amount) VALUES(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)""",(code,request.identity['sub'],d['hotel_id'],d['room_id'],ci,co,d['guests'],d['rooms'],d['guest_name'],d['guest_email'],d['guest_phone'],d.get('guest_address'),d.get('special_request'),sub,tax,service,total))
    return jsonify({'booking_id':bid,'booking_code':code,'total_amount':total}),201

@app.get('/api/bookings/user')
@auth()
def mine():return jsonify([serial(x) for x in query("""SELECT b.*,h.name hotel_name,h.cover_image,r.room_type,c.name city FROM bookings b JOIN hotels h ON h.id=b.hotel_id JOIN rooms r ON r.id=b.room_id JOIN cities c ON c.id=h.city_id WHERE b.user_id=%s ORDER BY b.created_at DESC""",(request.identity['sub'],))])

@app.get('/api/bookings/<int:bid>')
@auth()
def booking_one(bid):
    if request.identity['role']=='admin':b=query("""SELECT b.*,h.name hotel_name,h.address,r.room_type,c.name city FROM bookings b JOIN hotels h ON h.id=b.hotel_id JOIN rooms r ON r.id=b.room_id JOIN cities c ON c.id=h.city_id WHERE b.id=%s""",(bid,),True)
    else:b=query("""SELECT b.*,h.name hotel_name,h.address,r.room_type,c.name city FROM bookings b JOIN hotels h ON h.id=b.hotel_id JOIN rooms r ON r.id=b.room_id JOIN cities c ON c.id=h.city_id WHERE b.id=%s AND b.user_id=%s""",(bid,request.identity['sub']),True)
    return jsonify(serial(b)) if b else (jsonify({'message':'Booking not found'}),404)

@app.put('/api/bookings/<int:bid>/cancel')
@auth()
def cancel(bid):
    b=query('SELECT * FROM bookings WHERE id=%s AND user_id=%s',(bid,request.identity['sub']),True)
    if not b:return jsonify({'message':'Booking not found'}),404
    if b['booking_status'] in ('completed','cancelled'):return jsonify({'message':'Booking cannot be cancelled'}),400
    execute("UPDATE bookings SET booking_status='cancelled' WHERE id=%s",(bid,));return jsonify({'message':'Booking cancelled'})

@app.post('/api/payments')
@auth()
def payment():
    d=request.get_json() or {};b=query('SELECT * FROM bookings WHERE id=%s AND user_id=%s',(d.get('booking_id'),request.identity['sub']),True)
    if not b:return jsonify({'message':'Booking not found'}),404
    tx='TXN'+uuid.uuid4().hex[:12].upper()
    execute("INSERT INTO payments(booking_id,transaction_id,amount,payment_method,payment_status,paid_at) VALUES(%s,%s,%s,%s,'successful',NOW())",(b['id'],tx,b['total_amount'],d.get('method','UPI')));execute("UPDATE bookings SET payment_status='successful',booking_status='confirmed' WHERE id=%s",(b['id'],))
    return jsonify({'message':'Demo payment successful','transaction_id':tx})

@app.get('/api/wishlist')
@auth()
def wishlist_get():return jsonify([serial(x) for x in query("""SELECT h.*,c.name city,c.state,COALESCE(MIN(r.price),0) starting_price FROM wishlist w JOIN hotels h ON h.id=w.hotel_id JOIN cities c ON c.id=h.city_id LEFT JOIN rooms r ON r.hotel_id=h.id WHERE w.user_id=%s GROUP BY h.id""",(request.identity['sub'],))])

@app.post('/api/wishlist')
@auth()
def wishlist_add():
    try:execute('INSERT INTO wishlist(user_id,hotel_id) VALUES(%s,%s)',(request.identity['sub'],(request.get_json() or {}).get('hotel_id')))
    except pymysql.err.IntegrityError:pass
    return jsonify({'message':'Saved'})

@app.delete('/api/wishlist/<int:hid>')
@auth()
def wishlist_del(hid):execute('DELETE FROM wishlist WHERE user_id=%s AND hotel_id=%s',(request.identity['sub'],hid));return jsonify({'message':'Removed'})

@app.post('/api/reviews')
@auth()
def review():
    d=request.get_json() or {};b=query("SELECT * FROM bookings WHERE id=%s AND user_id=%s AND booking_status='completed'",(d.get('booking_id'),request.identity['sub']),True)
    if not b:return jsonify({'message':'Only completed stays can be reviewed'}),403
    execute('INSERT INTO reviews(user_id,hotel_id,booking_id,rating,comment) VALUES(%s,%s,%s,%s,%s)',(request.identity['sub'],b['hotel_id'],b['id'],d.get('rating'),d.get('comment')));return jsonify({'message':'Review submitted'}),201

@app.get('/api/advertisements')
def ads():return jsonify([serial(x) for x in query("SELECT * FROM advertisements WHERE status='active' AND start_date<=CURDATE() AND end_date>=CURDATE() ORDER BY id DESC")])

@app.post('/api/admin/login')
def admin_login():
    d=request.get_json() or {};a=query('SELECT * FROM admins WHERE email=%s',(d.get('email'),),True)
    if not a or not bcrypt.checkpw(d.get('password','').encode(),a['password_hash'].encode()):return jsonify({'message':'Invalid admin credentials'}),401
    return jsonify({'token':make_token(a['id'],'admin'),'admin':{'id':a['id'],'name':a['name']}})

@app.get('/api/admin/dashboard')
@auth('admin')
def dash():
    return jsonify({'hotels':query('SELECT COUNT(*) n FROM hotels',one=True)['n'],'users':query('SELECT COUNT(*) n FROM users',one=True)['n'],'bookings':query('SELECT COUNT(*) n FROM bookings',one=True)['n'],'today_bookings':query('SELECT COUNT(*) n FROM bookings WHERE DATE(created_at)=CURDATE()',one=True)['n'],'revenue':float(query("SELECT COALESCE(SUM(amount),0) n FROM payments WHERE payment_status='successful'",one=True)['n']),'cancelled':query("SELECT COUNT(*) n FROM bookings WHERE booking_status='cancelled'",one=True)['n']})

@app.get('/api/admin/customers')
@auth('admin')
def admin_customers():
    rows = query("""
        SELECT
            u.id,
            u.full_name,
            u.email,
            u.phone,
            u.date_of_birth,
            u.address,
            u.profile_image,
            u.account_status,
            u.last_login_at,
            u.login_count,
            u.created_at,
            COUNT(DISTINCT b.id) AS total_bookings
        FROM users u
        LEFT JOIN bookings b
            ON b.user_id = u.id
        GROUP BY
            u.id,
            u.full_name,
            u.email,
            u.phone,
            u.date_of_birth,
            u.address,
            u.profile_image,
            u.account_status,
            u.last_login_at,
            u.login_count,
            u.created_at
        ORDER BY u.created_at DESC
    """)

    return jsonify([serial(x) for x in rows])


@app.put('/api/admin/customers/<int:user_id>/status')
@auth('admin')
def admin_customer_status(user_id):
    d = request.get_json() or {}

    status = d.get('status')

    if status not in ('active', 'inactive'):
        return jsonify({
            'message': 'Invalid account status'
        }), 400

    execute(
        'UPDATE users SET account_status=%s WHERE id=%s',
        (status, user_id)
    )

    return jsonify({
        'message': 'Customer status updated'
    })

@app.get('/api/admin/support')
@auth('admin')
def admin_support_requests():

    rows = query(
        '''
        SELECT
            s.id,
            s.user_id,
            u.full_name,
            u.email,
            u.phone,
            s.subject,
            s.message,
            s.status,
            s.admin_reply,
            s.created_at,
            s.updated_at

        FROM support_requests s

        JOIN users u
            ON u.id = s.user_id

        ORDER BY
            CASE s.status
                WHEN 'new' THEN 1
                WHEN 'in_progress' THEN 2
                WHEN 'resolved' THEN 3
            END,
            s.created_at DESC
        '''
    )

    return jsonify([
        serial(x) for x in rows
    ])


@app.put('/api/admin/support/<int:support_id>')
@auth('admin')
def admin_support_update(support_id):
    d = request.get_json() or {}

    status = d.get('status', '').strip()
    admin_reply = d.get('admin_reply', '').strip()

    if status not in ('new', 'in_progress', 'resolved'):
        return jsonify({
            'message': 'Invalid support status.'
        }), 400

    support = query(
        '''
        SELECT id
        FROM support_requests
        WHERE id=%s
        ''',
        (support_id,),
        True
    )

    if not support:
        return jsonify({
            'message': 'Support request not found.'
        }), 404

    execute(
        '''
        UPDATE support_requests
        SET status=%s,
            admin_reply=%s
        WHERE id=%s
        ''',
        (
            status,
            admin_reply or None,
            support_id
        )
    )

    return jsonify({
        'message': 'Reply saved successfully.'
    })

@app.get('/api/support/my')
@auth()
def my_support_requests():

    user_id = request.identity['sub']

    rows = query(
        '''
        SELECT
            id,
            subject,
            message,
            status,
            admin_reply,
            created_at,
            updated_at
        FROM support_requests
        WHERE user_id=%s
        ORDER BY created_at DESC
        ''',
        (user_id,)
    )

    return jsonify([
        serial(x) for x in rows
    ])

@app.get('/api/admin/bookings')
@auth('admin')
def admin_bookings():return jsonify([serial(x) for x in query("""SELECT b.*,u.full_name customer,h.name hotel_name,r.room_type,c.name city FROM bookings b JOIN users u ON u.id=b.user_id JOIN hotels h ON h.id=b.hotel_id JOIN rooms r ON r.id=b.room_id JOIN cities c ON c.id=h.city_id ORDER BY b.created_at DESC""")])

@app.put('/api/admin/bookings/<int:bid>')
@auth('admin')
def admin_booking_update(bid):
    status=(request.get_json() or {}).get('booking_status')
    if status not in ('pending','confirmed','completed','cancelled'):return jsonify({'message':'Invalid status'}),400
    execute('UPDATE bookings SET booking_status=%s WHERE id=%s',(status,bid));return jsonify({'message':'Updated'})

@app.post('/api/admin/hotels')
@auth('admin')
def admin_hotel_add():
    d=request.get_json() or {};hid=execute("""INSERT INTO hotels(city_id,name,slug,description,address,star_rating,property_type,cover_image,status,featured) VALUES(%s,%s,%s,%s,%s,%s,%s,%s,'active',0)""",(d['city_id'],d['name'],d['name'].lower().replace(' ','-')+uuid.uuid4().hex[:4],d.get('description'),d.get('address'),d.get('star_rating',3),d.get('property_type','Hotel'),d.get('cover_image')));return jsonify({'id':hid}),201

@app.delete('/api/admin/hotels/<int:hid>')
@auth('admin')
def admin_hotel_del(hid):execute("UPDATE hotels SET status='inactive' WHERE id=%s",(hid,));return jsonify({'message':'Deactivated'})

@app.post('/api/support')
@auth()
def create_support_request():
    d = request.get_json() or {}

    subject = d.get('subject', '').strip()
    message = d.get('message', '').strip()

    if not subject or not message:
        return jsonify({
            'message': 'Subject and message are required.'
        }), 400

    user_id = request.identity['sub']

    user = query(
        '''
        SELECT id, full_name, email
        FROM users
        WHERE id=%s
        ''',
        (user_id,),
        True
    )

    if not user:
        return jsonify({
            'message': 'User account not found.'
        }), 404

    support_id = execute(
        '''
        INSERT INTO support_requests
        (user_id, subject, message)
        VALUES (%s,%s,%s)
        ''',
        (
            user_id,
            subject,
            message
        )
    )

    return jsonify({
        'message': 'Your support request has been submitted successfully.',
        'support_id': support_id
    }), 201

if __name__=='__main__':app.run(debug=True,port=5000)
