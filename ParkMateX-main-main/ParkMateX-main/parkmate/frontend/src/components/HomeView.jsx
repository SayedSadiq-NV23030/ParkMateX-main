import { useEffect, useMemo, useRef, useState } from 'react'

export default function HomeView({ stats, apiBase }) {
  const [feedVersion, setFeedVersion] = useState(0)
  const [feedErrored, setFeedErrored] = useState(false)
  const retryTimerRef = useRef(null)

  const feedSrc = useMemo(
    () => `${apiBase}/video_feed?v=${feedVersion}`,
    [apiBase, feedVersion]
  )

  const scheduleReconnect = () => {
    if (retryTimerRef.current !== null) {
      return
    }

    retryTimerRef.current = window.setTimeout(() => {
      retryTimerRef.current = null
      setFeedVersion((prev) => prev + 1)
    }, 1200)
  }

  useEffect(() => {
    return () => {
      if (retryTimerRef.current !== null) {
        window.clearTimeout(retryTimerRef.current)
      }
    }
  }, [])

  return (
    <div className="home-container">
      <div className="home-video-card">
        <h3>Live Parking Feed</h3>
        <img
          src={feedSrc}
          alt="Parking Feed"
          onLoad={() => setFeedErrored(false)}
          onError={() => {
            setFeedErrored(true)
            scheduleReconnect()
          }}
        />
        {feedErrored && (
          <div style={{ fontSize: '12px', color: 'var(--text-muted)', marginTop: '8px' }}>
            Reconnecting live feed...
          </div>
        )}
      </div>

      <div style={{display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '16px'}}>
        <h3 style={{fontSize: '18px', fontWeight: '700'}}>Current Status</h3>
        <span style={{fontSize: '12px', color: 'var(--text-muted)'}}>Updated: {stats.updated_at ? new Date(stats.updated_at).toLocaleTimeString() : '...'}</span>
      </div>

      <div className="stats-grid-home">
        <div className="stat-card-home">
          <div className="stat-label">Available Slots</div>
          <div className="stat-value green">{stats.free}</div>
        </div>
        <div className="stat-card-home">
          <div className="stat-label">Occupied</div>
          <div className="stat-value red">{stats.occupied}</div>
        </div>
        <div className="stat-card-home">
          <div className="stat-label">Total Spaces</div>
          <div className="stat-value">{stats.total}</div>
        </div>
        <div className="stat-card-home">
          <div className="stat-label">Occupancy</div>
          <div className="stat-value accent">{stats.occupancy_percent}%</div>
        </div>
      </div>
    </div>
  )
}
