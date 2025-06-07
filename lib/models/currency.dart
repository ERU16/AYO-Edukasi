class CurrencyConverter {
  final String fromCurrency;
  final String toCurrency;
  final double amount;
  double? convertedAmount;

  CurrencyConverter({
    required this.fromCurrency,
    required this.toCurrency,
    required this.amount,
  });

  // Mengatur hasil konversi
  void setConvertedAmount(double result) {
    convertedAmount = result;
  }
}
