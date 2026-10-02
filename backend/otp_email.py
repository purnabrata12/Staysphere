import os
import secrets
import smtplib
from email.message import EmailMessage

import bcrypt


def generate_otp():
    return f"{secrets.randbelow(900000) + 100000:06d}"


def hash_otp(otp):
    return bcrypt.hashpw(otp.encode("utf-8"), bcrypt.gensalt()).decode("utf-8")


def verify_otp(otp, otp_hash):
    try:
        return bcrypt.checkpw(
            otp.encode("utf-8"),
            otp_hash.encode("utf-8")
        )
    except Exception:
        return False


def send_otp_email(to_email, full_name, otp, purpose):
    host = os.getenv("SMTP_HOST", "smtp.gmail.com")
    port = int(os.getenv("SMTP_PORT", "587"))
    username = os.getenv("SMTP_USER")
    password = os.getenv("SMTP_PASSWORD")
    from_email = os.getenv("SMTP_FROM_EMAIL") or username
    from_name = os.getenv("SMTP_FROM_NAME", "StaySphere")

    if not username or not password or not from_email:
        raise RuntimeError(
            "SMTP is not configured. Add SMTP_USER, SMTP_PASSWORD "
            "and SMTP_FROM_EMAIL to backend/.env"
        )

    if purpose == "verify_email":
        subject = "Verify your StaySphere email"
        action = "verify your email address"
    else:
        subject = "Reset your StaySphere password"
        action = "reset your password"

    msg = EmailMessage()
    msg["Subject"] = subject
    msg["From"] = f"{from_name} <{from_email}>"
    msg["To"] = to_email

    msg.set_content(
        f"""Hello {full_name},

Your StaySphere OTP is:

{otp}

Use this code to {action}.

The code expires in 10 minutes.
If you did not request this, you can ignore this email.

StaySphere
"""
    )

    with smtplib.SMTP(host, port, timeout=20) as server:
        server.starttls()
        server.login(username, password)
        server.send_message(msg)