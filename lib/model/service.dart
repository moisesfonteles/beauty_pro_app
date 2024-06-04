class ServiceModel {
  final String customer;
  final String service;
  final String date;
  final String hour;
  final String price;

  ServiceModel({
    required this.customer,
    required this.service,
    required this.date,
    required this.hour,
    required this.price,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      customer: json['nome'] as String,
      service: json['descricao'] as String,
      date: json['date'] as String,
      hour: json['hour'] as String,
      price: json['price'] as String,
    );
  }
}
