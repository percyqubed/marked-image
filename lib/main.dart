import 'package:carimage/points.dart';
import 'package:flutter/material.dart';
import 'package:marked_image/marked_image.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // pointOne.forEach((element) {
    //   print(element["x"]);
    // });
    super.initState();
  }

  String frontImage = "assets/front.jpeg";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App'),
      ),
      body: Container(
        child: MarkedImage(
          assetImage: 'assets/ford.jpeg',
          width: MediaQuery.of(context).size.width,
          debugMode: true,
          points: [
            PointDetails(
              points: pointOne,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Front wheel')));
              },
              title: 'Front wheel',
            ),
            PointDetails(
              points: pointTwo,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fuel thing')));
              },
              title: 'Fuel thing',
            ),
          ],
        ),
      ),
    );
  }
}

enum ImageData { width, height, aspectRatio }
