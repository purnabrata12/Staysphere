import{useEffect,useState}from'react';import{Link}from'react-router-dom';import api from'../services/api';export default function AdminDashboard(){const[s,setS]=useState(null),[b,setB]=useState([]);useEffect(()=>{api.get('/admin/dashboard').then(r=>setS(r.data));api.get('/admin/bookings').then(r=>setB(r.data.slice(0,8)))},[]);if(!s)return <div className="wrap page">Loading…</div>;return <main className="admin"><aside>
  <h2>StaySphere</h2>

  <Link to="/admin/dashboard">
    Overview
  </Link>

  <Link to="/admin/customers">
    Customers
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
</aside><section><div className="head"><div><span>ADMIN</span><h1>Dashboard</h1></div></div><div className="stats">{Object.entries(s).map(([k,v])=><div key={k}><span>{k.replaceAll('_',' ')}</span><b>{k==='revenue'?'₹'+Number(v).toLocaleString('en-IN'):v}</b></div>)}</div><div className="panel table"><h2>Recent Bookings</h2><table><thead><tr><th>ID</th><th>Customer</th><th>Hotel</th><th>Status</th><th>Amount</th></tr></thead><tbody>{b.map(x=><tr key={x.id}><td>{x.booking_code}</td><td>{x.customer}</td><td>{x.hotel_name}</td><td>{x.booking_status}</td><td>₹{Number(x.total_amount).toLocaleString('en-IN')}</td></tr>)}</tbody></table></div></section></main>}