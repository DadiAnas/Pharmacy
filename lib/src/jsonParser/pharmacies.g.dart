// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pharmacies.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Drug _$DrugFromJson(Map<String, dynamic> json) {
  return Drug(
    name: json['name'] as String,
    quantity: (json['quantity'] as num)?.toDouble(),
    ordennance: json['ordennance'] as bool,
    information: json['information'] as String,
  );
}

Map<String, dynamic> _$DrugToJson(Drug instance) => <String, dynamic>{
      'name': instance.name,
      'information': instance.information,
      'quantity': instance.quantity,
      'ordennance': instance.ordennance,
    };

Pharmacy _$PharmacyFromJson(Map<String, dynamic> json) {
  return Pharmacy(
    id: json['_id'] as String,
    name: json['name'] as String,
    latitude: (json['latitude'] as num)?.toDouble(),
    longitude: (json['longitude'] as num)?.toDouble(),
    city: json['city'] as String,
    information: json['information'] as String,
    address: json['address'] as String,
    drugs: (json['drugs'] as List)
        ?.map(
            (e) => e == null ? null : Drug.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    createdAt: json['createdAt'] as String,
  );
}

Map<String, dynamic> _$PharmacyToJson(Pharmacy instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'city': instance.city,
      'information': instance.information,
      'address': instance.address,
      'createdAt': instance.createdAt,
      'drugs': instance.drugs,
    };

Pharmacies _$PharmaciesFromJson(Map<String, dynamic> json) {
  return Pharmacies(
    pharmacies: (json['pharmacies'] as List)
        ?.map((e) =>
            e == null ? null : Pharmacy.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PharmaciesToJson(Pharmacies instance) =>
    <String, dynamic>{
      'pharmacies': instance.pharmacies,
    };
