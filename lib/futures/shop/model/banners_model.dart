import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class BannersModel {
  String id;
  String name;
  String imageUrl;

  BannersModel({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  BannersModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? imagePath,
    bool? isActive,
  }) {
    return BannersModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory BannersModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return BannersModel(
        id: document.id,
        name: data['name'] as String,
        imageUrl: data['imageUrl'] as String,
      );
    } else {
      return BannersModel.empty();
    }
  }

  @override
  String toString() {
    return 'BannersModel(id: $id, name: $name, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(covariant BannersModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ imageUrl.hashCode;
  }

  static BannersModel empty() => BannersModel(id: '', name: '', imageUrl: '');
}
