export default function SlotGrid({ slots = [] }) {
  return (
    <div className="card">
      <h3>Slots</h3>
      <div className="slot-grid">
        {slots.map((slot) => (
          <div
            key={slot.id}
            className={`slot ${slot.status === 'free' ? 'free' : 'occupied'}`}
          >
            <span>{slot.id}</span>
            <strong>{slot.status}</strong>
          </div>
        ))}
      </div>
    </div>
  )
}
