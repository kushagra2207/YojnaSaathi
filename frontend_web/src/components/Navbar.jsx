import { useAuth } from '../context/AuthContext';
import { useNavigate } from 'react-router-dom';
import './Navbar.css';

function Navbar() {
  const { logout } = useAuth();
  const navigate = useNavigate();

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  return (
    <nav className="navbar">
      <div className="navbar-brand">
        <span className="navbar-brand-icon">🏛️</span>
        <span>YojnaSaathi Admin</span>
      </div>
      <button className="navbar-logout-btn" onClick={handleLogout}>
        <span>↪</span>
        Logout
      </button>
    </nav>
  );
}

export default Navbar;
