enum Account {
  jimPersonkonto('Jim Personkonto', '1127 25 18949'),
  jimSparkonto('Jim Sparkonto', '3016 28 91261'),
  gemensamt('Gemensamt', '3016 05 24377'),
  gemensamtSpar('Gemensamt Spar', '3016 28 91415'),
  sasAmex('SAS Amex', '595-4300'),
  unknown('Okänd', null);

  const Account(this.displayName, this.accountNumber);
  final String displayName;
  final String? accountNumber;
}
