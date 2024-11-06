class RoleModel {
  final String id;
  final String title;

  RoleModel({
    required this.id,
    required this.title,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'],
      title: json['title'],
    );
  }
}
