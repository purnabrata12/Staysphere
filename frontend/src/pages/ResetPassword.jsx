import { useState } from "react";
import { Link, useNavigate, useSearchParams } from "react-router-dom";
import api from "../services/api";

export default function ResetPassword() {
  const [params] = useSearchParams();
  const [data, setData] = useState({
    email: params.get("email") || "",
    otp: "",
    password: "",
    confirm: ""
  });

  const [error, setError] = useState("");
  const [message, setMessage] = useState("");
  const [busy, setBusy] = useState(false);
  const navigate = useNavigate();

  const update = (key, value) => {
    setData((old) => ({ ...old, [key]: value }));
  };

  const submit = async (e) => {
    e.preventDefault();
    setError("");
    setMessage("");

    if (data.password.length < 8) {
      setError("Password must contain at least 8 characters.");
      return;
    }

    if (data.password !== data.confirm) {
      setError("Passwords do not match.");
      return;
    }

    try {
      setBusy(true);
      const r = await api.post("/auth/reset-password", {
        email: data.email,
        otp: data.otp,
        password: data.password
      });

      setMessage(r.data.message || "Password reset successful.");

      setTimeout(() => {
        navigate("/login");
      }, 1200);
    } catch (err) {
      setError(err.response?.data?.message || "Password reset failed");
    } finally {
      setBusy(false);
    }
  };

  const resend = async () => {
    setError("");
    setMessage("");

    if (!data.email) {
      setError("Enter your email.");
      return;
    }

    try {
      setBusy(true);
      const r = await api.post("/auth/forgot-password", {
        email: data.email
      });
      setMessage(r.data.message || "A new reset OTP was sent.");
    } catch (err) {
      setError(err.response?.data?.message || "Could not resend OTP");
    } finally {
      setBusy(false);
    }
  };

  return (
    <div className="auth">
      <form onSubmit={submit}>
        <span>RESET PASSWORD</span>
        <h1>Create new password</h1>

        {error && <p className="err">{error}</p>}
        {message && <p className="ok">{message}</p>}

        <label>
          Email
          <input
            type="email"
            value={data.email}
            onChange={(e) => update("email", e.target.value)}
            required
          />
        </label>

        <label>
          Reset OTP
          <input
            inputMode="numeric"
            maxLength="6"
            value={data.otp}
            onChange={(e) =>
              update("otp", e.target.value.replace(/\D/g, "").slice(0, 6))
            }
            required
          />
        </label>

        <label>
          New password
          <input
            type="password"
            value={data.password}
            onChange={(e) => update("password", e.target.value)}
            required
          />
        </label>

        <label>
          Confirm new password
          <input
            type="password"
            value={data.confirm}
            onChange={(e) => update("confirm", e.target.value)}
            required
          />
        </label>

        <button disabled={busy}>
          {busy ? "Please wait..." : "Reset Password"}
        </button>

        <p>
          Need another OTP?{" "}
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
            Resend
          </button>
        </p>

        <p>
          <Link to="/login">Back to login</Link>
        </p>
      </form>
    </div>
  );
}
