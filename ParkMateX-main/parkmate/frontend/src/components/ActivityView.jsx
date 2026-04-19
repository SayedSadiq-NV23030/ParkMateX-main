import { Activity, Clock, MapPin, Navigation } from 'lucide-react'

export default function ActivityView() {
  return (
    <div className="activity-container">
      <div className="activity-header">
        <h5 style={{color: 'var(--primary-light)', fontSize: '11px', fontWeight: '800', letterSpacing: '1px', textTransform: 'uppercase', marginBottom: '4px'}}>Real-Time Monitoring</h5>
        <h2>Live Activity</h2>
        <p>Stay updated with the latest movements in your preferred parking zones. Real-time availability tracking across 4 major hubs.</p>
      </div>

      <div className="tabs-toggle">
        <button className="tab-btn active">All Updates</button>
        <button className="tab-btn">Favorites</button>
      </div>

      <div style={{display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '16px'}}>
        <h3 style={{fontSize: '16px', fontWeight: '700'}}>Recent Updates</h3>
        <div style={{display: 'flex', alignItems: 'center', gap: '6px', fontSize: '12px', fontWeight: '700', color: 'var(--primary-light)'}}>
          <span style={{width: '6px', height: '6px', background: 'var(--primary-light)', borderRadius: '50%'}}></span>
          LIVE NOW
        </div>
      </div>

      <div className="updates-list">
        <div className="update-card">
          <div className="update-icon red"><Activity size={24} /></div>
          <div className="update-info">
            <div style={{display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start'}}>
                <h4 style={{fontWeight: '700', fontSize: '14px', marginBottom: '4px'}}>Central Plaza - Level B2</h4>
                <span className="update-time">2m ago</span>
            </div>
            <p style={{fontSize: '13px', color: 'var(--text-muted)'}}>Spot #402 has been <span style={{color: '#dc2626', fontWeight: '600'}}>Occupied</span>.</p>
          </div>
        </div>

        <div className="update-card">
          <div className="update-icon purple" style={{background: '#eff6ff', color: '#2563eb'}}>P</div>
          <div className="update-info">
             <div style={{display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start'}}>
                <h4 style={{fontWeight: '700', fontSize: '14px', marginBottom: '4px'}}>Skyline Tower Garage</h4>
                <span className="update-time">5m ago</span>
            </div>
            <p style={{fontSize: '13px', color: 'var(--text-muted)'}}>Spot #12 has become <span style={{color: '#2563eb', fontWeight: '600'}}>Available</span>.</p>
          </div>
        </div>

        <div className="update-card">
          <div className="update-icon purple" style={{background: '#eff6ff', color: '#2563eb'}}>P</div>
          <div className="update-info">
             <div style={{display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start'}}>
                <h4 style={{fontWeight: '700', fontSize: '14px', marginBottom: '4px'}}>West Side Hub</h4>
                <span className="update-time">12m ago</span>
            </div>
            <p style={{fontSize: '13px', color: 'var(--text-muted)'}}>Spot #88 has become <span style={{color: '#2563eb', fontWeight: '600'}}>Available</span>.</p>
          </div>
        </div>
      </div>

      <div className="zone-health-card">
        <h3>Zone Health</h3>
        
        <div style={{display: 'flex', justifyContent: 'space-between', fontSize: '11px', fontWeight: '700', letterSpacing: '0.5px', color: 'rgba(255,255,255,0.7)'}}>
          <span>CITY CENTER</span>
          <span>82% FULL</span>
        </div>
        <div className="progress-bar">
          <div className="progress-fill" style={{width: '82%', background: '#a855f7'}}></div>
        </div>

        <div style={{display: 'flex', justifyContent: 'space-between', fontSize: '11px', fontWeight: '700', letterSpacing: '0.5px', color: 'rgba(255,255,255,0.7)'}}>
          <span>EAST DISTRICT</span>
          <span>34% FULL</span>
        </div>
        <div className="progress-bar">
          <div className="progress-fill" style={{width: '34%', background: '#a855f7'}}></div>
        </div>

        <button style={{width: '100%', background: 'rgba(255,255,255,0.1)', border: 'none', color: 'white', padding: '12px', borderRadius: '8px', fontWeight: '600', marginTop: '8px'}}>View All Zones</button>
      </div>
    </div>
  )
}
