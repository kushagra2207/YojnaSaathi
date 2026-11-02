import { useState, useEffect } from 'react';
import './FormModal.css';

const TYPES = [
  { value: 'camp', label: 'Camp' },
  { value: 'notice', label: 'Notice' },
  { value: 'outbreak_warning', label: 'Outbreak Warning' },
  { value: 'medicine_availability', label: 'Medicine Availability' },
];

const EMPTY_FORM = {
  title: '',
  description: '',
  type: 'camp',
  location: '',
  event_date: '',
};

function HealthNoticeFormModal({ isOpen, onClose, onSubmit, initialData, loading }) {
  const [formData, setFormData] = useState(EMPTY_FORM);

  useEffect(() => {
    if (isOpen) {
      if (initialData) {
        setFormData({
          title: initialData.title || '',
          description: initialData.description || '',
          type: initialData.type || 'camp',
          location: initialData.location || '',
          event_date: initialData.event_date
            ? initialData.event_date.substring(0, 10)
            : '',
        });
      } else {
        setFormData(EMPTY_FORM);
      }
    }
  }, [isOpen, initialData]);

  if (!isOpen) return null;

  const isEditing = !!initialData;

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    const payload = { ...formData };
    if (!payload.event_date) {
      payload.event_date = null;
    }
    onSubmit(payload);
  };

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-content" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header">
          <h2>{isEditing ? 'Edit Health Notice' : 'Add New Notice'}</h2>
          <button className="modal-close-btn" onClick={onClose}>×</button>
        </div>
        <form onSubmit={handleSubmit}>
          <div className="modal-body">
            <div className="modal-form">
              <div className="modal-form-group">
                <label htmlFor="notice-title">Title</label>
                <input
                  id="notice-title"
                  type="text"
                  name="title"
                  value={formData.title}
                  onChange={handleChange}
                  placeholder="Enter notice title"
                  required
                />
              </div>
              <div className="modal-form-group">
                <label htmlFor="notice-description">Description</label>
                <textarea
                  id="notice-description"
                  name="description"
                  value={formData.description}
                  onChange={handleChange}
                  placeholder="Enter description"
                  required
                />
              </div>
              <div className="modal-form-group">
                <label htmlFor="notice-type">Type</label>
                <select
                  id="notice-type"
                  name="type"
                  value={formData.type}
                  onChange={handleChange}
                  required
                >
                  {TYPES.map((t) => (
                    <option key={t.value} value={t.value}>
                      {t.label}
                    </option>
                  ))}
                </select>
              </div>
              <div className="modal-form-group">
                <label htmlFor="notice-location">Location</label>
                <input
                  id="notice-location"
                  type="text"
                  name="location"
                  value={formData.location}
                  onChange={handleChange}
                  placeholder="Enter location"
                  required
                />
              </div>
              <div className="modal-form-group">
                <label htmlFor="notice-event-date">Event Date (optional)</label>
                <input
                  id="notice-event-date"
                  type="date"
                  name="event_date"
                  value={formData.event_date}
                  onChange={handleChange}
                />
              </div>
            </div>
          </div>
          <div className="modal-footer">
            <button
              type="button"
              className="modal-btn modal-btn-cancel"
              onClick={onClose}
              disabled={loading}
            >
              Cancel
            </button>
            <button
              type="submit"
              className="modal-btn modal-btn-primary"
              disabled={loading}
            >
              {loading ? 'Saving...' : isEditing ? 'Update Notice' : 'Create Notice'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

export default HealthNoticeFormModal;
