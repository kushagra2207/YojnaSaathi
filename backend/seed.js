import db from './db/database.js';

// Sample welfare schemes
const schemes = [
  {
    title: 'Indira Gandhi National Old Age Pension Scheme',
    description: 'Monthly pension of ₹200-₹500 for senior citizens from BPL families. The amount varies by state — some states add their own contribution on top.',
    eligibility: 'Age 60 years or above, belongs to BPL (Below Poverty Line) family',
    documents_required: 'Aadhaar Card, Age Proof (birth certificate or school certificate), BPL Ration Card, Bank Passbook, Passport-size photo',
    where_to_apply: 'Gram Panchayat office or Block Development Office (BDO). Helpline: 1800-111-555',
    category: 'pension',
  },
  {
    title: 'Indira Gandhi National Widow Pension Scheme',
    description: 'Monthly pension of ₹300-₹500 for widows from BPL families aged 40-79 years. Helps widows meet basic needs.',
    eligibility: 'Widow, age 40-79 years, belongs to BPL family',
    documents_required: 'Aadhaar Card, Husband death certificate, BPL Ration Card, Bank Passbook, Passport-size photo',
    where_to_apply: 'Gram Panchayat office or District Social Welfare Office',
    category: 'pension',
  },
  {
    title: 'PM-KISAN Samman Nidhi',
    description: 'Direct cash transfer of ₹6,000 per year (in 3 instalments of ₹2,000) to small and marginal farmer families for farming expenses.',
    eligibility: 'Small and marginal farmer families with cultivable land. All farmer families with some exclusions (income tax payers, government employees).',
    documents_required: 'Aadhaar Card, Land ownership documents (Khatauni), Bank Passbook, Mobile number linked to Aadhaar',
    where_to_apply: 'Common Service Centre (CSC) or Gram Panchayat. Online: pmkisan.gov.in. Helpline: 155261',
    category: 'other',
  },
  {
    title: 'National Family Benefit Scheme',
    description: 'One-time grant of ₹20,000 to a BPL household on the death of the primary breadwinner (age 18-64 years).',
    eligibility: 'BPL family where the primary breadwinner (age 18-64) has passed away',
    documents_required: 'Death certificate of breadwinner, BPL certificate, Aadhaar Card of applicant, Bank Passbook, FIR copy (if unnatural death)',
    where_to_apply: 'District Social Welfare Office or Block Development Office',
    category: 'insurance',
  },
  {
    title: 'Pradhan Mantri Awas Yojana (Gramin)',
    description: 'Financial assistance of ₹1.20 lakh (plain areas) or ₹1.30 lakh (hilly areas) for building a pucca house for homeless or those living in kutcha/dilapidated houses.',
    eligibility: 'Homeless families or those living in kutcha house with 0-2 rooms. No motorised vehicle, no government job, no income tax payer.',
    documents_required: 'Aadhaar Card, BPL/SECC data list inclusion proof, Land documents, Bank Passbook, Passport-size photo, MGNREGA Job Card (if available)',
    where_to_apply: 'Gram Panchayat office. Online: pmayg.nic.in. Helpline: 1800-11-6446',
    category: 'housing',
  },
  {
    title: 'National Scholarship Portal — Pre-Matric Scholarship',
    description: 'Scholarship for students of Class 9-10 from minority communities. Covers admission fee, tuition fee, and maintenance allowance.',
    eligibility: 'Student of Class 9 or 10, belongs to minority community (Muslim, Christian, Sikh, Buddhist, Jain, Parsi), family annual income below ₹1 lakh',
    documents_required: 'Aadhaar Card, School bonafide certificate, Previous year marksheet, Income certificate, Community certificate, Bank Passbook',
    where_to_apply: 'Online: scholarships.gov.in. Verify at school or District Education Office.',
    category: 'scholarship',
  },
  {
    title: 'Ayushman Bharat – PM Jan Arogya Yojana',
    description: 'Free health insurance cover of ₹5 lakh per family per year for secondary and tertiary hospitalisation. Covers 1,500+ medical procedures.',
    eligibility: 'Families listed in SECC 2011 data or RSBY beneficiaries. No income criteria — identified by deprivation categories.',
    documents_required: 'Aadhaar Card, Ration Card, SECC list inclusion letter (if available). Ayushman card can be made at any empanelled hospital or CSC.',
    where_to_apply: 'Any Ayushman Bharat empanelled hospital. Helpline: 14555. Check eligibility: mera.pmjay.gov.in',
    category: 'healthcare',
  },
  {
    title: 'Antyodaya Anna Yojana',
    description: 'Subsidised food grains — 35 kg per family per month at ₹2/kg wheat and ₹3/kg rice for the poorest of poor families.',
    eligibility: 'Poorest of the poor families: landless labourers, marginal farmers, artisans, widows, disabled, destitute, rural households with no regular income',
    documents_required: 'AAY Ration Card (yellow card), Aadhaar Card. If not enrolled, apply with BPL certificate and income proof.',
    where_to_apply: 'Nearest Fair Price Shop (ration shop). Apply for AAY card at Food & Civil Supplies Department or Tehsil office.',
    category: 'ration',
  },
];

