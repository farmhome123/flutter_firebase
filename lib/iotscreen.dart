import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';

class IotScreen extends StatefulWidget {
  @override
  _IotScreenState createState() => _IotScreenState();
}

class _IotScreenState extends State<IotScreen>
    with SingleTickerProviderStateMixin {
  @override
  DatabaseReference _dhtRef = FirebaseDatabase.instance.reference();
  bool value = false;
  Color color = Colors.grey;

  onUpdate() {
    setState(() {
      value = !value;
    });
  }

  static final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
            child: new ListView(
          children: <Widget>[
            new DrawerHeader(
              child: new Text("DRAWER HEADER.."),
              decoration: new BoxDecoration(color: Colors.orange),
            ),
            new ListTile(
              title: new Text("Room 1"),
              onTap: () {},
            ),
            new ListTile(
              title: new Text("Room 2"),
              onTap: () {},
            ),
          ],
        )),
        body: SafeArea(
          child: StreamBuilder<dynamic>(
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    !snapshot.hasError &&
                    snapshot.data != null) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                _scaffoldKey.currentState!.openDrawer();
                              },

                              child: Icon(
                                Icons.clear_all,
                                color: !value ? Colors.white : Colors.yellow,
                              ),
                              // ),
                            ),
                            Text("MY ROOM",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),

                            Icon(
                              Icons.settings,
                              color: !value ? Colors.white : Colors.yellow,
                            ),
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Temperature",
                                    style: TextStyle(
                                        color: !value
                                            ? Colors.white
                                            : Colors.yellow,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    snapshot.data!.snapshot.value["Temperature"]
                                            .toString() +
                                        "°C",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Humidity",
                                style: TextStyle(
                                    color:
                                        !value ? Colors.white : Colors.yellow,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                snapshot.data!.snapshot.value["Humidity"]
                                        .toString() +
                                    "%",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                          ),
                        ],
                      ),
                      SizedBox(height: 80),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: FloatingActionButton.extended(
                          icon: value
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off),
                          backgroundColor: value ? Colors.yellow : Colors.white,
                          label: value ? Text("ON") : Text("OFF"),
                          elevation: 20.00,
                          onPressed: () {
                            onUpdate();
                            writeData();
                          },
                        ),
                      ),
                    ],
                  );
                } else {}
                return Container();
              },
              // stream: dbRef.child("Data").onValue),
              stream: _dhtRef.child("Data").onValue),
        ),
      ),
    );
  }

  Future<void> writeData() async {
    if (value == true) {
      _dhtRef.child("LightState").set({"switch": 1});
    } else {
      _dhtRef.child("LightState").set({"switch": 0});
    }
    //_dhtRef.child("Data").set({"Humidity": 20, "Temperature": 50});
  }
}
