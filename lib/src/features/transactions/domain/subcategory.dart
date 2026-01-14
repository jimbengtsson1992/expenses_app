enum Subcategory {
  // --- Boende (Housing) ---
  brfFee('Avgift BRF'),
  mortgage('Bolån & Amortering'),
  electricity('El'),
  homeInsurance('Hemförsäkring'),
  broadband('Bredband'),

  // --- Mat & Dryck (Food) ---
  groceries('Matbutik'),
  restaurant('Restaurant'),
  bar('Bar'),
  lunch('Lunch ute'),
  takeaway('Takeaway'),
  coffee('Kaffe & Fika'),

  // --- Försäkringar & abonnemang (Insurance & Subscriptions) ---
  personalInsurance('Personförsäkringar'),
  mobileSubscription('Mobilabonnemang'),
  cloudServices('Molntjänster'),
  newspapers('Tidningar'),
  streaming('Streaming'),

  // --- Shopping ---
  clothes('Kläder & Skor'),
  electronics('Elektronik'),
  furniture('Möbler'),
  gifts('Presenter'),
  decor('Inredning'),

  // --- Nöje & fritid (Entertainment) ---
  travel('Resor'),
  hobby('Hobby'),
  boardGamesBooksAndToys('Brädspel, Böcker & Leksaker'),

  // --- Hälsa (Health) ---
  gym('Träning'),
  pharmacy('Apotek'),
  doctor('Vård'),

  // --- Avgifter (Fees) ---
  bankFees('Bankavgifter'),

  // --- Övrigt (Other / Admin) ---
  tax('Skatt'),

  // --- Transport (Existing - Kept) ---
  taxi('Taxi'),
  publicTransport('Kollektivtrafik'),
  car('Bil'),
  fuel('Drivmedel'),
  parking('Parkering'),

  // --- Income (Existing - Kept) ---
  salary('Lön'),

  // --- Defaults ---
  unknown('Unknown'),
  other('Other');

  const Subcategory(this.displayName);
  final String displayName;
}
