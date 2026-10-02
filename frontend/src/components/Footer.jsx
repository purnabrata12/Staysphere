import { Link } from 'react-router-dom';

export default function Footer() {
  return (
    <footer className="main-footer">

      <div className="footer-decoration"></div>

      <div className="footer-container">

        <div className="footer-brand">
          <h2>StaySphere</h2>

          <p>
            Find beautiful hotels, smart prices and memorable stays across India.
          </p>

          <div className="footer-socials">
            <a href="#" aria-label="Facebook">f</a>
            <a href="#" aria-label="Instagram">◎</a>
            <a href="#" aria-label="LinkedIn">in</a>
            <a href="#" aria-label="YouTube">▶</a>
          </div>
        </div>


        <div className="footer-column">
          <h3>Company</h3>

          <Link to="/about">About Us</Link>
          <Link to="/contact">Contact Us</Link>
          <Link to="/hotels">Hotels</Link>
          <Link to="/cities">Destinations</Link>
          <Link to="/offers">Offers</Link>
        </div>


        <div className="footer-column">
          <h3>Support</h3>

          <Link to="/support">Help & Support</Link>
          <Link to="/support">FAQ</Link>
          <Link to="/bookings">My Bookings</Link>
          <Link to="/contact">Contact Support</Link>
          <Link to="/support">Cancellation Help</Link>
        </div>


        <div className="footer-column">
          <h3>Legal</h3>

          <Link to="/terms">Terms & Conditions</Link>
          <Link to="/privacy">Privacy Policy</Link>
          <Link to="/support">Booking Policy</Link>
          <Link to="/support">Cancellation Policy</Link>
        </div>


        <div className="footer-help">
          <h3>Need Help?</h3>

          <p>
            Have a booking question or need assistance?
          </p>

          <Link to="/support" className="footer-support-button">
            Get Support →
          </Link>
        </div>

      </div>


      <div className="footer-bottom">

        <p>
          © {new Date().getFullYear()} StaySphere. All rights reserved.
        </p>

        <p>
          Your stay. Your journey. Your StaySphere.
        </p>

      </div>

    </footer>
  );
}