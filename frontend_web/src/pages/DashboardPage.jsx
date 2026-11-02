import SchemeSection from '../components/SchemeSection';
import HealthNoticeSection from '../components/HealthNoticeSection';
import './DashboardPage.css';

function DashboardPage() {
  return (
    <div className="dashboard-page">
      <h1>Dashboard</h1>
      <div className="dashboard-sections">
        <SchemeSection />
        <HealthNoticeSection />
      </div>
    </div>
  );
}

export default DashboardPage;
