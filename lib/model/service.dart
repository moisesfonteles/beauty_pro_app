class ServiceModel {
  final String? customer;
  final String? service;
  final String? date;
  final String? hour;
  final String? price;
  final int? avaliacao;

  ServiceModel(
      {this.customer,
      this.service,
      this.date,
      this.hour,
      this.price,
      this.avaliacao});

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
        customer: json['customer'] as String,
        service: json['service'] as String,
        date: json['date'] as String,
        hour: json['hour'] as String,
        price: json['price'] as String,
        avaliacao: json['avaliacao'] as int);
  }
}
