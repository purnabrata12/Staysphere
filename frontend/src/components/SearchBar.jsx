//import{useState}from'react';import{useNavigate}from'react-router-dom';export default function SearchBar(){const n=useNavigate();const[f,s]=useState({q:'',check_in:'',check_out:'',guests:2,rooms:1});return <form className="search" onSubmit={e=>{e.preventDefault();n('/hotels?'+new URLSearchParams(f))}}>{[['q','City or hotel','text'],['check_in','','date'],['check_out','','date'],['guests','','number'],['rooms','','number']].map(([k,p,t])=><input key={k} type={t} min="1" name={k} placeholder={p} value={f[k]} onChange={e=>s({...f,[k]:e.target.value})}/>)}<button>Search Hotels</button></form>}

import { useState } from 'react';
import { useNavigate } from 'react-router-dom';

export default function SearchBar() {
  const navigate = useNavigate();

  const [form, setForm] = useState({
    q: '',
    check_in: '',
    check_out: '',
    guests: 2,
    rooms: 1
  });

  const handleChange = (e) => {
    setForm({
      ...form,
      [e.target.name]: e.target.value
    });
  };

  const handleSubmit = (e) => {
    e.preventDefault();

    navigate(
      '/hotels?' + new URLSearchParams(form).toString()
    );
  };

  return (
    <form className="search" onSubmit={handleSubmit}>

      <div className="search-field destination-field">
        <label>Destination</label>
        <input
          type="text"
          name="q"
          placeholder="City or hotel"
          value={form.q}
          onChange={handleChange}
        />
      </div>

      <div className="search-field">
        <label>Check-in</label>
        <input
          type="date"
          name="check_in"
          value={form.check_in}
          onChange={handleChange}
        />
      </div>

      <div className="search-field">
        <label>Check-out</label>
        <input
          type="date"
          name="check_out"
          value={form.check_out}
          onChange={handleChange}
        />
      </div>

      <div className="search-field small-field">
        <label>Guests</label>
        <input
          type="number"
          name="guests"
          min="1"
          value={form.guests}
          onChange={handleChange}
        />
      </div>

      <div className="search-field small-field">
        <label>Rooms</label>
        <input
          type="number"
          name="rooms"
          min="1"
          value={form.rooms}
          onChange={handleChange}
        />
      </div>

      <button type="submit" className="search-button">
        Search Hotels
      </button>

    </form>
  );
}