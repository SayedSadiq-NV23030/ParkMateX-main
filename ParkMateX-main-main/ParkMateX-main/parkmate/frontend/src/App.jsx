import { useState, useEffect } from 'react'
import { Home, Map as MapIcon, Clock, Settings } from 'lucide-react'
import HomeView from './components/HomeView'
import MapView from './components/MapView'
import ActivityView from './components/ActivityView'
import SettingsView from './components/SettingsView'
import './styles.css'

const API_BASE = import.meta.env.VITE_API_BASE || 'http://127.0.0.1:8000'
const USER_NAME = 'Abdelrahman Khaled'
const USER_AVATAR = '/PFP.jpg'
const USER_AVATAR_FALLBACK = 'https://api.dicebear.com/7.x/avataaars/svg?seed=AbdelrahmanKhaled'

export default function App() {
  const [activeTab, setActiveTab] = useState('home')
  const [darkMode, setDarkMode] = useState(() => {
    const saved = localStorage.getItem('parkmate-dark')
    return saved === 'true'
  })
  const [stats, setStats] = useState({
    total: 0,
    occupied: 0,
    free: 0,
    occupancy_percent: 0,
    slots: [],
    updated_at: null
  })

  useEffect(() => {
    localStorage.setItem('parkmate-dark', darkMode)
  }, [darkMode])

  useEffect(() => {
    const fetchStats = async () => {
      try {
        const res = await fetch(`${API_BASE}/api/stats`)
        const data = await res.json()
        if (data && typeof data === 'object') {
          setStats(data)
        }
      } catch (err) {
        console.error("Stats API error:", err)
      }
    }
    fetchStats()
    const id = setInterval(fetchStats, 1000)
    return () => clearInterval(id)
  }, [])

  return (
    <div className={`app-container ${darkMode ? 'dark' : ''}`}>
      {/* Top Header */}
      <header className="header-top">
        <div className="header-brand">
          <img src="/logo.png" alt="ParkMate" />
        </div>
        <div className="header-profile">
          <img
            src={USER_AVATAR}
            alt={USER_NAME}
            onError={(e) => {
              if (e.currentTarget.src !== USER_AVATAR_FALLBACK) {
                e.currentTarget.src = USER_AVATAR_FALLBACK
              }
            }}
          />
        </div>
      </header>

      {/* Main Content Area */}
      <main className="view-content">
        {activeTab === 'home' && <HomeView stats={stats} apiBase={API_BASE} />}
        {activeTab === 'map' && <MapView stats={stats} />}
        {activeTab === 'activity' && <ActivityView stats={stats} />}
        {activeTab === 'settings' && (
          <SettingsView
            darkMode={darkMode}
            setDarkMode={setDarkMode}
            userName={USER_NAME}
            userAvatar={USER_AVATAR}
            userAvatarFallback={USER_AVATAR_FALLBACK}
          />
        )}
      </main>

      {/* Bottom Navigation */}
      <nav className="bottom-nav">
        <button 
          className={`nav-item ${activeTab === 'home' ? 'active' : ''}`}
          onClick={() => setActiveTab('home')}
        >
          <Home size={22} />
          <span>Home</span>
        </button>
        <button 
          className={`nav-item ${activeTab === 'map' ? 'active-pill' : ''}`}
          onClick={() => setActiveTab('map')}
        >
          <MapIcon size={22} />
          <span>Map</span>
        </button>
        <button 
          className={`nav-item ${activeTab === 'activity' ? 'active-pill' : ''}`}
          onClick={() => setActiveTab('activity')}
        >
          <Clock size={22} />
          <span>Activity</span>
        </button>
        <button 
          className={`nav-item ${activeTab === 'settings' ? 'active-pill' : ''}`}
          onClick={() => setActiveTab('settings')}
        >
          <Settings size={22} />
          <span>Settings</span>
        </button>
      </nav>
    </div>
  )
}
