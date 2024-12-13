class Delivery {
  final String unitPrice;
  final int total;
  final String calculation;

  Delivery({
    required this.unitPrice,
    required this.total,
    required this.calculation,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
        unitPrice: json["unit_price"],
        total: json["total"],
        calculation: json["calculation"],
      );

  Map<String, dynamic> toJson() => {
        "unit_price": unitPrice,
        "total": total,
        "calculation": calculation,
      };
}
