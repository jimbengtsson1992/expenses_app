enum Subcategory {
  // --- Boende (Housing) ---
  brfFee('Avgift BRF'),
  mortgage('Bolån & Amortering'),
  electricity('El'),
  homeInsurance('Hemförsäkring'),
  security('Larm & Säkerhet'),
  broadband('Bredband'),

  // --- Mat & Dryck (Food) ---
  groceries('Matbutik'),
  restaurant('Restaurant'),
  bar('Bar'),
  lunch('Lunch ute'),
  takeaway('Takeaway'),
  coffee('Kaffe & Fika'),
  alcohol('Systembolaget'),
  supplements('Kosttillskott'),

  // --- Försäkringar & abonnemang (Insurance & Subscriptions) ---
  personalInsurance('Personförsäkringar'),
  mobileSubscription('Mobilabonnemang'),
  newspapers('Tidningar'),
  streaming('Streaming'),

  // --- Shopping ---
  clothes('Kläder & Skor'),
  electronics('Elektronik'),
  furniture('Möbler'),
  gifts('Presenter'),
  decor('Inredning'),
  beauty('Skönhet'),

  // --- Nöje & fritid (Entertainment) ---
  travel('Resor'),
  hobby('Hobby'),
  boardGamesBooksAndToys('Brädspel, Böcker & Leksaker'),
  snuff('Snus'),
  videoGames('TV-spel'),

  // --- Hälsa (Health) ---
  gym('Träning'),
  pharmacy('Apotek'),
  doctor('Vård'),

  // --- Avgifter (Fees) ---
  bankFees('Bankavgifter'),
  tax('Skatt'),
  csn('CSN'),

  // --- Övrigt (Other / Admin) ---

  // --- Transport (Existing - Kept) ---
  taxi('Taxi'),
  publicTransport('Kollektivtrafik'),
  car('Bil'),
  fuel('Drivmedel'),
  parking('Parkering'),

  // --- Income (Existing - Kept) ---
  salary('Lön'),
  interest('Ränta'),

  // --- Defaults ---
  unknown('Okänd'),
  other('Övrigt');

  const Subcategory(this.displayName);
  final String displayName;
}
