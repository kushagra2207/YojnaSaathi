import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import toast from 'react-hot-toast';
import './LoginPage.css';

function LoginPage() {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const { login } = useAuth();
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');

    if (!username.trim() || !password.trim()) {
      setError('Please enter both username and password.');
      return;
    }

    setLoading(true);
    try {
      await login(username.trim(), password);
      toast.success('Logged in successfully!');
      navigate('/');
    } catch (err) {
      setError(err.message || 'Login failed. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="login-page-container">
      {/* Left Area: Sleek, Decluttered Brand Showcase (>50% width on desktop) */}
      <section className="login-hero-area" aria-label="About YojnaSaathi Platform">
        {/* Subtle background glow accents */}
        <div className="hero-glow hero-glow-1" aria-hidden="true"></div>
        <div className="hero-glow hero-glow-2" aria-hidden="true"></div>
        <div className="hero-grid-pattern" aria-hidden="true"></div>

        <div className="hero-inner-content">
          {/* Brand Identity */}
          <div className="hero-brand">
            <div className="hero-brand-info">
              <h1 className="hero-brand-name">YojnaSaathi</h1>
              <span className="hero-brand-tagline">योजना साथी • Admin Portal</span>
            </div>
          </div>

          {/* Main Headline & Concise Subtitle */}
          <div className="hero-headline-block">
            <h2 className="hero-main-title">
              Bridging Welfare Schemes with Rural Communities
            </h2>
            <p className="hero-main-desc">
              Manage government welfare programs, publish village health advisories,
              and power offline-first access for field workers and rural families.
            </p>
          </div>

          {/* Clean, minimalist feature list without cluttered boxes */}
          <ul className="hero-features-list">
            <li className="feature-list-item">
              <span className="feature-check-icon" aria-hidden="true">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round">
                  <polyline points="20 6 9 17 4 12"></polyline>
                </svg>
              </span>
              <span>Welfare Scheme Management & Eligibility Criteria</span>
            </li>
            <li className="feature-list-item">
              <span className="feature-check-icon" aria-hidden="true">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round">
                  <polyline points="20 6 9 17 4 12"></polyline>
                </svg>
              </span>
              <span>Village Health Notice Board & Vaccination Drives</span>
            </li>
            <li className="feature-list-item">
              <span className="feature-check-icon" aria-hidden="true">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round">
                  <polyline points="20 6 9 17 4 12"></polyline>
                </svg>
              </span>
              <span>Offline-First Mobile Sync for Rural Citizens</span>
            </li>
          </ul>
        </div>
      </section>

      {/* Right Area: Login Box */}
      <section className="login-form-area" aria-label="Admin Sign In">
        <div className="login-card-container">
          <div className="login-card">
            {/* Header: On mobile shows the brand icon & name; on desktop shows admin portal title */}
            <div className="login-header">
              <div className="login-mobile-brand">
                <span className="mobile-brand-icon" aria-hidden="true">🏛️</span>
                <span className="mobile-brand-title">YojnaSaathi</span>
              </div>
              <h2 className="login-title">Sign In to Dashboard</h2>
              <p className="login-subtitle">
                Enter your administrative credentials to manage schemes and health notices.
              </p>
            </div>

            {/* Credential Form */}
            <form className="login-form" onSubmit={handleSubmit} noValidate>
              {error && (
                <div className="login-error" role="alert">
                  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="12" y1="8" x2="12" y2="12"></line>
                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                  </svg>
                  <span>{error}</span>
                </div>
              )}

              <div className="form-group">
                <label htmlFor="username">Username</label>
                <div className="input-field-wrapper">
                  <svg className="field-adornment-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                    <circle cx="12" cy="7" r="4"></circle>
                  </svg>
                  <input
                    id="username"
                    type="text"
                    value={username}
                    onChange={(e) => setUsername(e.target.value)}
                    placeholder="Enter your username"
                    autoComplete="username"
                    disabled={loading}
                    required
                  />
                </div>
              </div>

              <div className="form-group">
                <label htmlFor="password">Password</label>
                <div className="input-field-wrapper">
                  <svg className="field-adornment-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                    <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                  </svg>
                  <input
                    id="password"
                    type={showPassword ? 'text' : 'password'}
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    placeholder="Enter your password"
                    autoComplete="current-password"
                    disabled={loading}
                    required
                  />
                  <button
                    type="button"
                    className="password-toggle-btn"
                    onClick={() => setShowPassword(!showPassword)}
                    title={showPassword ? 'Hide password' : 'Show password'}
                    aria-label={showPassword ? 'Hide password' : 'Show password'}
                    disabled={loading}
                    tabIndex={-1}
                  >
                    {showPassword ? (
                      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                        <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
                        <line x1="1" y1="1" x2="23" y2="23"></line>
                      </svg>
                    ) : (
                      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                        <circle cx="12" cy="12" r="3"></circle>
                      </svg>
                    )}
                  </button>
                </div>
              </div>

              <button type="submit" className="login-btn" disabled={loading}>
                {loading ? (
                  <span className="btn-loading-content">
                    <span className="login-spinner" aria-hidden="true"></span>
                    <span>Signing in...</span>
                  </span>
                ) : (
                  <span className="btn-content">
                    <span>Sign In to Dashboard</span>
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                      <line x1="5" y1="12" x2="19" y2="12"></line>
                      <polyline points="12 5 19 12 12 19"></polyline>
                    </svg>
                  </span>
                )}
              </button>
            </form>
          </div>
        </div>
      </section>
    </div>
  );
}

export default LoginPage;
