import 'dart:convert';
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';
import 'package:pharmaciemobile/src/PharmaciesListPage.dart';
import 'package:pharmaciemobile/src/Widget/autocomplete_textfield.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharmaciemobile/src/pharmacyPage.dart';
import 'Widget/bezierBotContainer.dart';
import 'package:http/http.dart' as http;


class DrugPage extends StatefulWidget {
  DrugPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _DrugPageState createState() => _DrugPageState();
}

class _DrugPageState extends State<DrugPage> {
  int _cameraOcr = FlutterMobileVision.CAMERA_BACK;
  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();

  String city="";

  String _textValue="" ;




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

  List<String> getSuggetions(){
    List<String> suggetions=[
      "Rabat",
      "Casablanca",
      "Mohammedia",
      "Azrou",
      "Ifrane",
      "Meknes",
      "Azilal",
      "Fes",
      "Errachidia"];
    return suggetions;
  }

  Widget _main(){
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        children: <Widget>[
          Form(
            key : _formKey,
            child: Column(
              children: <Widget>[

                RichText(
                  text: TextSpan(
                    text: "Your city name :",
                    style: GoogleFonts.portLligatSans(
                      textStyle: Theme.of(context).textTheme.display1,
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: height*.03 ),
                TextFormField(
                    validator : (input){
                      if(input.isEmpty){
                        return 'Please type an Email';
                      }
                    },
                    onSaved: (input) => city = input,

                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Color(0xfff3f3f4),
                        filled: true)
                ),
                SizedBox(height: height*.03 ),
                RichText(
                  text: TextSpan(
                    text: "Enter a drug name :",
                    style: GoogleFonts.portLligatSans(
                      textStyle: Theme.of(context).textTheme.display1,
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: height*.03 ),


                Row(
                    children: <Widget>[
                    new Container(
                      width: 100,
                      child: Text(_textValue),


                    ),


                  new RaisedButton(
                    onPressed: _read,
                    child:  Container(

                      padding: EdgeInsets.symmetric(vertical: 10),

                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),

                          ),
                      child: Text(
                        'Start Scanning',
                        style: TextStyle(fontSize: 20, color: Colors.blueGrey),
                      ),
                    ) ,
                  ),
                ],
                ),
                SizedBox(height: height*.03 ),


                RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 0),
                  onPressed: save,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.shade200,
                                offset: Offset(2, 4),
                                blurRadius: 5,
                                spreadRadius: 2)
                          ],
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xfffbb448), Color(0xfff7892b)])),
                      child: Text(
                        'Search',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ) ,

                ),
              ],
            ),
          ),



        ],
      ),
    );
  }
  Future<Null> _read() async {
    List<OcrText> texts = [];
    try {
      texts = await FlutterMobileVision.read(
        camera: _cameraOcr,
        waitTap: true,
      );

      setState(() {
        _textValue = texts[0].value;
      });
    } on Exception {
      texts.add(new OcrText('Failed to recognize text.'));
    }
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
                      SizedBox(height: height*.06 ),
                      _title(),
                      _divider(),
                      SizedBox(height: height * .06),
                      _main(),

                    ],
                  ),
                ),
              ),
              Positioned(top: 40, left: 0, child: _backButton()),
              Positioned(bottom: 30, right: 30, child: Icon(Icons.info,color:Color(0xffe46b10),size: width* .09,),),
            ],
          ),
        ));
  }
  Future<void> save() async {
    final formState = _formKey.currentState;
    if(formState.validate()){
      formState.save();
      try{
        Navigator.push(context, MaterialPageRoute(builder: (context) =>PharmaciesListPage(city: city,drug: _textValue,)));
      }catch(e){
        print(e.message);}}}
}
