import { useState, useEffect, useCallback } from 'react';
import toast from 'react-hot-toast';
import { get, post, put, del } from '../api/client';
import SchemeFormModal from './SchemeFormModal';
import ConfirmDeleteModal from './ConfirmDeleteModal';
import './SchemeSection.css';

function SchemeSection() {
  const [schemes, setSchemes] = useState([]);
  const [loading, setLoading] = useState(true);
  const [formOpen, setFormOpen] = useState(false);
  const [formLoading, setFormLoading] = useState(false);
  const [editingScheme, setEditingScheme] = useState(null);
  const [deleteTarget, setDeleteTarget] = useState(null);
  const [deleteLoading, setDeleteLoading] = useState(false);

  const fetchSchemes = useCallback(async () => {
    setLoading(true);
    try {
      const data = await get('/api/schemes');
      setSchemes(Array.isArray(data) ? data : []);
    } catch (err) {
      toast.error('Failed to load schemes: ' + err.message);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchSchemes();
  }, [fetchSchemes]);

  const handleAdd = () => {
    setEditingScheme(null);
    setFormOpen(true);
  };

  const handleEdit = (scheme) => {
    setEditingScheme(scheme);
    setFormOpen(true);
  };

  const handleFormClose = () => {
    setFormOpen(false);
    setEditingScheme(null);
  };

  const handleFormSubmit = async (formData) => {
    setFormLoading(true);
    try {
      if (editingScheme) {
        await put(`/api/schemes/${editingScheme.id}`, formData);
        toast.success('Scheme updated successfully!');
      } else {
        await post('/api/schemes', formData);
        toast.success('Scheme created successfully!');
      }
      handleFormClose();
      fetchSchemes();
    } catch (err) {
      toast.error('Failed to save scheme: ' + err.message);
    } finally {
      setFormLoading(false);
    }
  };

  const handleDeleteClick = (scheme) => {
    setDeleteTarget(scheme);
  };

  const handleDeleteConfirm = async () => {
    if (!deleteTarget) return;
    setDeleteLoading(true);
    try {
      await del(`/api/schemes/${deleteTarget.id}`);
      toast.success('Scheme deleted successfully!');
      setDeleteTarget(null);
      fetchSchemes();
    } catch (err) {
      toast.error('Failed to delete scheme: ' + err.message);
    } finally {
      setDeleteLoading(false);
    }
  };

  const handleDeleteCancel = () => {
    setDeleteTarget(null);
  };

  return (
    <div className="section-card">
      <div className="section-header">
        <div className="section-title">
          <span className="section-title-icon">📋</span>
          <h2>Welfare Schemes</h2>
        </div>
        <button className="section-add-btn" onClick={handleAdd}>
          <span>+</span> Add New Scheme
        </button>
      </div>

      <div className="section-body">
        {loading ? (
          <div className="section-loading">
            <div className="section-loading-spinner" />
            <p>Loading schemes...</p>
          </div>
        ) : schemes.length === 0 ? (
          <div className="section-empty">
            <span className="section-empty-icon">📭</span>
            <p>No schemes found. Add your first scheme!</p>
          </div>
        ) : (
          <div className="section-table-wrapper">
            <table className="section-table">
              <thead>
                <tr>
                  <th>Title</th>
                  <th>Category</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {schemes.map((scheme) => (
                  <tr key={scheme.id}>
                    <td>{scheme.title}</td>
                    <td>
                      <span className="category-badge">{scheme.category}</span>
                    </td>
                    <td>
                      <div className="action-btns">
                        <button
                          className="action-btn action-btn-edit"
                          onClick={() => handleEdit(scheme)}
                        >
                          Edit
                        </button>
                        <button
                          className="action-btn action-btn-delete"
                          onClick={() => handleDeleteClick(scheme)}
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

      <SchemeFormModal
        isOpen={formOpen}
        onClose={handleFormClose}
        onSubmit={handleFormSubmit}
        initialData={editingScheme}
        loading={formLoading}
      />

      <ConfirmDeleteModal
        isOpen={!!deleteTarget}
        title="Delete Scheme"
        message={`Are you sure you want to delete "${deleteTarget?.title}"? This action cannot be undone.`}
        onConfirm={handleDeleteConfirm}
        onCancel={handleDeleteCancel}
        loading={deleteLoading}
      />
    </div>
  );
}

export default SchemeSection;
