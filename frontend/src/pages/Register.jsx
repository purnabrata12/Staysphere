import { useState } from 'react';
import {
  Link,
  useNavigate
} from 'react-router-dom';

import api from '../services/api';

export default function Register() {

  const [data, setData] = useState({
    full_name: '',
    email: '',
    phone: '',
    password: '',
    confirm: ''
  });

  const [error, setError] = useState('');

  const navigate = useNavigate();

  const submit = async (e) => {
    e.preventDefault();

    setError('');

    if (
      data.password !==
      data.confirm
    ) {
      setError(
        'Passwords do not match'
      );

      return;
    }

    try {

      await api.post(
        '/auth/register',
        data
      );

      navigate(
        `/verify-email?email=${encodeURIComponent(
          data.email
        )}`
      );

    } catch (err) {

      setError(
        err.response?.data?.message ||
        'Registration failed'
      );

    }
  };

  return (
    <div className="auth">

      <form onSubmit={submit}>

        <span>
          JOIN STAYSPHERE
        </span>

        <h1>
          Create account
        </h1>

        {error && (
          <p className="err">
            {error}
          </p>
        )}

        <label>
          Full name

          <input
            value={data.full_name}
            onChange={(e) =>
              setData({
                ...data,
                full_name:
                  e.target.value
              })
            }
            required
          />
        </label>

        <label>
          Email

          <input
            type="email"
            value={data.email}
            onChange={(e) =>
              setData({
                ...data,
                email:
                  e.target.value
              })
            }
            required
          />
        </label>

        <label>
          Mobile

          <input
            value={data.phone}
            onChange={(e) =>
              setData({
                ...data,
                phone:
                  e.target.value
              })
            }
            required
          />
        </label>

        <label>
          Password

          <input
            type="password"
            value={data.password}
            onChange={(e) =>
              setData({
                ...data,
                password:
                  e.target.value
              })
            }
            required
          />
        </label>

        <label>
          Confirm password

          <input
            type="password"
            value={data.confirm}
            onChange={(e) =>
              setData({
                ...data,
                confirm:
                  e.target.value
              })
            }
            required
          />
        </label>

        <button>
          Create Account
        </button>

        <p>
          Already registered?{' '}

          <Link to="/login">
            Login
          </Link>
        </p>

      </form>

    </div>
  );
}