class DbModel {
  int id;
  String image;
  String name;
  int price;
  String createdAt;
  String updatedAt;

  DbModel({
    required this.id,
    required this.image,
    required this.name,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DbModel.fromJson(Map<String, dynamic> json) {
    return DbModel(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      price: json['price'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
