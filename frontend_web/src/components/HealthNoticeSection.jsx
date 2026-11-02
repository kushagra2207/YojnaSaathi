import { useState, useEffect, useCallback } from 'react';
import toast from 'react-hot-toast';
import { get, post, put, del } from '../api/client';
import HealthNoticeFormModal from './HealthNoticeFormModal';
import ConfirmDeleteModal from './ConfirmDeleteModal';
import './SchemeSection.css';

const TYPE_LABELS = {
  camp: 'Camp',
  notice: 'Notice',
  outbreak_warning: 'Outbreak Warning',
  medicine_availability: 'Medicine Availability',
};

function HealthNoticeSection() {
  const [notices, setNotices] = useState([]);
  const [loading, setLoading] = useState(true);
  const [formOpen, setFormOpen] = useState(false);
  const [formLoading, setFormLoading] = useState(false);
  const [editingNotice, setEditingNotice] = useState(null);
  const [deleteTarget, setDeleteTarget] = useState(null);
  const [deleteLoading, setDeleteLoading] = useState(false);

  const fetchNotices = useCallback(async () => {
    setLoading(true);
    try {
      const data = await get('/api/health-notices');
      setNotices(Array.isArray(data) ? data : []);
    } catch (err) {
      toast.error('Failed to load health notices: ' + err.message);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchNotices();
  }, [fetchNotices]);

  const handleAdd = () => {
    setEditingNotice(null);
    setFormOpen(true);
  };

  const handleEdit = (notice) => {
    setEditingNotice(notice);
    setFormOpen(true);
  };

  const handleFormClose = () => {
    setFormOpen(false);
    setEditingNotice(null);
  };

  const handleFormSubmit = async (formData) => {
    setFormLoading(true);
    try {
      if (editingNotice) {
        await put(`/api/health-notices/${editingNotice.id}`, formData);
        toast.success('Health notice updated successfully!');
      } else {
        await post('/api/health-notices', formData);
        toast.success('Health notice created successfully!');
      }
      handleFormClose();
      fetchNotices();
    } catch (err) {
      toast.error('Failed to save notice: ' + err.message);
    } finally {
      setFormLoading(false);
    }
  };

  const handleDeleteClick = (notice) => {
    setDeleteTarget(notice);
  };

  const handleDeleteConfirm = async () => {
    if (!deleteTarget) return;
    setDeleteLoading(true);
    try {
      await del(`/api/health-notices/${deleteTarget.id}`);
      toast.success('Health notice deleted successfully!');
      setDeleteTarget(null);
      fetchNotices();
    } catch (err) {
      toast.error('Failed to delete notice: ' + err.message);
    } finally {
      setDeleteLoading(false);
    }
  };

  const handleDeleteCancel = () => {
    setDeleteTarget(null);
  };

  const formatDate = (dateStr) => {
    if (!dateStr) return '—';
    try {
      return new Date(dateStr).toLocaleDateString('en-IN', {
        year: 'numeric',
        month: 'short',
        day: 'numeric',
      });
    } catch {
      return dateStr;
    }
  };

  return (
    <div className="section-card">
      <div className="section-header">
        <div className="section-title">
          <span className="section-title-icon">🏥</span>
          <h2>Health Notices & Camps</h2>
        </div>
        <button className="section-add-btn" onClick={handleAdd}>
          <span>+</span> Add New Notice
        </button>
      </div>

      <div className="section-body">
        {loading ? (
          <div className="section-loading">
            <div className="section-loading-spinner" />
            <p>Loading health notices...</p>
          </div>
        ) : notices.length === 0 ? (
          <div className="section-empty">
            <span className="section-empty-icon">📭</span>
            <p>No health notices found. Add your first notice!</p>
          </div>
        ) : (
          <div className="section-table-wrapper">
            <table className="section-table">
              <thead>
                <tr>
                  <th>Title</th>
                  <th>Type</th>
                  <th>Event Date</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {notices.map((notice) => (
                  <tr key={notice.id}>
                    <td>{notice.title}</td>
                    <td>
                      <span className={`type-badge ${notice.type}`}>
                        {TYPE_LABELS[notice.type] || notice.type}
                      </span>
                    </td>
                    <td>{formatDate(notice.event_date)}</td>
                    <td>
                      <div className="action-btns">
                        <button
                          className="action-btn action-btn-edit"
                          onClick={() => handleEdit(notice)}
                        >
                          Edit
                        </button>
                        <button
                          className="action-btn action-btn-delete"
                          onClick={() => handleDeleteClick(notice)}
                        >
                          Delete
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      <HealthNoticeFormModal
        isOpen={formOpen}
        onClose={handleFormClose}
        onSubmit={handleFormSubmit}
        initialData={editingNotice}
        loading={formLoading}
      />

      <ConfirmDeleteModal
        isOpen={!!deleteTarget}
        title="Delete Health Notice"
        message={`Are you sure you want to delete "${deleteTarget?.title}"? This action cannot be undone.`}
        onConfirm={handleDeleteConfirm}
        onCancel={handleDeleteCancel}
        loading={deleteLoading}
      />
    </div>
  );
}

export default HealthNoticeSection;

