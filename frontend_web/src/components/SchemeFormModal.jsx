import { useState, useEffect } from 'react';
import './FormModal.css';

const CATEGORIES = [
  { value: 'pension', label: 'Pension' },
  { value: 'scholarship', label: 'Scholarship' },
  { value: 'ration', label: 'Ration' },
  { value: 'housing', label: 'Housing' },
  { value: 'insurance', label: 'Insurance' },
  { value: 'healthcare', label: 'Healthcare' },
  { value: 'employment', label: 'Employment' },
  { value: 'other', label: 'Other' },
];

const EMPTY_FORM = {
  title: '',
  description: '',
  eligibility: '',
  documents_required: '',
  where_to_apply: '',
  category: 'pension',
};

function SchemeFormModal({ isOpen, onClose, onSubmit, initialData, loading }) {
  const [formData, setFormData] = useState(EMPTY_FORM);

  useEffect(() => {
    if (isOpen) {
      if (initialData) {
        setFormData({
          title: initialData.title || '',
          description: initialData.description || '',
          eligibility: initialData.eligibility || '',
          documents_required: initialData.documents_required || '',
          where_to_apply: initialData.where_to_apply || '',
          category: initialData.category || 'pension',
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
    onSubmit(formData);
  };

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-content" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header">
          <h2>{isEditing ? 'Edit Scheme' : 'Add New Scheme'}</h2>
          <button className="modal-close-btn" onClick={onClose}>×</button>
        </div>
        <form onSubmit={handleSubmit}>
          <div className="modal-body">
            <div className="modal-form">
              <div className="modal-form-group">
                <label htmlFor="scheme-title">Title</label>
                <input
                  id="scheme-title"
                  type="text"
                  name="title"
                  value={formData.title}
                  onChange={handleChange}
                  placeholder="Enter scheme title"
                  required
                />
              </div>
              <div className="modal-form-group">
                <label htmlFor="scheme-description">Description</label>
                <textarea
                  id="scheme-description"
                  name="description"
                  value={formData.description}
                  onChange={handleChange}
                  placeholder="Enter scheme description"
                  required
                />
              </div>
              <div className="modal-form-group">
                <label htmlFor="scheme-eligibility">Eligibility</label>
                <textarea
                  id="scheme-eligibility"
                  name="eligibility"
                  value={formData.eligibility}
                  onChange={handleChange}
                  placeholder="Who is eligible for this scheme?"
                  required
                />
              </div>
              <div className="modal-form-group">
                <label htmlFor="scheme-documents">Documents Required</label>
                <textarea
                  id="scheme-documents"
                  name="documents_required"
                  value={formData.documents_required}
                  onChange={handleChange}
                  placeholder="List the required documents"
                  required
                />
              </div>
              <div className="modal-form-group">
                <label htmlFor="scheme-where">Where to Apply</label>
                <textarea
                  id="scheme-where"
                  name="where_to_apply"
                  value={formData.where_to_apply}
                  onChange={handleChange}
                  placeholder="Where can people apply for this scheme?"
                  required
                />
              </div>
              <div className="modal-form-group">
                <label htmlFor="scheme-category">Category</label>
                <select
                  id="scheme-category"
                  name="category"
                  value={formData.category}
                  onChange={handleChange}
                  required
                >
                  {CATEGORIES.map((cat) => (
                    <option key={cat.value} value={cat.value}>
                      {cat.label}
                    </option>
                  ))}
                </select>
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
              {loading ? 'Saving...' : isEditing ? 'Update Scheme' : 'Create Scheme'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

export default SchemeFormModal;
