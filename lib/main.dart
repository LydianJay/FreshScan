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
  InitPage({Key? key, required this.cameras}) : super(key: key);
  double res = 0;
  late String imagePath;

  final List<Color> myColors = const [
    Color.fromARGB(255, 238, 238, 240),
    Color.fromARGB(255, 239, 239, 245),
    Color.fromARGB(255, 92, 87, 138),
    Color.fromARGB(255, 0, 0, 1),
    Color.fromARGB(255, 52, 55, 58)
  ];

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
      color: myColors[1],
      child: Column(
        children: [
          Center(
            child: Container(
              width: scrWidth,
              margin: const EdgeInsets.fromLTRB(0, 30, 0, 20),
              padding: const EdgeInsets.all(10),
              height: scrHeight * 0.50,
              foregroundDecoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/splash_screen.png"),
                      fit: BoxFit.fitWidth),
                  borderRadius: BorderRadius.all(Radius.circular(45.5))),
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        shadowColor:
                            MaterialStatePropertyAll<Color>(myColors[3]),
                        fixedSize: MaterialStatePropertyAll<Size>(
                            Size((scrWidth * 0.8), 130.0)),
                        iconColor: MaterialStatePropertyAll<Color>(myColors[2]),
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(myColors[1]),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35.0),
                                    side:
                                        const BorderSide(color: Colors.black))),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CameraPanel(cameras: cameras)));
                      },
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: const Icon(
                              Icons.camera_alt_sharp,
                              size: 75,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(color: myColors[1]),
                            child: Text('Scan',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.bold,
                                    backgroundColor: myColors[1],
                                    color: myColors[3])),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      style: ButtonStyle(
                        shadowColor:
                            MaterialStatePropertyAll<Color>(myColors[3]),
                        fixedSize: MaterialStatePropertyAll<Size>(
                            Size((scrWidth * 0.8), 130.0)),
                        iconColor: MaterialStatePropertyAll<Color>(myColors[2]),
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(myColors[1]),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35.0),
                                    side:
                                        const BorderSide(color: Colors.black))),
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
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: const Icon(
                              Icons.image,
                              size: 75,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(color: myColors[1]),
                            child: Text('Gallery',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.bold,
                                    backgroundColor: myColors[1],
                                    color: myColors[3])),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
