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

    test('DISCOVERCARS 2026-07-27 is tagged florence-2026', () {
      expect(
        matchKnownTrip('DISCOVERCARS.COM', -6337.72, DateTime(2026, 7, 27)),
        'florence-2026',
      );
      expect(
        matchKnownTrip('DISCOVERCARS.COM', -6337.72, DateTime(2026, 7, 26)),
        isNull,
      );
    });

    test('SAS 1172548653233/32 2026-07-05 are tagged florence-2026', () {
      expect(
        matchKnownTrip('SAS  1172548653233', -655.0, DateTime(2026, 7, 5)),
        'florence-2026',
      );
      expect(
        matchKnownTrip('SAS  1172548653232', -655.0, DateTime(2026, 7, 5)),
        'florence-2026',
      );
      // Wrong date / amount must not match.
      expect(
        matchKnownTrip('SAS  1172548653233', -655.0, DateTime(2026, 7, 6)),
        isNull,
      );
      expect(
        matchKnownTrip('SAS  1172548653232', -656.0, DateTime(2026, 7, 5)),
        isNull,
      );
    });

    test('CPH.DK 2026-08-06 is tagged florence-2026', () {
      expect(
        matchKnownTrip('CPH.DK', -2065.54, DateTime(2026, 8, 6)),
        'florence-2026',
      );
      expect(matchKnownTrip('CPH.DK', -2065.54, DateTime(2026, 8, 7)), isNull);
      expect(matchKnownTrip('CPH.DK', -2000.0, DateTime(2026, 8, 6)), isNull);
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
