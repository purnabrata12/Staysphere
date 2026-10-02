import {
  useEffect,
  useRef,
  useState
} from 'react';

import {
  useLocation,
  useNavigate
} from 'react-router-dom';

import api from '../services/api';


export default function ChatBot() {

  const navigate = useNavigate();
  const location = useLocation();

  const messagesEndRef = useRef(null);

  const [open, setOpen] = useState(false);
  const [input, setInput] = useState('');

  const [loading, setLoading] = useState(false);

  const [awaitingSupport, setAwaitingSupport] =
    useState(false);

  const [messages, setMessages] = useState([
    {
      sender: 'bot',
      text:
        'Hi! 👋 I am the StaySphere Assistant.\n\n' +
        'I can help you with hotels, bookings, ' +
        'payments, cancellations and support.'
    }
  ]);


  /* =============================
     AUTO SCROLL
  ============================== */

  useEffect(() => {

    messagesEndRef.current?.scrollIntoView({
      behavior: 'smooth'
    });

  }, [messages, loading]);


  /* =============================
     ADD BOT MESSAGE
  ============================== */

  const addBotMessage = (
    text,
    action = null,
    actionText = null
  ) => {

    setMessages(prev => [
      ...prev,
      {
        sender: 'bot',
        text,
        action,
        actionText
      }
    ]);
  };


  /* =============================
     ERROR LOGIN MESSAGE
  ============================== */

  const loginRequired = () => {

    addBotMessage(
      'Please log in to use this feature.',
      'login',
      'Login to StaySphere'
    );

  };


  /* =============================
     LATEST BOOKING FROM MYSQL
  ============================== */

  const getLatestBooking = async () => {

    setLoading(true);

    try {

      const res = await api.get(
        '/bookings/user'
      );

      const bookings = res.data || [];


      if (bookings.length === 0) {

        addBotMessage(
          'You do not have any bookings yet.',
          'hotels',
          'Find a Hotel'
        );

        return;
      }


      const booking = bookings[0];


      const reply =
        `Here is your latest booking:\n\n` +

        `🏨 Hotel: ${
          booking.hotel_name || '-'
        }\n` +

        `📍 City: ${
          booking.city || '-'
        }\n` +

        `🛏 Room: ${
          booking.room_type || '-'
        }\n` +

        `🔖 Booking ID: ${
          booking.booking_code || booking.id
        }\n` +

        `📅 Check-in: ${
          formatDate(booking.check_in)
        }\n` +

        `📅 Check-out: ${
          formatDate(booking.check_out)
        }\n` +

        `💰 Amount: ₹${
          booking.total_amount || 0
        }\n` +

        `💳 Payment: ${
          formatText(
            booking.payment_status
          )
        }\n` +

        `✅ Booking Status: ${
          formatText(
            booking.booking_status
          )
        }`;


      addBotMessage(
        reply,
        'bookings',
        'Open My Bookings'
      );

    } catch (err) {

      if (
        err.response?.status === 401
      ) {

        loginRequired();

      } else {

        addBotMessage(
          'I could not load your booking right now. Please try again.'
        );

      }

    } finally {

      setLoading(false);

    }
  };


  /* =============================
     SUPPORT STATUS FROM MYSQL
  ============================== */

  const getSupportStatus = async () => {

    setLoading(true);

    try {

      const res = await api.get(
        '/support/my'
      );

      const requests = res.data || [];


      if (requests.length === 0) {

        addBotMessage(
          'You have not submitted any support requests yet.',
          'create-support',
          'Create Support Ticket'
        );

        return;
      }


      const item = requests[0];


      let reply =
        `Your latest support request:\n\n` +

        `🎫 Request #${item.id}\n` +

        `📌 Issue: ${item.subject}\n` +

        `📊 Status: ${
          formatText(item.status)
        }\n\n` +

        `Your Message:\n` +
        `${item.message}`;


      if (item.admin_reply) {

        reply +=
          `\n\n💬 StaySphere Support Reply:\n` +
          `${item.admin_reply}`;

      } else {

        reply +=
          `\n\n⏳ Our support team has not replied yet.`;

      }


      addBotMessage(
        reply,
        'support',
        'Open Support Page'
      );

    } catch (err) {

      if (
        err.response?.status === 401
      ) {

        loginRequired();

      } else {

        addBotMessage(
          'I could not load your support requests right now.'
        );

      }

    } finally {

      setLoading(false);

    }
  };


  /* =============================
     CREATE SUPPORT REQUEST
  ============================== */

  const createSupportRequest = async (
    problem
  ) => {

    setLoading(true);

    try {

      const res = await api.post(
        '/support',
        {
          subject: 'Chatbot Support',
          message: problem
        }
      );


      addBotMessage(
        `Your support request has been created successfully. ✅\n\n` +
        `Ticket ID: #${
          res.data.support_id
        }\n\n` +
        `You can check the admin reply from the Support page.`,
        'support',
        'View Support Requests'
      );


      setAwaitingSupport(false);

    } catch (err) {

      if (
        err.response?.status === 401
      ) {

        setAwaitingSupport(false);

        loginRequired();

      } else {

        addBotMessage(
          err.response?.data?.message ||
          'Could not create your support request.'
        );

      }

    } finally {

      setLoading(false);

    }
  };


  /* =============================
     CHAT MESSAGE PROCESSOR
  ============================== */

  const processMessage = async (
    userMessage
  ) => {

    const text =
      userMessage.toLowerCase();


    /* CUSTOMER IS DESCRIBING
       SUPPORT PROBLEM */

    if (awaitingSupport) {

      await createSupportRequest(
        userMessage
      );

      return;
    }


    /* GREETING */

    if (
      text === 'hi' ||
      text === 'hello' ||
      text === 'hey' ||
      text.includes('good morning') ||
      text.includes('good evening')
    ) {

      addBotMessage(
        'Hello! 👋\n\n' +
        'How can I help you today?\n\n' +
        'You can ask me about bookings, hotels, payments, cancellations or support.'
      );

      return;
    }


    /* LATEST BOOKING */

    if (
      text.includes('latest booking') ||
      text.includes('my booking') ||
      text.includes('booking status') ||
      text.includes('reservation status') ||
      text.includes('show booking')
    ) {

      await getLatestBooking();

      return;
    }


    /* SUPPORT STATUS */

    if (
      text.includes('support status') ||
      text.includes('my support') ||
      text.includes('admin reply') ||
      text.includes('ticket status') ||
      text.includes('support reply')
    ) {

      await getSupportStatus();

      return;
    }


    /* CREATE SUPPORT */

    if (
      text.includes('create support') ||
      text.includes('support ticket') ||
      text.includes('raise ticket') ||
      text.includes('still need help') ||
      text.includes('talk to support')
    ) {

      setAwaitingSupport(true);

      addBotMessage(
        'Of course. Please describe the problem you are facing.\n\n' +
        'Your next message will be sent to the StaySphere support team.'
      );

      return;
    }


    /* BOOK HOTEL */

    if (
      text.includes('book hotel') ||
      text.includes('how to book') ||
      text.includes('book a room')
    ) {

      addBotMessage(
        'To book a hotel:\n\n' +
        '1. Search your destination.\n' +
        '2. Select a hotel.\n' +
        '3. Choose a room.\n' +
        '4. Enter guest details.\n' +
        '5. Complete payment.',
        'hotels',
        'Browse Hotels'
      );

      return;
    }


    /* PAYMENT */

    if (
      text.includes('payment') ||
      text.includes('upi') ||
      text.includes('money deducted') ||
      text.includes('paid')
    ) {

      addBotMessage(
        'If your payment was successful but the booking is not visible, check My Bookings first.\n\n' +
        'If the problem continues, I can create a support ticket for you.',
        'create-support',
        'Create Support Ticket'
      );

      return;
    }


    /* REFUND */

    if (
      text.includes('refund')
    ) {

      addBotMessage(
        'Refunds depend on the booking and cancellation status.\n\n' +
        'If you have a refund problem, I can send the issue to StaySphere Support.',
        'create-support',
        'Request Support'
      );

      return;
    }


    /* CANCELLATION */

    if (
      text.includes('cancel booking') ||
      text.includes('cancellation') ||
      text.includes('cancel my')
    ) {

      addBotMessage(
        'Open My Bookings and select the booking you want to cancel.\n\n' +
        'Cancellation is available only when the booking is eligible.',
        'bookings',
        'Open My Bookings'
      );

      return;
    }


    /* FORGOT PASSWORD */

    if (
      text.includes('forgot password') ||
      text.includes('reset password')
    ) {

      addBotMessage(
        'You can reset your password using your registered email address. An OTP will be sent to your email.',
        'forgot',
        'Reset Password'
      );

      return;
    }


    /* LOGIN */

    if (
      text.includes('login') ||
      text.includes('sign in')
    ) {

      addBotMessage(
        'You can login using your registered email/mobile number and password.',
        'login',
        'Go to Login'
      );

      return;
    }


    /* REGISTER */

    if (
      text.includes('register') ||
      text.includes('sign up') ||
      text.includes('create account')
    ) {

      addBotMessage(
        'Create a StaySphere account using your name, email, phone number and password. You will verify your email using OTP.',
        'register',
        'Create Account'
      );

      return;
    }


    /* HOTEL */

    if (
      text.includes('hotel') ||
      text.includes('room') ||
      text.includes('stay')
    ) {

      addBotMessage(
        'You can explore StaySphere hotels, rooms, prices, amenities and guest ratings.',
        'hotels',
        'Explore Hotels'
      );

      return;
    }


    /* CITY */

    if (
      text.includes('city') ||
      text.includes('destination')
    ) {

      addBotMessage(
        'You can explore all available StaySphere destinations from the Cities page.',
        'cities',
        'Explore Cities'
      );

      return;
    }


    /* GENERAL HELP */

    if (
      text.includes('help') ||
      text.includes('problem') ||
      text.includes('issue') ||
      text.includes('support')
    ) {

      addBotMessage(
        'I can help with:\n\n' +
        '🏨 Hotel booking\n' +
        '📅 Booking status\n' +
        '💳 Payment problems\n' +
        '❌ Cancellation\n' +
        '💰 Refunds\n' +
        '🔐 Account problems\n' +
        '🎫 Support tickets',
        'create-support',
        'Create Support Ticket'
      );

      return;
    }


    /* UNKNOWN */

    addBotMessage(
      'I am not sure about that yet.\n\n' +
      'You can ask me about hotels, bookings, payments, cancellations, refunds or support.',
      'create-support',
      'Ask StaySphere Support'
    );
  };


  /* =============================
     SEND MESSAGE
  ============================== */

  const sendMessage = async (
    customMessage = null
  ) => {

    if (loading) {
      return;
    }


    const text =
      customMessage ||
      input.trim();


    if (!text) {
      return;
    }


    setMessages(prev => [
      ...prev,
      {
        sender: 'user',
        text
      }
    ]);


    setInput('');


    await processMessage(text);
  };


  /* =============================
     ACTION BUTTON
  ============================== */

  const handleAction = (
    action
  ) => {

    if (action === 'hotels') {
      navigate('/hotels');
      setOpen(false);
    }


    if (action === 'cities') {
      navigate('/cities');
      setOpen(false);
    }


    if (action === 'bookings') {
      navigate('/my-bookings');
      setOpen(false);
    }


    if (action === 'support') {
      navigate('/support');
      setOpen(false);
    }


    if (action === 'login') {
      navigate('/login');
      setOpen(false);
    }


    if (action === 'register') {
      navigate('/register');
      setOpen(false);
    }


    if (action === 'forgot') {
      navigate('/forgot-password');
      setOpen(false);
    }


    if (
      action === 'create-support'
    ) {

      setAwaitingSupport(true);

      addBotMessage(
        'Please describe your problem.\n\n' +
        'Your next message will be submitted directly to the StaySphere support team.'
      );

    }

  };


  /* =============================
     HELPERS
  ============================== */

  const formatText = (value) => {

    if (!value) {
      return '-';
    }

    return value
      .replaceAll('_', ' ')
      .replace(/\b\w/g, char =>
        char.toUpperCase()
      );
  };


  const formatDate = (value) => {

    if (!value) {
      return '-';
    }

    return new Date(
      value
    ).toLocaleDateString();
  };


  /* =============================
     DO NOT SHOW ON ADMIN
  ============================== */

  if (
    location.pathname.startsWith(
      '/admin'
    )
  ) {

    return null;
  }


  return (
    <>

      {/* FLOATING CHAT BUTTON */}

      <button
        className="chatbot-floating-button"
        onClick={() =>
          setOpen(!open)
        }
        aria-label="Open StaySphere Assistant"
      >
        {open ? '×' : '💬'}
      </button>



      {/* CHAT WINDOW */}

      {open && (

        <div className="chatbot-window">


          {/* HEADER */}

          <div className="chatbot-header">

            <div className="chatbot-avatar">
              S
            </div>


            <div>

              <h3>
                StaySphere Assistant
              </h3>

              <span>
                ● Online
              </span>

            </div>


            <button
              className="chatbot-close"
              onClick={() =>
                setOpen(false)
              }
            >
              ×
            </button>

          </div>



          {/* MESSAGES */}

          <div className="chatbot-messages">

            {messages.map(
              (message, index) => (

                <div
                  key={index}
                  className={
                    message.sender === 'user'
                      ? 'chat-message user-message'
                      : 'chat-message bot-message'
                  }
                >

                  <p>
                    {message.text}
                  </p>


                  {message.action && (

                    <button
                      className="chat-action-button"
                      onClick={() =>
                        handleAction(
                          message.action
                        )
                      }
                    >
                      {message.actionText}
                    </button>

                  )}

                </div>

              )
            )}


            {loading && (

              <div className="chat-message bot-message chatbot-thinking">

                <p>
                  StaySphere Assistant is checking...
                </p>

              </div>

            )}


            <div ref={messagesEndRef} />

          </div>



          {/* QUICK OPTIONS */}

          <div className="chatbot-quick-options">

            <button
              onClick={() =>
                sendMessage(
                  'Show my latest booking'
                )
              }
            >
              📅 My Booking
            </button>


            <button
              onClick={() =>
                sendMessage(
                  'Check my support status'
                )
              }
            >
              🎫 Support Status
            </button>


            <button
              onClick={() =>
                handleAction(
                  'create-support'
                )
              }
            >
              🎧 Create Ticket
            </button>


            <button
              onClick={() =>
                sendMessage(
                  'How do I book a hotel?'
                )
              }
            >
              🏨 Booking Help
            </button>

          </div>



          {/* INPUT */}

          <div className="chatbot-input-area">

            <input
              type="text"

              placeholder={
                awaitingSupport
                  ? 'Describe your problem...'
                  : 'Type your message...'
              }

              value={input}

              onChange={e =>
                setInput(
                  e.target.value
                )
              }

              onKeyDown={e => {

                if (
                  e.key === 'Enter'
                ) {

                  sendMessage();

                }

              }}
            />


            <button
              onClick={() =>
                sendMessage()
              }
              disabled={loading}
            >
              ➤
            </button>

          </div>



          {awaitingSupport && (

            <div className="chatbot-ticket-mode">

              🎫 Your next message will be
              sent to StaySphere Support.

              <button
                onClick={() =>
                  setAwaitingSupport(false)
                }
              >
                Cancel
              </button>

            </div>

          )}



          <div className="chatbot-footer-text">
            StaySphere Support Assistant
          </div>

        </div>

      )}

    </>
  );
}