import { useEffect, useState } from 'react';
import api from '../services/api';

export default function Support() {

  const [user, setUser] = useState({
    full_name: '',
    email: ''
  });

  const [form, setForm] = useState({
    subject: '',
    message: ''
  });

  const [requests, setRequests] = useState([]);

  const [statusMessage, setStatusMessage] = useState('');
  const [loading, setLoading] = useState(false);


  const loadProfile = async () => {
    try {
      const res = await api.get('/profile');

      setUser({
        full_name: res.data.full_name || '',
        email: res.data.email || ''
      });

    } catch (err) {
      console.error('Could not load profile:', err);
    }
  };


  const loadRequests = async () => {
    try {

      const res = await api.get('/support/my');

      setRequests(res.data);

    } catch (err) {

      console.error(
        'Could not load support requests:',
        err
      );

    }
  };


  useEffect(() => {
    loadProfile();
    loadRequests();
  }, []);


  const handleChange = (e) => {

    setForm({
      ...form,
      [e.target.name]: e.target.value
    });

  };


  const handleSubmit = async (e) => {

    e.preventDefault();

    setLoading(true);
    setStatusMessage('');

    try {

      const res = await api.post(
        '/support',
        {
          subject: form.subject,
          message: form.message
        }
      );

      setStatusMessage(
        res.data.message
      );

      setForm({
        subject: '',
        message: ''
      });

      await loadRequests();

    } catch (err) {

      setStatusMessage(
        err.response?.data?.message ||
        'Could not submit your support request.'
      );

    }

    setLoading(false);
  };


  const formatStatus = (status) => {

    if (status === 'new') {
      return 'New';
    }

    if (status === 'in_progress') {
      return 'In Progress';
    }

    if (status === 'resolved') {
      return 'Resolved';
    }

    return status;
  };


  return (
    <div className="support-page">

      {/* =========================
          HERO
      ========================= */}

      <section className="support-hero">

        <span>
          STAYSPHERE SUPPORT
        </span>

        <h1>
          How can we help you?
        </h1>

        <p>
          Need help with a booking, payment,
          account or cancellation?
          Send us your request and our support
          team will assist you.
        </p>

      </section>



      {/* =========================
          SUPPORT FORM AREA
      ========================= */}

      <div className="support-container">

        {/* LEFT SIDE */}

        <div className="support-left">

          <div className="support-card">

            <div className="support-icon">
              ✉
            </div>

            <div>

              <h3>
                Email Support
              </h3>

              <p>
                Submit your problem and our
                support team will review it.
              </p>

            </div>

          </div>



          <div className="support-card">

            <div className="support-icon">
              ⌂
            </div>

            <div>

              <h3>
                Booking Help
              </h3>

              <p>
                Get help with reservations,
                hotel bookings and dates.
              </p>

            </div>

          </div>



          <div className="support-card">

            <div className="support-icon">
              ₹
            </div>

            <div>

              <h3>
                Payment & Refund
              </h3>

              <p>
                Get help with payments,
                refunds and booking charges.
              </p>

            </div>

          </div>



          <div className="support-card">

            <div className="support-icon">
              ✓
            </div>

            <div>

              <h3>
                Account Support
              </h3>

              <p>
                Problems with login,
                email verification or your account.
              </p>

            </div>

          </div>

        </div>



        {/* RIGHT SIDE FORM */}

        <form
          className="support-form"
          onSubmit={handleSubmit}
        >

          <h2>
            Send us a message
          </h2>

          <p>
            Tell us what problem you are facing.
          </p>


          {statusMessage && (

            <div className="support-message">
              {statusMessage}
            </div>

          )}


          <label>
            Your Name
          </label>

          <input
            type="text"
            value={user.full_name}
            readOnly
          />


          <label>
            Your Email
          </label>

          <input
            type="email"
            value={user.email}
            readOnly
          />


          <label>
            What do you need help with?
          </label>

          <select
            name="subject"
            value={form.subject}
            onChange={handleChange}
            required
          >

            <option value="">
              Select an issue
            </option>

            <option value="Booking Support">
              Booking Support
            </option>

            <option value="Payment / Refund">
              Payment / Refund
            </option>

            <option value="Account Problem">
              Account Problem
            </option>

            <option value="Cancellation">
              Cancellation
            </option>

            <option value="Hotel Information">
              Hotel Information
            </option>

            <option value="Other">
              Other
            </option>

          </select>


          <label>
            Message
          </label>

          <textarea
            name="message"
            rows="6"
            placeholder="Explain your problem..."
            value={form.message}
            onChange={handleChange}
            required
          />


          <button
            type="submit"
            disabled={loading}
          >

            {
              loading
                ? 'Sending...'
                : 'Send Support Request'
            }

          </button>

        </form>

      </div>



      {/* =========================
          MY SUPPORT REQUESTS
      ========================= */}

      <section className="my-support-section">

        <div className="my-support-header">

          <span>
            YOUR REQUESTS
          </span>

          <h2>
            My Support Requests
          </h2>

          <p>
            Track your problems and see replies
            from the StaySphere support team.
          </p>

        </div>


        <div className="my-support-list">

          {requests.length === 0 ? (

            <div className="support-empty">

              You have not submitted any
              support requests yet.

            </div>

          ) : (

            requests.map(item => (

              <div
                className="my-support-card"
                key={item.id}
              >

                {/* TOP */}

                <div className="support-card-top">

                  <div>

                    <span>
                      Request #{item.id}
                    </span>

                    <h3>
                      {item.subject}
                    </h3>

                  </div>


                  <div
                    className={
                      `support-status-badge ${item.status}`
                    }
                  >

                    {formatStatus(item.status)}

                  </div>

                </div>



                {/* CUSTOMER MESSAGE */}

                <div className="customer-support-message">

                  <strong>
                    Your Message
                  </strong>

                  <p>
                    {item.message}
                  </p>

                </div>



                {/* ADMIN REPLY */}

                <div className="admin-support-message">

                  <strong>
                    StaySphere Support
                  </strong>


                  {item.admin_reply ? (

                    <p>
                      {item.admin_reply}
                    </p>

                  ) : (

                    <p className="waiting-reply">

                      Our support team has not
                      replied yet.

                    </p>

                  )}

                </div>



                {/* DATE */}

                <div className="support-request-date">

                  Submitted:{' '}

                  {
                    item.created_at
                      ? new Date(
                          item.created_at
                        ).toLocaleString()
                      : '-'
                  }

                </div>

              </div>

            ))

          )}

        </div>

      </section>

    </div>
  );
}