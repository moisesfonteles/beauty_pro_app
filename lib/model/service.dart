class ServiceModel {
  final int? id;
  final String? customer;
  final String? service;
  final String? date;
  final String? hour;
  final String? price;
  final int? avaliacao;

  ServiceModel(
      {this.id,
      this.customer,
      this.service,
      this.date,
      this.hour,
      this.price,
      this.avaliacao});

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
        id: json['id'] as int,
        customer: json['customer'] as String,
        service: json['service'] as String,
        date: json['date'] as String,
        hour: json['hour'] as String,
        price: json['price'] as String,
        avaliacao: json['avaliacao'] as int);
  }
}
