class ServiceModel {
  final String? customer;
  final String? service;
  final String? date;
  final String? hour;
  final String? price;

  ServiceModel({ 
    this.customer,
    this.service,
    this.date,
    this.hour,
    this.price
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
