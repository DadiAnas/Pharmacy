import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Widget/bezierBotContainer.dart';
import 'Widget/buttons/pharmacyButton.dart';
import 'Widget/buttons/drugButton.dart';
import 'package:http/http.dart' as http;
import 'pharmacies.dart' as pharmacies;


class PharmaciesListPage extends StatefulWidget {
  PharmaciesListPage({Key key, this.title,this.city,this.drug}) : super(key: key);
  final String title;
  final String city;
  final String drug;

  @override
  _PharmaciesListPage createState() => _PharmaciesListPage();
}
class _PharmaciesListPage extends State<PharmaciesListPage> {
  var pharmacies;
  var pharmaciesFilter;
  var pharmaciesFilter1;

  getPharmacies(String city, String drug) async {

    String url='https://mypharmacies.herokuapp.com/pharmacies?fbclid=IwAR396UgpCqjoRyV1kkQPaTtg0poPJINVyebUkhZL3YX56NJASncm6-NEuaQ';

    http.get(url)
        .then((resp){
          setState(() {
            this.pharmacies = json.decode(resp.body);
            this.pharmaciesFilter = pharmacies.where((pharmacie) => pharmacie['city'] == widget.city).toList();
            print(this.pharmaciesFilter);
            this.pharmaciesFilter1 = pharmaciesFilter.where((pharmacie) => pharmacie['drugs']['name'].toLowerCase() == widget.drug.toLowerCase()).toList();
          });

    }).catchError((err){
    print(err);
    });
  }
  @override
  void initState(){
    super.initState();
    getPharmacies(widget.city,widget.drug);
  }

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


  Widget _main(){
    final height = MediaQuery.of(context).size.height;
    return Container(
      child: Stack(
        children: <Widget>[
          RichText(
            text: TextSpan(
              text: '${widget.city}',
              style: GoogleFonts.portLligatSans(
                textStyle: Theme.of(context).textTheme.display1,
                fontSize: 25,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: height*.1 ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text('Searching ${widget.drug} in ${widget.city}',style:TextStyle(fontSize: 16, color:Colors.white ) ,), backgroundColor: Colors.deepOrange,),
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

                    children: <Widget>[
                      SizedBox(height: height*.08 ),
                      _title(),
                      _divider(),
                      SizedBox(height: height*.03 ),

                      (pharmacies==null ? Center(child: CircularProgressIndicator()):
                        ListView.builder( scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount:(pharmacies==null?0:pharmacies.length) ,
                            itemBuilder: (context,index){
                            return Card(
                              color:Colors.deepOrangeAccent,
                              child: Padding(
                                padding: const EdgeInsets.all(11.0),
                                child: Column(

                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(pharmacies[index]['name'].toString(),style:TextStyle(fontSize: 18, color:Colors.white ),),
                                    Text('adresse : '+pharmacies[index]['address'].toString(),style:TextStyle(fontSize: 12,color:Colors.white),),

                                  ],
                                ),
                              )
                            );
                            }
                        )
                      )

                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
