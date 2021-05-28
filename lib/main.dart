import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurpleAccent,
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //----------------------------------------------------------------

  TextEditingController pincodeController = TextEditingController();
  TextEditingController dayController = TextEditingController();
  String dropdownValue = '01';
  List slots = [];

//----------------------------------------------------------------

  findslots() async {
    await http
        .get(Uri.parse(
            'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByPin?pincode=' +
                pincodeController.text +
                '&date=' +
                dayController.text +
                '%2F' +
                dropdownValue +
                '%2F2021'))
        .then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        slots = result['sessions'];
      });
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Slots()))
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vaccine Slots Viewer')),
      body: Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(children: [
          TextField(
            controller: pincodeController,
            maxLength: 6,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Enter PIN Code'),
          ),
          TextField(
            controller: dayController,
            decoration: InputDecoration(hintText: 'Enter Date'),
          ),
          Container(
            width: double.infinity,
            height: 60,
            child: DropdownButton<String>(
              value: dropdownValue,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
              items: <String>[
                '01',
                '02',
                '03',
                '04',
                '05',
                '06',
                '07',
                '08',
                '09',
                '10',
                '11',
                '12'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 40,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                findslots();
              },
              child: Text('Find Slots'),
            ),
          )
        ]),
      ),
    );
  }
}
