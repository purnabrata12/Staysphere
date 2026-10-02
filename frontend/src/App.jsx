import { Routes, Route } from 'react-router-dom';

import Navbar from './components/Navbar';
import Footer from './components/Footer';
import ProtectedRoute from './components/ProtectedRoute';

import Home from './pages/Home';
import Hotels from './pages/Hotels';
import Cities from './pages/Cities';
import HotelDetails from './pages/HotelDetails';

import Login from './pages/Login';
import Register from './pages/Register';
import VerifyEmail from './pages/VerifyEmail';
import ForgotPassword from './pages/ForgotPassword';
import ResetPassword from './pages/ResetPassword';

import ChatBot from './components/ChatBot';

import Booking from './pages/Booking';
import Payment from './pages/Payment';
import BookingSuccess from './pages/BookingSuccess';
import MyBookings from './pages/MyBookings';
import Wishlist from './pages/Wishlist';
import Profile from './pages/Profile';
import Support from './pages/Support';


import AdminLogin from './pages/AdminLogin';
import AdminDashboard from './pages/AdminDashboard';
import AdminHotels from './pages/AdminHotels';
import AdminBookings from './pages/AdminBookings';
import AdminCustomers from './pages/AdminCustomers';
import AdminSupport from './pages/AdminSupport';

import Static from './pages/Static';


export default function App() {

  const P = ({ children }) => (
    <ProtectedRoute>
      {children}
    </ProtectedRoute>
  );

  return (
    <>
      <Navbar />

      <Routes>

        {/* PUBLIC ROUTES */}

        <Route path="/" element={<Home />} />

        <Route
          path="/hotels"
          element={<Hotels />}
        />

        <Route
          path="/hotels/:id"
          element={<HotelDetails />}
        />

        <Route
          path="/cities"
          element={<Cities />}
        />

        <Route
          path="/offers"
          element={
            <Static title="Offers">
              Weekend deals, city breaks and booking promotions appear here.
            </Static>
          }
        />


        {/* AUTH ROUTES */}

        <Route
          path="/login"
          element={<Login />}
        />

        <Route
          path="/register"
          element={<Register />}
        />

        <Route
          path="/verify-email"
          element={<VerifyEmail />}
        />

        <Route
          path="/forgot-password"
          element={<ForgotPassword />}
        />

        <Route
          path="/reset-password"
          element={<ResetPassword />}
        />


        {/* CUSTOMER PROTECTED ROUTES */}

        <Route
          path="/booking/:hotelId/:roomId"
          element={
            <P>
              <Booking />
            </P>
          }
        />

        <Route
          path="/payment/:id"
          element={
            <P>
              <Payment />
            </P>
          }
        />

        <Route
          path="/booking-success/:id"
          element={
            <P>
              <BookingSuccess />
            </P>
          }
        />

        <Route
          path="/my-bookings"
          element={
            <P>
              <MyBookings />
            </P>
          }
        />

        <Route
          path="/wishlist"
          element={
            <P>
              <Wishlist />
            </P>
          }
        />

        <Route
          path="/profile"
          element={
            <P>
              <Profile />
            </P>
          }
        />


        {/* SUPPORT - LOGIN REQUIRED */}

        <Route
          path="/support"
          element={
            <P>
              <Support />
            </P>
          }
        />


        {/* ADMIN ROUTES */}

        <Route
          path="/admin/login"
          element={<AdminLogin />}
        />

        <Route
          path="/admin/dashboard"
          element={<AdminDashboard />}
        />

        <Route
          path="/admin/customers"
          element={<AdminCustomers />}
        />

        <Route
          path="/admin/hotels"
          element={<AdminHotels />}
        />

        <Route
          path="/admin/bookings"
          element={<AdminBookings />}
        />

        <Route
          path="/admin/support"
          element={<AdminSupport />}
        />


        {/* 404 */}

        <Route
          path="*"
          element={
            <Static title="404">
              Page not found.
            </Static>
          }
        />

      </Routes>
      <ChatBot />
      <Footer />
    </>
  );
}