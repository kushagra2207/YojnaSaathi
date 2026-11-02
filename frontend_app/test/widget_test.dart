import 'package:flutter_test/flutter_test.dart';
import 'package:yojna_saathi_frontend_app/models/scheme.dart';
import 'package:yojna_saathi_frontend_app/models/health_notice.dart';

void main() {
  test('Scheme model parses JSON correctly', () {
    final scheme = Scheme.fromJson({
      'id': 1,
      'title': 'Test Scheme',
      'description': 'Description',
      'eligibility': 'Everyone',
      'documents_required': 'None',
      'where_to_apply': 'Panchayat',
      'category': 'pension',
      'created_at': '2026-01-01',
      'updated_at': '2026-01-01',
    });
    expect(scheme.id, 1);
    expect(scheme.title, 'Test Scheme');
    expect(scheme.category, 'pension');
  });

  test('HealthNotice model parses JSON correctly', () {
    final notice = HealthNotice.fromJson({
      'id': 1,
      'title': 'Test Camp',
      'description': 'Details',
      'type': 'camp',
      'location': 'PHC',
      'created_at': '2026-01-01',
      'updated_at': '2026-01-01',
    });
    expect(notice.id, 1);
    expect(notice.title, 'Test Camp');
    expect(notice.type, 'camp');
  });
}
