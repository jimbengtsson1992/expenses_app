import 'package:expenses/src/features/trips/domain/trip.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const known = [
    KnownTripTransaction(
      tripId: 'florence-2026',
      descriptionContains: 'RYANAIR',
      amount: -2450.0,
      year: 2026,
      month: 6,
      day: 12,
    ),
  ];

  group('matchKnownTrip', () {
    test('matches on description substring, amount and date', () {
      expect(
        matchKnownTrip(
          'RYANAIR DUBLIN',
          -2450.0,
          DateTime(2026, 6, 12),
          known: known,
        ),
        'florence-2026',
      );
    });

    test('tolerates amount within 0.01', () {
      expect(
        matchKnownTrip(
          'RYANAIR',
          -2450.005,
          DateTime(2026, 6, 12),
          known: known,
        ),
        'florence-2026',
      );
    });

    test('returns null on wrong date, amount or description', () {
      expect(
        matchKnownTrip('RYANAIR', -2450.0, DateTime(2026, 6, 13), known: known),
        isNull,
      );
      expect(
        matchKnownTrip('RYANAIR', -2451.0, DateTime(2026, 6, 12), known: known),
        isNull,
      );
      expect(
        matchKnownTrip('SAS', -2450.0, DateTime(2026, 6, 12), known: known),
        isNull,
      );
    });

    test(
      'every entry in knownTripTransactions references a registered trip',
      () {
        for (final k in knownTripTransactions) {
          expect(
            tripById(k.tripId),
            isNotNull,
            reason: 'Unknown tripId ${k.tripId}',
          );
        }
      },
    );
  });
}