// Sample health notices
const healthNotices = [
  {
    title: 'Pulse Polio Vaccination Drive',
    description: 'Free polio drops for all children under 5 years. Bring your child to the nearest booth between 8 AM and 5 PM. No documents needed — just bring the child.',
    type: 'camp',
    location: 'All Anganwadi centres, Primary Health Centres, and designated booths across the district',
    event_date: '2026-11-15',
  },
  {
    title: 'Free Eye Check-up Camp',
    description: 'Free eye examination and spectacles distribution for senior citizens (60+ years). Cataract surgery referrals will also be given. First come, first served — arrive early.',
    type: 'camp',
    location: 'Community Hall, Block Headquarters, Rampur',
    event_date: '2026-11-20',
  },
  {
    title: 'Dengue Prevention Advisory',
    description: 'Dengue cases rising in the area. Remove stagnant water from coolers, pots, and tyres. Use mosquito nets at night. If you have high fever with body pain, visit PHC immediately. Do not self-medicate.',
    type: 'outbreak_warning',
    location: 'All wards of Nagar Panchayat, Sultanpur',
    event_date: null,
  },
  {
    title: 'Maternal Health Check-up Camp',
    description: 'Free ante-natal check-up for pregnant women. Includes blood test, BP check, weight monitoring, iron tablets, and ultrasound referral if needed. Bring your MCP card.',
    type: 'camp',
    location: 'Primary Health Centre, Lakhimpur',
    event_date: '2026-11-25',
  },
  {
    title: 'Paracetamol and ORS Available at PHC',
    description: 'Paracetamol, ORS packets, and iron tablets are now available at the Primary Health Centre. Villagers can collect free of cost by showing Aadhaar card. Limited stock — collect early.',
    type: 'medicine_availability',
    location: 'Primary Health Centre, Chandauli',
    event_date: null,
  },
  {
    title: 'TB Screening Camp',
    description: 'Free TB screening with sputum test and chest X-ray for anyone with cough lasting more than 2 weeks. Treatment is 100% free under NTEP. Bring Aadhaar card.',
    type: 'camp',
    location: 'District Hospital OPD, Varanasi',
    event_date: '2026-12-01',
  },
];

export function seedDatabase() {
  console.log('Seeding database...');

  const insertScheme = db.prepare(`
    INSERT INTO schemes (title, description, eligibility, documents_required, where_to_apply, category)
    VALUES (?, ?, ?, ?, ?, ?)
  `);

  const insertNotice = db.prepare(`
    INSERT INTO health_notices (title, description, type, location, event_date)
    VALUES (?, ?, ?, ?, ?)
  `);

  const seedAll = db.transaction(() => {
    // Clear existing data
    db.prepare('DELETE FROM schemes').run();
    db.prepare('DELETE FROM health_notices').run();

    for (const s of schemes) {
      insertScheme.run(s.title, s.description, s.eligibility, s.documents_required, s.where_to_apply, s.category);
    }

    for (const n of healthNotices) {
      insertNotice.run(n.title, n.description, n.type, n.location, n.event_date);
    }
  });

  seedAll();

  console.log(`Seeded ${schemes.length} schemes and ${healthNotices.length} health notices.`);
  console.log('Done!');
}

// Auto-run if executed directly via `node seed.js`
import { fileURLToPath } from 'url';
if (process.argv[1] === fileURLToPath(import.meta.url)) {
  seedDatabase();
}
