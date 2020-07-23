import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharmaciemobile/src/Widget/autocomplete_textfield.dart';
import 'Widget/bezierBotContainer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'jsonParser/pharmacies.dart' as pharmacies;

class PharmacyPage extends StatefulWidget {
  PharmacyPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PharmacyPageState createState() => _PharmacyPageState();
}

class _PharmacyPageState extends State<PharmacyPage> {
  List<String> suggetions=[];

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.arrow_back_ios, color: Color(0xffe46b10)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'My',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'Ph',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'armacy',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }




  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    final mypharmacies = await pharmacies.getPharmacies();
    setState(() {
      _markers.clear();
      for (final pharmacy in mypharmacies.pharmacies) {
        if(!suggetions.contains(pharmacy.city)) suggetions.add(pharmacy.city); // add cities name

        final marker = Marker(
          markerId: MarkerId(pharmacy.createdAt),
          position: LatLng(pharmacy.latitude, pharmacy.longitude),
          infoWindow: InfoWindow(
            title: pharmacy.name,
            snippet: pharmacy.address,
          ),
        );
        _markers[pharmacy.name] = marker;
      }
    });
  }
  GoogleMapController controller;
  void changeMapCamera(String city) async{
    final mypharmacies = await pharmacies.getPharmacies();
    for(final pharmacy in mypharmacies.pharmacies){
        if(pharmacy.city == city){
          await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(pharmacy.latitude, pharmacy.longitude),
            zoom: 12.0,
          )));
           /*await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
               target: LatLng(pharmacy.latitude, pharmacy.longitude);

           )));*/
        }
    }
  }

  Widget mapCard(){
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target:  LatLng(33.4347305, -5.2318879),
        zoom: 14.0,
      ),
      markers: _markers.values.toSet(),
    );
  }



  Widget _main() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        children: <Widget>[
          /* RichText(
            text: TextSpan(
              text: "Enter a city name:",
              style: GoogleFonts.portLligatSans(
                textStyle: Theme.of(context).textTheme.display1,
                fontSize: 25,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),*/
          SimpleAutoCompleteTextField(
            suggestions: suggetions,
            decoration: InputDecoration(
              filled: false,
              fillColor: Colors.black12,
              hintText: 'city name',
              alignLabelWithHint: true,
            ),
            textSubmitted: (city) {
              changeMapCamera(city);
            },

          ),
          SizedBox(
            height: height / 20,
          ),
          SizedBox(
            width: height* .8,
            height: width * 1.2,
            child: mapCard(),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: -height * .29,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierBotContainer()),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .06),
                  _title(),
                  _divider(),
                  SizedBox(height: height * .06),
                  _main(),
                ],
              ),
            ),
          ),
          Positioned(top: 40, left: 0, child: _backButton()),
          Positioned(
            bottom: 30,
            right: 30,
            child: Icon(
              Icons.info,
              color: Color(0xffe46b10),
              size: width * .09,
            ),
          ),
        ],
      ),
    ));
  }
}
