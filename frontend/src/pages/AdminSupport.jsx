import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import api from '../services/api';

export default function AdminSupport() {

  const [requests, setRequests] = useState([]);
  const [selected, setSelected] = useState(null);
  const [reply, setReply] = useState('');
  const [status, setStatus] = useState('new');
  const [message, setMessage] = useState('');
  const [saving, setSaving] = useState(false);


  const loadRequests = async () => {
    try {
      const res = await api.get('/admin/support');
      setRequests(res.data);
    } catch (err) {
      console.error(err);
    }
  };


  useEffect(() => {
    loadRequests();
  }, []);


  const openRequest = (item) => {
    setSelected(item);
    setReply(item.admin_reply || '');
    setStatus(item.status || 'new');
    setMessage('');
  };


  const saveReply = async () => {

    if (!selected) return;

    setSaving(true);
    setMessage('');

    try {

      const res = await api.put(
        `/admin/support/${selected.id}`,
        {
          status,
          admin_reply: reply
        }
      );

      setMessage(res.data.message);

      await loadRequests();

      setSelected({
        ...selected,
        status,
        admin_reply: reply
      });

    } catch (err) {

      setMessage(
        err.response?.data?.message ||
        'Could not save reply.'
      );

    }

    setSaving(false);
  };


  return (
    <main className="admin">

      <aside>
        <h2>StaySphere</h2>

        <Link to="/admin/dashboard">
          Overview
        </Link>

        <Link to="/admin/hotels">
          Hotels
        </Link>

        <Link to="/admin/bookings">
          Bookings
        </Link>

        <Link to="/admin/customers">
          Customers
        </Link>

        <Link to="/admin/support">
          Support Requests
        </Link>

        <Link to="/">
          Website
        </Link>
      </aside>


      <section>

        <div className="head">
          <div>
            <span>ADMIN</span>
            <h1>Support Requests</h1>
          </div>
        </div>


        <div className="panel table">

          <table>

            <thead>
              <tr>
                <th>ID</th>
                <th>Customer</th>
                <th>Email</th>
                <th>Issue</th>
                <th>Status</th>
                <th>Date</th>
                <th>Action</th>
              </tr>
            </thead>


            <tbody>

              {requests.map(item => (

                <tr key={item.id}>

                  <td>#{item.id}</td>

                  <td>
                    {item.full_name}
                  </td>

                  <td>
                    {item.email}
                  </td>

                  <td>
                    {item.subject}
                  </td>

                  <td>
                    {item.status === 'new'
                      ? 'New'
                      : item.status === 'in_progress'
                      ? 'In Progress'
                      : 'Resolved'}
                  </td>

                  <td>
                    {item.created_at
                      ? new Date(
                          item.created_at
                        ).toLocaleString()
                      : '-'}
                  </td>

                  <td>
                    <button
                      onClick={() =>
                        openRequest(item)
                      }
                    >
                      View / Reply
                    </button>
                  </td>

                </tr>

              ))}

            </tbody>

          </table>

          {requests.length === 0 && (
            <p>No support requests yet.</p>
          )}

        </div>


        {selected && (

          <div className="panel admin-support-reply">

            <h2>
              Request #{selected.id}
            </h2>


            <div className="support-admin-info">

              <p>
                <b>Customer:</b>{' '}
                {selected.full_name}
              </p>

              <p>
                <b>Email:</b>{' '}
                {selected.email}
              </p>

              <p>
                <b>Phone:</b>{' '}
                {selected.phone || '-'}
              </p>

              <p>
                <b>Issue:</b>{' '}
                {selected.subject}
              </p>

            </div>


            <div className="customer-problem">

              <h3>Customer Message</h3>

              <p>
                {selected.message}
              </p>

            </div>


            <label>
              Status
            </label>

            <select
              value={status}
              onChange={e =>
                setStatus(e.target.value)
              }
            >

              <option value="new">
                New
              </option>

              <option value="in_progress">
                In Progress
              </option>

              <option value="resolved">
                Resolved
              </option>

            </select>


            <label>
              Reply to Customer
            </label>

            <textarea
              rows="6"
              placeholder="Write your response to the customer..."
              value={reply}
              onChange={e =>
                setReply(e.target.value)
              }
            />


            {message && (
              <div className="support-message">
                {message}
              </div>
            )}


            <button
              onClick={saveReply}
              disabled={saving}
            >
              {saving
                ? 'Saving...'
                : 'Send Reply'}
            </button>

          </div>

        )}

      </section>

    </main>
  );
}