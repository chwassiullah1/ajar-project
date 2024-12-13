class CarModel {
  final String modelName;
  final String modelMakeId;

  CarModel({required this.modelName, required this.modelMakeId});

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      modelName: json['model_name'] ?? '',
      modelMakeId: json['model_make_id'] ?? '',
    );
  }
}
