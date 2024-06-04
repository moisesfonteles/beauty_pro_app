class Event {
  final DateTime date;
  final String customer;
  final String hour;
  final double price;
  final String service;

  Event(
      {required this.date,
      required this.customer,
      required this.hour,
      required this.price,
      required this.service});
}
