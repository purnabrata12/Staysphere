import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import api from "../services/api";

export default function ForgotPassword() {
  const [email, setEmail] = useState("");
  const [error, setError] = useState("");
  const [busy, setBusy] = useState(false);
  const navigate = useNavigate();

  const submit = async (e) => {
    e.preventDefault();
    setError("");

    try {
      setBusy(true);
      await api.post("/auth/forgot-password", { email });
      navigate(`/reset-password?email=${encodeURIComponent(email)}`);
    } catch (err) {
      setError(err.response?.data?.message || "Could not send reset OTP");
    } finally {
      setBusy(false);
    }
  };

  return (
    <div className="auth">
      <form onSubmit={submit}>
        <span>ACCOUNT RECOVERY</span>
        <h1>Forgot password</h1>

        {error && <p className="err">{error}</p>}

        <p>Enter your registered email. We will send a password reset OTP.</p>

        <label>
          Email
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
          />
        </label>

        <button disabled={busy}>
          {busy ? "Sending..." : "Send Reset OTP"}
        </button>

        <p>
          <Link to="/login">Back to login</Link>
        </p>
      </form>
    </div>
  );
}
