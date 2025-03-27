// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Address {
  String id;
  String city;
  String country;
  String street;
  String district;
  String houseDesc;
  String postalCode;

  Address({
    required this.id,
    required this.city,
    required this.country,
    required this.street,
    required this.district,
    required this.houseDesc,
    required this.postalCode,
  });

  Address copyWith({
    String? id,
    String? city,
    String? country,
    String? street,
    String? district,
    String? houseDesc,
    String? postalCode,
  }) {
    return Address(
      id: id ?? this.id,
      city: city ?? this.city,
      country: country ?? this.country,
      street: street ?? this.street,
      district: district ?? this.district,
      houseDesc: houseDesc ?? this.houseDesc,
      postalCode: postalCode ?? this.postalCode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'city': city,
      'country': country,
      'street': street,
      'district': district,
      'houseDesc': houseDesc,
      'postalCode': postalCode,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'] as String,
      city: map['city'] as String,
      country: map['country'] as String,
      street: map['street'] as String,
      district: map['district'] as String,
      houseDesc: map['houseDesc'] as String,
      postalCode: map['postalCode'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Address.fromJson(String source) =>
      Address.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Address(id: $id, city: $city, country: $country, street: $street, district: $district, houseDesc: $houseDesc, postalCode: $postalCode)';
  }

  @override
  bool operator ==(covariant Address other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.city == city &&
        other.country == country &&
        other.street == street &&
        other.district == district &&
        other.houseDesc == houseDesc &&
        other.postalCode == postalCode;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        city.hashCode ^
        country.hashCode ^
        street.hashCode ^
        district.hashCode ^
        houseDesc.hashCode ^
        postalCode.hashCode;
  }
}
