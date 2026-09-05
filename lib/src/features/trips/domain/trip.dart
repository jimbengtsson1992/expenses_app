/// A trip that transactions can be manually tagged to, so the total cost
/// can be tracked across months. Add a new const entry to [allTrips] to
/// register a new trip — no codegen needed.
class Trip {
  const Trip({required this.id, required this.name, this.emoji = '✈️'});

  final String id;
  final String name;
  final String emoji;
}

const allTrips = [Trip(id: 'florence-2026', name: 'Florens', emoji: '🇮🇹')];

Trip? tripById(String? id) {
  if (id == null) return null;
  for (final trip in allTrips) {
    if (trip.id == id) return trip;
  }
  return null;
}

/// A transaction hardcoded as belonging to a trip. Exported from the app via
/// "Exportera Regler & Overrides" after tagging in the UI, then added here so
/// the assignment survives reinstalls. Matched on description substring,
/// exact amount (±0.01) and date. The parser checks user assignments
/// (SharedPreferences) first, then this list.
class KnownTripTransaction {
  const KnownTripTransaction({
    required this.tripId,
    required this.descriptionContains,
    required this.amount,
    required this.year,
    required this.month,
    required this.day,
  });

  final String tripId;
  final String descriptionContains;
  final double amount;
  final int year;
  final int month;
  final int day;

  bool matches(String description, double amount, DateTime date) {
    return date.year == year &&
        date.month == month &&
        date.day == day &&
        (amount - this.amount).abs() < 0.01 &&
        description.contains(descriptionContains);
  }
}

const knownTripTransactions = <KnownTripTransaction>[
  // Example:
  // KnownTripTransaction(
  //   tripId: 'florence-2026',
  //   descriptionContains: 'RYANAIR',
  //   amount: -2450.0,
  //   year: 2026, month: 6, day: 12,
  // ),
  KnownTripTransaction(
    tripId: 'florence-2026',
    descriptionContains: 'DISCOVERCARS',
    amount: -6337.72,
    year: 2026,
    month: 7,
    day: 27,
  ),
  KnownTripTransaction(
    tripId: 'florence-2026',
    descriptionContains: 'SAS  1172548653233',
    amount: -655.0,
    year: 2026,
    month: 7,
    day: 5,
  ),
  KnownTripTransaction(
    tripId: 'florence-2026',
    descriptionContains: 'SAS  1172548653232',
    amount: -655.0,
    year: 2026,
    month: 7,
    day: 5,
  ),
  KnownTripTransaction(
    tripId: 'florence-2026',
    descriptionContains: 'CPH.DK',
    amount: -2065.54,
    year: 2026,
    month: 8,
    day: 6,
  ),
];

String? matchKnownTrip(
  String description,
  double amount,
  DateTime date, {
  List<KnownTripTransaction> known = knownTripTransactions,
}) {
  for (final k in known) {
    if (k.matches(description, amount, date)) return k.tripId;
  }
  return null;
}
