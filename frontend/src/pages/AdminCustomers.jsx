import { useEffect, useState } from 'react';
import api from '../services/api';

export default function AdminCustomers() {
  const [customers, setCustomers] = useState([]);
  const [selected, setSelected] = useState(null);
  const [search, setSearch] = useState('');

  const loadCustomers = async () => {
    try {
      const res = await api.get('/admin/customers');
      setCustomers(res.data);
    } catch (error) {
      console.error(error);
    }
  };

  useEffect(() => {
    loadCustomers();
  }, []);

  const changeStatus = async (id, status) => {
    try {
      await api.put(`/admin/customers/${id}/status`, {
        status
      });

      await loadCustomers();
    } catch (error) {
      console.error(error);
    }
  };

  const formatDate = (value) => {
    if (!value) return 'Never';

    return new Date(value).toLocaleString('en-IN', {
      dateStyle: 'medium',
      timeStyle: 'short'
    });
  };

  const filtered = customers.filter((customer) => {
    const text = search.toLowerCase();

    return (
      customer.full_name?.toLowerCase().includes(text) ||
      customer.email?.toLowerCase().includes(text) ||
      customer.phone?.includes(search)
    );
  });

  return (
    <main className="admin-customers-page">
      <div className="wrap page">

        <div className="head">
          <div>
            <span>ADMIN</span>
            <h1>Customers</h1>
          </div>

          <b>{customers.length} Customers</b>
        </div>

        <div className="panel">

          <input
            type="text"
            placeholder="Search by name, email or phone..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            style={{
              width: '100%',
              padding: '12px',
              marginBottom: '20px',
              border: '1px solid #e4e8ef',
              borderRadius: '8px'
            }}
          />

          <div className="table">
            <table>
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Customer</th>
                  <th>Contact</th>
                  <th>Registered</th>
                  <th>Last Login</th>
                  <th>Logins</th>
                  <th>Bookings</th>
                  <th>Status</th>
                  <th>Details</th>
                </tr>
              </thead>

              <tbody>
                {filtered.map((customer) => (
                  <tr key={customer.id}>

                    <td>#{customer.id}</td>

                    <td>
                      <strong>{customer.full_name}</strong>
                    </td>

                    <td>
                      <div>{customer.email}</div>
                      <small>{customer.phone}</small>
                    </td>

                    <td>
                      {formatDate(customer.created_at)}
                    </td>

                    <td>
                      {formatDate(customer.last_login_at)}
                    </td>

                    <td>
                      {customer.login_count || 0}
                    </td>

                    <td>
                      {customer.total_bookings || 0}
                    </td>

                    <td>
                      <select
                        value={customer.account_status}
                        onChange={(e) =>
                          changeStatus(
                            customer.id,
                            e.target.value
                          )
                        }
                      >
                        <option value="active">
                          Active
                        </option>

                        <option value="inactive">
                          Inactive
                        </option>
                      </select>
                    </td>

                    <td>
                      <button
                        className="btn"
                        onClick={() => setSelected(customer)}
                      >
                        View
                      </button>
                    </td>

                  </tr>
                ))}
              </tbody>
            </table>
          </div>

        </div>

        {selected && (
          <div className="panel">

            <div className="head">
              <div>
                <span>CUSTOMER DETAILS</span>
                <h2>{selected.full_name}</h2>
              </div>

              <button
                className="danger"
                onClick={() => setSelected(null)}
              >
                Close
              </button>
            </div>

            <div className="customer-details">

              <p>
                <strong>Customer ID:</strong> #{selected.id}
              </p>

              <p>
                <strong>Full Name:</strong> {selected.full_name}
              </p>

              <p>
                <strong>Email:</strong> {selected.email}
              </p>

              <p>
                <strong>Phone:</strong> {selected.phone}
              </p>

              <p>
                <strong>Date of Birth:</strong>{' '}
                {selected.date_of_birth || 'Not provided'}
              </p>

              <p>
                <strong>Address:</strong>{' '}
                {selected.address || 'Not provided'}
              </p>

              <p>
                <strong>Account Status:</strong>{' '}
                {selected.account_status}
              </p>

              <p>
                <strong>Registered On:</strong>{' '}
                {formatDate(selected.created_at)}
              </p>

              <p>
                <strong>Last Login:</strong>{' '}
                {formatDate(selected.last_login_at)}
              </p>

              <p>
                <strong>Total Logins:</strong>{' '}
                {selected.login_count || 0}
              </p>

              <p>
                <strong>Total Bookings:</strong>{' '}
                {selected.total_bookings || 0}
              </p>

            </div>

            <div className="note">
              User passwords are securely hashed and are not visible to administrators.
            </div>

          </div>
        )}

      </div>
    </main>
  );
}