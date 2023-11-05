import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
/*import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}


class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const MyApp({super.key, required this.cameras});

 @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      home: InitPage(cameras: cameras),
    );
  }

}


class InitPage extends StatelessWidget {
  final List<CameraDescription> cameras;
  
  const InitPage({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;
    double scrHeight = MediaQuery.of(context).size.height;


    return Scaffold(


      body: Container( 
      color: Color.fromARGB(255, 230, 195, 240),
      child: Column(
        children: [ 
          Center(
            child: Container( 
              width: scrWidth,
              margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
              padding: const EdgeInsets.all(10),
              //margin: EdgeInsets.all(15),
              height: scrHeight * 0.50,
              foregroundDecoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/images/splash_screen.png"), fit: BoxFit.fill),
                
                borderRadius: BorderRadius.all(Radius.circular(45.5))
            ),
          
            ),
          ),

         

          Text("About Us: ", 
          style: TextStyle(
              fontSize: 24,
              fontFamily: "Arial",
              fontWeight: FontWeight.bold
            ),
            ),
          Text("We redefine fish freshness using AI and image recognition tech.\nEmpowering consumers to choose the freshest fish.\nHow It Works: AI analyzes fish eyes for a precise freshness score.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontFamily: "Arial",
              fontWeight: FontWeight.bold
            ),
          ),

          ElevatedButton.icon(
          style: ButtonStyle(
          iconColor: MaterialStatePropertyAll<Color>(Color.fromARGB(255, 230, 195, 240)),
          backgroundColor: MaterialStatePropertyAll<Color>(Color.fromARGB(255, 88, 32, 100)),
          ),
          onPressed: () {
            
          },
          icon: const Icon(Icons.arrow_circle_right_rounded),
          label: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(),
                  color: const Color.fromARGB(255, 230, 195, 240)),
              child: const Text(
                'Proceed',
                style: TextStyle(
                    fontFamily: 'Helvetica',
                    color: Color.fromARGB(255, 27, 25, 26))),
              )),
          
        
        ],
      ),
      )
    );
  }
}