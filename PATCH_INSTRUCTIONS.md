# StaySphere Email OTP + Password Reset Patch

This patch is designed for the existing simple StaySphere architecture:
- Flask backend in backend/app.py
- React pages in frontend/src/pages
- Axios service at frontend/src/services/api.js
- MySQL database staysphere

## 1. Database
Import database/email_otp_migration.sql into the selected `staysphere` database.

Existing users are marked verified. New registrations should be inserted with email_verified=0.

## 2. Backend helper
Copy backend/otp_email.py into your project's backend folder, next to app.py.

At the top of backend/app.py add:

    from otp_email import generate_otp, hash_otp, verify_otp, send_otp_email

Then add the following helper functions after execute():

    def issue_otp(user, purpose):
        last = query(
            '''SELECT created_at
               FROM email_otps
               WHERE user_id=%s AND purpose=%s
               ORDER BY id DESC LIMIT 1''',
            (user['id'], purpose),
            True
        )

        if last and last['created_at'] > datetime.now() - timedelta(seconds=60):
            return False

        execute(
            '''UPDATE email_otps
               SET used_at=NOW()
               WHERE user_id=%s AND purpose=%s AND used_at IS NULL''',
            (user['id'], purpose)
        )

        otp = generate_otp()
        oid = execute(
            '''INSERT INTO email_otps
               (user_id,purpose,otp_hash,expires_at)
               VALUES(%s,%s,%s,DATE_ADD(NOW(), INTERVAL 10 MINUTE))''',
            (user['id'], purpose, hash_otp(otp))
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
                'UPDATE email_otps SET used_at=NOW() WHERE id=%s',
                (oid,)
            )
            raise

        return True


    def consume_otp(user_id, purpose, otp):
        row = query(
            '''SELECT *
               FROM email_otps
               WHERE user_id=%s
                 AND purpose=%s
                 AND used_at IS NULL
                 AND expires_at > NOW()
               ORDER BY id DESC LIMIT 1''',
            (user_id, purpose),
            True
        )

        if not row:
            return False, 'OTP is invalid or expired.'

        if int(row['attempts']) >= 5:
            return False, 'Too many incorrect attempts. Request a new OTP.'

        if not verify_otp(otp, row['otp_hash']):
            execute(
                'UPDATE email_otps SET attempts=attempts+1 WHERE id=%s',
                (row['id'],)
            )
            return False, 'Incorrect OTP.'

        execute(
            'UPDATE email_otps SET used_at=NOW() WHERE id=%s',
            (row['id'],)
        )
        return True, None

## 3. Replace /api/auth/register

Replace your current register() function with:

    @app.post('/api/auth/register')
    def register():
        d = request.get_json() or {}

        for x in ['full_name','email','phone','password']:
            if not d.get(x):
                return jsonify({'message':'All required fields must be filled'}),400

        email = d['email'].strip().lower()
        phone = d['phone'].strip()

        if len(d['password']) < 8:
            return jsonify({'message':'Password must contain at least 8 characters'}),400

        if query(
            'SELECT id FROM users WHERE email=%s OR phone=%s',
            (email, phone),
            True
        ):
            return jsonify({'message':'Email or phone already registered'}),409

        ph = bcrypt.hashpw(
            d['password'].encode(),
            bcrypt.gensalt()
        ).decode()

        uid = execute(
            '''INSERT INTO users
               (full_name,email,phone,password_hash,address,email_verified)
               VALUES(%s,%s,%s,%s,%s,0)''',
            (
                d['full_name'],
                email,
                phone,
                ph,
                d.get('address')
            )
        )

        user = query(
            'SELECT id,full_name,email FROM users WHERE id=%s',
            (uid,),
            True
        )

        try:
            issue_otp(user, 'verify_email')
        except Exception as e:
            app.logger.exception(e)
            return jsonify({
                'message':'Account created, but verification email could not be sent. Check SMTP settings and use Resend OTP.'
            }),500

        return jsonify({
            'message':'Account created. Verification OTP sent to your email.',
            'email':email
        }),201

## 4. Replace /api/auth/login

Replace your login() with this version. It also keeps your last-login tracking:

    @app.post('/api/auth/login')
    def login():
        d = request.get_json() or {}
        identifier = d.get('identifier','').strip()

        u = query(
            'SELECT * FROM users WHERE email=%s OR phone=%s',
            (identifier.lower(), identifier),
            True
        )

        if not u or not bcrypt.checkpw(
            d.get('password','').encode(),
            u['password_hash'].encode()
        ):
            return jsonify({'message':'Invalid email/mobile or password'}),401

        if u['account_status'] != 'active':
            return jsonify({'message':'Your account has been deactivated'}),403

        if not u.get('email_verified'):
            return jsonify({
                'message':'Please verify your email before logging in.',
                'email_verification_required':True,
                'email':u['email']
            }),403

        # Keep this if you already added last_login_at/login_count.
        try:
            execute(
                '''UPDATE users
                   SET last_login_at=NOW(),
                       login_count=login_count+1
                   WHERE id=%s''',
                (u['id'],)
            )
        except Exception:
            # This lets login still work if those optional columns
            # have not been added yet.
            pass

        return jsonify({
            'token':make_token(u['id']),
            'user':{
                'id':u['id'],
                'full_name':u['full_name'],
                'email':u['email'],
                'phone':u['phone']
            }
        })

## 5. Add authentication endpoints

