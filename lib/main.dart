import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:freshscan/display.dart';
import 'package:image_picker/image_picker.dart';
import 'predictor.dart';
import 'camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatefulWidget {
  final List<CameraDescription> cameras;
  const MyApp({super.key, required this.cameras});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InitPage(cameras: widget.cameras),
    );
  }
}

class InitPage extends StatelessWidget {
  final List<CameraDescription> cameras;
  final Predictor predictor = Predictor();
  late String imagePath;
  InitPage({Key? key, required this.cameras}) : super(key: key);
  double res = 0;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    final path = pickedImage!.path;
    imagePath = path;
    res = await predictor.predict(path);
  }

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
              margin: const EdgeInsets.fromLTRB(0, 30, 0, 20),
              padding: const EdgeInsets.all(10),
              //margin: EdgeInsets.all(15),
              height: scrHeight * 0.50,
              foregroundDecoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/splash_screen.png"),
                      fit: BoxFit.fill),
                  borderRadius: BorderRadius.all(Radius.circular(45.5))),
            ),
          ),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                        style: const ButtonStyle(
                          iconColor: MaterialStatePropertyAll<Color>(
                              Color.fromARGB(255, 230, 195, 240)),
                          backgroundColor: MaterialStatePropertyAll<Color>(
                              Color.fromARGB(255, 88, 32, 100)),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CameraPanel(cameras: cameras)));
                        },
                        icon: const Icon(Icons.camera_alt_sharp),
                        label: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(),
                              color: const Color.fromARGB(255, 230, 195, 240)),
                          child: const Text('Camera',
                              style: TextStyle(
                                  fontFamily: 'Helvetica',
                                  color: Color.fromARGB(255, 27, 25, 26))),
                        )),
                    ElevatedButton.icon(
                        style: const ButtonStyle(
                          iconColor: MaterialStatePropertyAll<Color>(
                              Color.fromARGB(255, 230, 195, 240)),
                          backgroundColor: MaterialStatePropertyAll<Color>(
                              Color.fromARGB(255, 88, 32, 100)),
                        ),
                        onPressed: () {
                          pickImage().then((value) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Display(
                                          imgPath: imagePath,
                                          result: res,
                                        )));
                          });
                        },
                        icon: const Icon(Icons.image_rounded),
                        label: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(),
                              color: const Color.fromARGB(255, 230, 195, 240)),
                          child: const Text('Galery',
                              style: TextStyle(
                                  fontFamily: 'Helvetica',
                                  color: Color.fromARGB(255, 27, 25, 26))),
                        )),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: const Text(
                  "About Us: ",
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: "Arial",
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Text(
                "We redefine fish freshness using AI and image recognition tech. Empowering consumers to choose the freshest fish. How It Works: AI analyzes fish eyes for a precise freshness score.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Arial",
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
