enum Subcategory {
  // --- Boende (Housing) ---
  brfFee('Avgift BRF'),
  mortgage('Bolån & Amortering'),
  electricity('El'),
  homeInsurance('Hemförsäkring'),
  security('Larm & Säkerhet'),
  broadband('Bredband'),
  cleaning('Städning'),
  kitchenRenovation('Köksrenovering'),

  // --- Mat & Dryck (Food) ---
  groceries('Matbutik'),
  restaurant('Restaurant'),
  bar('Bar & Klubb'),
  lunch('Lunch ute'),
  takeaway('Foodora & Takeaway'),
  alcohol('Systembolaget'),
  coffee('Kaffe & Fika'),

  // --- Shopping ---
  clothes('Kläder, Skor & Smycken'),
  electronics('Elektronik'),
  furniture('Möbler'),
  gifts('Presenter'),
  decor('Inredning'),
  beauty('Skönhet'),
  tools('Verktyg & Bygg'),
  dryCleaning('Kemtvätt'),

  // --- Nöje & fritid (Entertainment) ---
  travel('Resor'),
  hobby('Hobby'),
  boardGamesBooksAndToys('Brädspel, Böcker & Leksaker'),
  newspapers('Tidningar'),
  streaming('Streaming'),
  snuff('Snus'),
  videoGames('TV-spel'),

  // --- Hälsa (Health) ---
  gym('Träning'),
  pharmacy('Apotek'),
  doctor('Vård'),
  supplements('Kosttillskott'),

  // --- Avgifter (Fees) ---
  bankFees('Bankavgifter'),
  tax('Skatt'),
  csn('CSN'),
  jimHolding('Jim Holdingbolag'),

  // --- Transport ---
  taxi('Taxi & Voi'),
  publicTransport('Kollektivtrafik'),
  car('Bil'),
  fuel('Drivmedel'),
  parking('Parkering'),

  // --- Inkomst (Income) ---
  salary('Lön'),
  interest('Ränta'),
  loan('Lån'),

  // --- Övrigt (Other) ---
  personalInsurance('Personförsäkringar'),
  godfather('Fadder & Gudmor'),
  mobileSubscription('Mobilabonnemang'),

  // --- Defaults ---
  unknown('Okänd'),
  other('Övrigt');

  const Subcategory(this.displayName);
  final String displayName;
}
