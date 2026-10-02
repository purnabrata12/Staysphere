import { useState } from "react";
import { Link, useNavigate, useSearchParams } from "react-router-dom";
import api from "../services/api";
import { useAuth } from "../context/AuthContext";

export default function VerifyEmail() {
  const [params] = useSearchParams();
  const [email, setEmail] = useState(params.get("email") || "");
  const [otp, setOtp] = useState("");
  const [message, setMessage] = useState("");
  const [error, setError] = useState("");
  const [busy, setBusy] = useState(false);

  const { login } = useAuth();
  const navigate = useNavigate();

  const verify = async (e) => {
    e.preventDefault();
    setError("");
    setMessage("");

    if (!email || !otp) {
      setError("Enter your email and 6-digit OTP.");
      return;
    }

    try {
      setBusy(true);
      const r = await api.post("/auth/verify-email", { email, otp });
      login(r.data.user, r.data.token);
      navigate("/");
    } catch (err) {
      setError(err.response?.data?.message || "Verification failed");
    } finally {
      setBusy(false);
    }
  };

  const resend = async () => {
    setError("");
    setMessage("");

    if (!email) {
      setError("Enter your email first.");
      return;
    }

    try {
      setBusy(true);
      const r = await api.post("/auth/resend-verification", { email });
      setMessage(r.data.message || "OTP sent.");
    } catch (err) {
      setError(err.response?.data?.message || "Could not resend OTP");
    } finally {
      setBusy(false);
    }
  };

  return (
    <div className="auth">
      <form onSubmit={verify}>
        <span>EMAIL VERIFICATION</span>
        <h1>Verify your email</h1>

        {error && <p className="err">{error}</p>}
        {message && <p className="ok">{message}</p>}

        <label>
          Email
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
          />
        </label>

        <label>
          6-digit OTP
          <input
            inputMode="numeric"
            maxLength="6"
            value={otp}
            onChange={(e) =>
              setOtp(e.target.value.replace(/\D/g, "").slice(0, 6))
            }
            required
          />
        </label>

        <button disabled={busy}>
          {busy ? "Please wait..." : "Verify Email"}
        </button>

        <p>
          Didn't get the code?{" "}
          <button
            type="button"
            onClick={resend}
            disabled={busy}
            style={{
              width: "auto",
              margin: 0,
              padding: 0,
              background: "none",
              color: "#2563eb"
            }}
          >
            Resend OTP
          </button>
        </p>

        <p>
          <Link to="/login">Back to login</Link>
        </p>
      </form>
    </div>
  );
}
