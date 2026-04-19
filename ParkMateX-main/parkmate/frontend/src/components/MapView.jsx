import { useState } from 'react'
import { Search, SlidersHorizontal, MapPin } from 'lucide-react'

export default function MapView({ stats }) {
  const [selectedSlot, setSelectedSlot] = useState(null)
  const slots = stats.slots || []

  // Ensure we have a reasonable grid layout based on number of slots
  return (
    <div className="map-container">
      <div className="map-bg"></div>
      
      <div style={{padding: '20px', paddingBottom: '0'}}>
        <div className="search-bar">
          <Search size={20} color="#94a3b8" />
          <input type="text" placeholder="Where are you heading?" />
          <button className="search-btn-purple">
            <SlidersHorizontal size={18} />
          </button>
        </div>
      </div>

      <div className="map-layout" style={{flexDirection: 'column'}}>
        <div className="garage-card" style={{marginBottom: '20px'}}>
          <div style={{display: 'flex', justifyContent: 'space-between'}}>
            <div>
              <h2>Main<br/>Garage<br/>A</h2>
              <div style={{color: 'var(--text-main)', fontSize: '15px'}}>Level 2 &bull; Sector C</div>
            </div>
            <div style={{textAlign: 'right'}}>
              <div className="slots-badge">{stats.free}<br/>Slots<br/>Left</div>
            </div>
          </div>
        </div>

        <div className="grid-map-container" style={{background: 'var(--bg-card)', borderRadius: '24px 24px 0 0', flex: 1, paddingTop: '24px', margin: '0 -20px'}}>
          <div className="map-top-bar" style={{padding: '0 20px'}}>
            <div style={{fontSize: '12px', fontWeight: '700', color: 'var(--text-muted)'}}>CURRENT ZONE</div>
            <div style={{fontSize: '16px', fontWeight: '700', color: 'var(--primary)'}}>North Plaza Level 2</div>
          </div>
          
          <div className="map-grid-view" style={{margin: '0 20px'}}>
            {slots.length === 0 ? (
              <div style={{gridColumn: '1 / -1', textAlign: 'center', padding: '40px', color: 'var(--text-muted)'}}>No slots detected. Waiting for stream...</div>
            ) : (
                slots.map((s, idx) => {
                  const isFree = s.status === 'free';
                  const colorClass = isFree ? 'green' : 'red';
                  const isSelected = selectedSlot === s.id;
                  
                  return (
                    <div 
                      key={s.id} 
                      className={`g-slot ${colorClass}`}
                      style={{ border: isSelected ? '3px solid #1e1b4b' : 'none', cursor: 'pointer' }}
                      onClick={() => setSelectedSlot(s.id)}
                    >
                      <span>{s.id}</span>
                      {isSelected && <span style={{fontSize: '10px', marginTop:'4px'}}>BEST</span>}
                    </div>
                  )
                })
            )}
          </div>

          <div className="g-legend">
            <div><span style={{background: 'var(--green-slot)'}}></span> AVAILABLE</div>
            <div><span style={{background: 'var(--red-slot)'}}></span> OCCUPIED</div>
            <div><span style={{background: '#e2e8f0'}}></span> INACTIVE</div>
          </div>

          {selectedSlot && (
            <div style={{padding: '20px'}}>
               <div className="reserve-btn">
                 <div>
                   <div style={{fontSize: '13px', opacity: 0.8}}>RESERVE SPOT {selectedSlot}</div>
                   <div className="price">$4.00<span style={{fontSize:'12px',fontWeight:'normal'}}>/HOUR</span></div>
                 </div>
                 <div style={{background: 'white', color: 'var(--primary)', padding: '8px 16px', borderRadius: '8px', fontWeight: 'bold'}}>
                   Select
                 </div>
               </div>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
