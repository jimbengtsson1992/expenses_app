enum Account {
  jimPersonkonto('Jim Personkonto'),
  jimSparkonto('Jim Sparkonto'),
  gemensamt('Gemensamt'),
  gemensamtSpar('Gemensamt Spar'),
  sasAmex('SAS Amex'),
  nordea('Nordea');

  const Account(this.displayName);
  final String displayName;
}
