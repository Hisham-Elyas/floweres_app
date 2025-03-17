import 'package:cloud_firestore/cloud_firestore.dart';

class OccasionsModel {
  String id;
  String name;
  String imageUrl;

  OccasionsModel({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  OccasionsModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? imagePath,
    bool? isActive,
  }) {
    return OccasionsModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory OccasionsModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return OccasionsModel(
        id: document.id,
        name: data['name'] as String,
        imageUrl: data['imageUrl'] as String,
      );
    } else {
      return OccasionsModel.empty();
    }
  }

  @override
  String toString() {
    return 'OccasionsModel(id: $id, name: $name, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(covariant OccasionsModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ imageUrl.hashCode;
  }

  static OccasionsModel empty() =>
      OccasionsModel(id: '', name: '', imageUrl: '');
}
