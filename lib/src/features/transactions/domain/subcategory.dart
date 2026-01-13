enum Subcategory {
  // Transport
  taxi('Taxi'),
  publicTransport('Kollektivtrafik'),
  car('Bil'),
  fuel('Drivmedel'),
  parking('Parkering'),
  
  // Food
  groceries('Matbutik'),
  restaurant('Restaurang'),
  
  // Shopping
  clothes('Kläder'),
  electronics('Elektronik'),
  home('Hem & Inredning'),
  
  // Health
  gym('Träning'),
  pharmacy('Apotek'),
  doctor('Vård'),
  
  // Bills
  streaming('Streaming'),
  electricity('El'),
  internet('Bredband'),
  phone('Telefoni'),
  insurance('Försäkring'),

  // Income
  salary('Lön'),
  otherIncome('Övrig inkomst'),

  // Default/Fallback
  unknown('Okänd');

  const Subcategory(this.displayName);
  final String displayName;
}
