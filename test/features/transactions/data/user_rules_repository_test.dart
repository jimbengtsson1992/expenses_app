import 'package:expenses/src/features/transactions/data/user_rules_repository.dart';
import 'package:expenses/src/features/transactions/domain/category.dart';
import 'package:expenses/src/features/transactions/domain/subcategory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('UserRulesRepository - Trip Assignments', () {
    late UserRulesRepository repo;
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      repo = UserRulesRepository(prefs);
      repo.load();
    });

    test('assignTrip and getTripId roundtrip', () async {
      await repo.assignTrip('tx1', 'florence-2026');

      expect(repo.getTripId('tx1'), 'florence-2026');
      expect(repo.getTripId('tx2'), isNull);
      expect(repo.getAllTripAssignments(), {'tx1': 'florence-2026'});
    });

    test('clearTrip removes the assignment', () async {
      await repo.assignTrip('tx1', 'florence-2026');
      await repo.clearTrip('tx1');

      expect(repo.getTripId('tx1'), isNull);
      expect(repo.getAllTripAssignments(), isEmpty);
    });

    test('trip assignments persist across a reload', () async {
      await repo.assignTrip('tx1', 'florence-2026');

      final repo2 = UserRulesRepository(prefs)..load();
      expect(repo2.getTripId('tx1'), 'florence-2026');
    });

    test('removeOverride removes a single override', () async {
      await repo.addOverride('tx1', Category.entertainment, Subcategory.travel);
      await repo.addOverride('tx2', Category.food, Subcategory.groceries);

      await repo.removeOverride('tx1');

      expect(repo.getOverride('tx1'), isNull);
      expect(repo.getOverride('tx2'), (Category.food, Subcategory.groceries));
    });

    test(
      'clearAll clears trip assignments (they are exported to code)',
      () async {
        await repo.assignTrip('tx1', 'florence-2026');
        await repo.addOverride(
          'tx1',
          Category.entertainment,
          Subcategory.travel,
        );

        await repo.clearAll();

        expect(repo.getOverride('tx1'), isNull);
        expect(repo.getTripId('tx1'), isNull);

        final repo2 = UserRulesRepository(prefs)..load();
        expect(repo2.getTripId('tx1'), isNull);
      },
    );
  });
}
