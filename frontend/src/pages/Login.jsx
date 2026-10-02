import { useState } from 'react';

import {
  Link,
  useNavigate
} from 'react-router-dom';

import api from '../services/api';

import {
  useAuth
} from '../context/AuthContext';

export default function Login() {

  const [data, setData] =
    useState({
      identifier: '',
      password: ''
    });

  const [error, setError] =
    useState('');

  const { login } =
    useAuth();

  const navigate =
    useNavigate();

  const submit =
    async (e) => {

      e.preventDefault();

      setError('');

      try {

        const response =
          await api.post(
            '/auth/login',
            data
          );

        login(
          response.data.user,
          response.data.token
        );

        navigate('/');

      } catch (err) {

        const response =
          err.response?.data;

        if (
          response
            ?.email_verification_required
        ) {

          navigate(
            `/verify-email?email=${encodeURIComponent(
              response.email
            )}`
          );

          return;
        }

        setError(
          response?.message ||
          'Login failed'
        );

      }
    };

  return (
    <div className="auth">

      <form onSubmit={submit}>

        <span>
          WELCOME BACK
        </span>

        <h1>
          Login to StaySphere
        </h1>

        {error && (
          <p className="err">
            {error}
          </p>
        )}

        <label>
          Email or mobile

          <input
            value={
              data.identifier
            }
            onChange={(e) =>
              setData({
                ...data,
                identifier:
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
            value={
              data.password
            }
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

        <p>
          <Link to="/forgot-password">
            Forgot password?
          </Link>
        </p>

        <button>
          Login
        </button>

        <p>
          New here?{' '}

          <Link to="/register">
            Create account
          </Link>
        </p>

      </form>

    </div>
  );
}