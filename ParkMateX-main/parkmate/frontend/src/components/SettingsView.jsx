import { Moon, RefreshCw, Globe, Bell, Shield, CreditCard, LogOut } from 'lucide-react'

export default function SettingsView({
  darkMode,
  setDarkMode,
  userName = 'Abdelrahman Khaled',
  userAvatar = '/PFP.jpg',
  userAvatarFallback = 'https://api.dicebear.com/7.x/avataaars/svg?seed=AbdelrahmanKhaled'
}) {
  return (
    <div className="settings-container">
      <div className="profile-card">
        <div className="avatar">
          <img
            src={userAvatar}
            alt={userName}
            style={{width: '100%', height: '100%', borderRadius: '16px'}}
            onError={(e) => {
              if (e.currentTarget.src !== userAvatarFallback) {
                e.currentTarget.src = userAvatarFallback
              }
            }}
          />
          <div style={{position: 'absolute', bottom: '-4px', right: '-4px', background: 'var(--accent)', color: 'white', width: '24px', height: '24px', borderRadius: '50%', display: 'flex', alignItems: 'center', justifyContent: 'center'}}>
            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg>
          </div>
        </div>
        <div className="profile-info">
          <h3>{userName}</h3>
          <p>abdelrahman.khaled@example.com</p>
          <div className="premium-pill">PREMIUM MEMBER</div>
        </div>
      </div>

      <div className="settings-section-title">General Settings</div>
      <div className="settings-group">
        <div className="settings-item">
          <div className="settings-item-left">
            <div className="settings-icon-wrap" style={{color: '#6d28d9'}}><Moon size={20} /></div>
            <div className="settings-item-text">
              <h4>Dark mode</h4>
              <p>Switch between light and dark themes</p>
            </div>
          </div>
          <div className={`toggle-switch ${darkMode ? 'on' : ''}`} onClick={() => setDarkMode(!darkMode)}>
            <div className="toggle-switch-circle"></div>
          </div>
        </div>

        <div className="settings-item">
          <div className="settings-item-left">
            <div className="settings-icon-wrap" style={{color: '#6d28d9'}}><Globe size={20} /></div>
            <div className="settings-item-text">
              <h4>Language</h4>
              <p>Select your preferred app language</p>
            </div>
          </div>
          <div style={{background: 'var(--border-color)', padding: '8px 12px', borderRadius: '8px', fontSize: '13px', fontWeight: '600'}}>
            English (US)
          </div>
        </div>
      </div>

      <div className="settings-section-title">Account</div>
      <div className="settings-group">
        <div className="settings-item">
          <div className="settings-item-left">
            <div className="settings-icon-wrap" style={{color: '#334155'}}><Bell size={20} /></div>
            <div className="settings-item-text">
              <h4>Notifications</h4>
            </div>
          </div>
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#94a3b8" strokeWidth="2"><path d="M9 18l6-6-6-6"/></svg>
        </div>

        <div className="settings-item">
          <div className="settings-item-left">
            <div className="settings-icon-wrap" style={{color: '#334155'}}><Shield size={20} /></div>
            <div className="settings-item-text">
              <h4>Security & Privacy</h4>
            </div>
          </div>
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#94a3b8" strokeWidth="2"><path d="M9 18l6-6-6-6"/></svg>
        </div>

        <div className="settings-item">
          <div className="settings-item-left">
            <div className="settings-icon-wrap" style={{color: '#334155'}}><CreditCard size={20} /></div>
            <div className="settings-item-text">
              <h4>Payment Methods</h4>
            </div>
          </div>
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#94a3b8" strokeWidth="2"><path d="M9 18l6-6-6-6"/></svg>
        </div>
      </div>

      <button className="logout-btn">
        <LogOut size={18} />
        Logout from ParkMate
      </button>
    </div>
  )
}
