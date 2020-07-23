import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

part 'pharmacies.g.dart';

@JsonSerializable()
class Drug{
  Drug({
    this.name,
    this.quantity,
    this.ordennance,
    this.information,
  });

  factory Drug.fromJson(Map<String,dynamic> Json) => _$DrugFromJson(Json);
  Map<String,dynamic> toJson() => _$DrugToJson(this);

  final String name;
  final String information;
  final double quantity;
  final bool ordennance;

}

@JsonSerializable()
class Pharmacy{
  Pharmacy({
    this.id,
    this.name,
    this.latitude,
    this.longitude,
    this.city,
    this.information,
    this.address,
    this.drugs,
    this.createdAt,
  });

  factory Pharmacy.fromJson(Map<String,dynamic> Json) => _$PharmacyFromJson(Json);
  Map<String,dynamic> toJson() => _$PharmacyToJson(this);

  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String city;
  final String information;
  final String address;
  final String createdAt;
  final List<Drug> drugs;

}

@JsonSerializable()
class Pharmacies {
  Pharmacies({
    this.pharmacies,
  });

  factory Pharmacies.fromJson(Map<String, dynamic> json) =>
      _$PharmaciesFromJson(json);
  Map<String, dynamic> toJson() => _$PharmaciesToJson(this);

  final List<Pharmacy> pharmacies;
}

Future<Pharmacies> getPharmacies() async {
  const PharmaciesURL = 'https://mypharmacies.herokuapp.com/pharmacies';
   // Retrieve the locations of Google offices
  final response = await http.get(PharmaciesURL);
  Map<String,dynamic> pharmaciesMap= {"pharmacies":json.decode(response.body)};
  if (response.statusCode == 200) {
    return Pharmacies.fromJson(pharmaciesMap);
  } else {
    throw HttpException(
        'Unexpected status code ${response.statusCode}:'
            ' ${response.reasonPhrase}',
        uri: Uri.parse(PharmaciesURL));
  }
}