Add these routes after login():

    @app.post('/api/auth/resend-verification')
    def resend_verification():
        d = request.get_json() or {}
        email = d.get('email','').strip().lower()

        user = query(
            'SELECT id,full_name,email,email_verified FROM users WHERE email=%s',
            (email,),
            True
        )

        if not user:
            return jsonify({'message':'Account not found'}),404

        if user['email_verified']:
            return jsonify({'message':'Email is already verified'}),400

        try:
            if not issue_otp(user, 'verify_email'):
                return jsonify({
                    'message':'Please wait 60 seconds before requesting another OTP.'
                }),429
        except Exception as e:
            app.logger.exception(e)
            return jsonify({'message':'Could not send verification email'}),500

        return jsonify({'message':'A new verification OTP was sent.'})


    @app.post('/api/auth/verify-email')
    def verify_email_route():
        d = request.get_json() or {}
        email = d.get('email','').strip().lower()
        otp = d.get('otp','').strip()

        user = query(
            'SELECT * FROM users WHERE email=%s',
            (email,),
            True
        )

        if not user:
            return jsonify({'message':'Account not found'}),404

        if user['email_verified']:
            return jsonify({
                'token':make_token(user['id']),
                'user':{
                    'id':user['id'],
                    'full_name':user['full_name'],
                    'email':user['email'],
                    'phone':user['phone']
                }
            })

        ok, error = consume_otp(
            user['id'],
            'verify_email',
            otp
        )

        if not ok:
            return jsonify({'message':error}),400

        execute(
            '''UPDATE users
               SET email_verified=1,
                   email_verified_at=NOW()
               WHERE id=%s''',
            (user['id'],)
        )

        return jsonify({
            'message':'Email verified successfully.',
            'token':make_token(user['id']),
            'user':{
                'id':user['id'],
                'full_name':user['full_name'],
                'email':user['email'],
                'phone':user['phone']
            }
        })


    @app.post('/api/auth/forgot-password')
    def forgot_password():
        d = request.get_json() or {}
        email = d.get('email','').strip().lower()

        user = query(
            'SELECT id,full_name,email FROM users WHERE email=%s',
            (email,),
            True
        )

        # Do not reveal whether an arbitrary email is registered.
        if user:
            try:
                issue_otp(user, 'reset_password')
            except Exception as e:
                app.logger.exception(e)
                return jsonify({
                    'message':'Could not send reset email. Check SMTP configuration.'
                }),500

        return jsonify({
            'message':'If that email is registered, a password reset OTP has been sent.'
        })


    @app.post('/api/auth/reset-password')
    def reset_password():
        d = request.get_json() or {}
        email = d.get('email','').strip().lower()
        otp = d.get('otp','').strip()
        password = d.get('password','')

        if len(password) < 8:
            return jsonify({
                'message':'Password must contain at least 8 characters'
            }),400

        user = query(
            'SELECT id FROM users WHERE email=%s',
            (email,),
            True
        )

        if not user:
            return jsonify({'message':'Invalid or expired reset request'}),400

        ok, error = consume_otp(
            user['id'],
            'reset_password',
            otp
        )

        if not ok:
            return jsonify({'message':error}),400

        password_hash = bcrypt.hashpw(
            password.encode(),
            bcrypt.gensalt()
        ).decode()

        execute(
            'UPDATE users SET password_hash=%s WHERE id=%s',
            (password_hash, user['id'])
        )

        execute(
            '''UPDATE email_otps
               SET used_at=NOW()
               WHERE user_id=%s AND used_at IS NULL''',
            (user['id'],)
        )

        return jsonify({
            'message':'Password reset successfully. You can now log in.'
        })

## 6. SMTP .env settings
Copy the lines from backend/env_additions.txt into backend/.env.

For Gmail, use an app password, not your normal Gmail password.

## 7. Frontend
Copy:
- VerifyEmail.jsx
- ForgotPassword.jsx
- ResetPassword.jsx

into frontend/src/pages/

### Update Register.jsx
Remove useAuth/login from the registration flow.
After successful registration navigate to:

    n(`/verify-email?email=${encodeURIComponent(d.email)}`)

instead of logging the user in immediately.

A complete simple submit block:

    try {
      await api.post('/auth/register', d);
      n(`/verify-email?email=${encodeURIComponent(d.email)}`);
    } catch (z) {
      se(z.response?.data?.message || 'Registration failed');
    }

### Update Login.jsx
Add a Forgot Password link underneath the password field:

    <p><Link to="/forgot-password">Forgot password?</Link></p>

If login returns email_verification_required, navigate to:

    /verify-email?email=THE_EMAIL

### Update App.jsx imports

    import VerifyEmail from './pages/VerifyEmail';
    import ForgotPassword from './pages/ForgotPassword';
    import ResetPassword from './pages/ResetPassword';

Add routes:

    <Route path="/verify-email" element={<VerifyEmail/>}/>
    <Route path="/forgot-password" element={<ForgotPassword/>}/>
    <Route path="/reset-password" element={<ResetPassword/>}/>

## 8. Test

### New account
Register -> email OTP -> verify -> logged in.

### Password reset
Login -> Forgot Password -> enter email -> reset OTP -> enter new password -> login with new password.

## Security behavior
- OTP expires after 10 minutes.
- Maximum 5 wrong OTP attempts.
- 60-second resend cooldown.
- Only OTP hashes are stored.
- Passwords remain bcrypt hashes and are never emailed or displayed.
