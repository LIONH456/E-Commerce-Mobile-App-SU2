import 'dart:convert';

class MyCardModel {
  final String id;
  final String name;
  final String image;
  final double price;
  final int numOfPieces;

  MyCardModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.numOfPieces,
  });

  MyCardModel copyWith({
    String? id,
    String? name,
    String? image,
    double? price,
    int? numOfPieces,
  }) {
    return MyCardModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      numOfPieces: numOfPieces ?? this.numOfPieces,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'numOfPieces': numOfPieces,
    };
  }

  factory MyCardModel.fromMap(Map<String, dynamic> map) {
    return MyCardModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      image: map['image']?.toString() ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0,
      numOfPieces: map['numOfPieces'] as int? ?? 1,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory MyCardModel.fromJson(String source) =>
      MyCardModel.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
