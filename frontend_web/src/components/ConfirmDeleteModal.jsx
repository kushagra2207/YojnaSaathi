import './FormModal.css';

function ConfirmDeleteModal({ isOpen, title, message, onConfirm, onCancel, loading }) {
  if (!isOpen) return null;

  return (
    <div className="modal-overlay" onClick={onCancel}>
      <div
        className="modal-content confirm-modal-content"
        onClick={(e) => e.stopPropagation()}
      >
        <div className="confirm-modal-body">
          <div className="confirm-modal-icon">⚠️</div>
          <h3>{title || 'Confirm Delete'}</h3>
          <p>{message || 'Are you sure you want to delete this item? This action cannot be undone.'}</p>
        </div>
        <div className="confirm-modal-footer">
          <button
            className="modal-btn modal-btn-cancel"
            onClick={onCancel}
            disabled={loading}
          >
            Cancel
          </button>
          <button
            className="modal-btn modal-btn-danger"
            onClick={onConfirm}
            disabled={loading}
          >
            {loading ? 'Deleting...' : 'Delete'}
          </button>
        </div>
      </div>
    </div>
  );
}

export default ConfirmDeleteModal;
