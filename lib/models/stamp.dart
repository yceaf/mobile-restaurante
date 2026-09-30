class LoyaltyStamp {
  final int number;
  final String date;
  final String title;
  final bool isCompleted;
  final bool isCurrent;

  const LoyaltyStamp({
    required this.number,
    required this.date,
    required this.title,
    required this.isCompleted,
    this.isCurrent = false,
  });
}
