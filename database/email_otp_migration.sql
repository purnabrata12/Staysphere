USE staysphere;

-- Existing users remain verified so current demo/customer accounts keep working.
ALTER TABLE users
    ADD COLUMN email_verified TINYINT(1) NOT NULL DEFAULT 1 AFTER account_status,
    ADD COLUMN email_verified_at DATETIME NULL AFTER email_verified;

CREATE TABLE IF NOT EXISTS email_otps (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    purpose ENUM('verify_email','reset_password') NOT NULL,
    otp_hash VARCHAR(255) NOT NULL,
    expires_at DATETIME NOT NULL,
    attempts INT NOT NULL DEFAULT 0,
    used_at DATETIME NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_otp_lookup (user_id, purpose, used_at, expires_at),
    CONSTRAINT fk_email_otps_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE
);

-- Mark all accounts that existed before this migration as already verified.
UPDATE users
SET email_verified = 1,
    email_verified_at = COALESCE(email_verified_at, NOW())
WHERE email_verified = 1;
