import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'predictor.dart';
import 'display.dart';

class CameraPanel extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraPanel({Key? key, required this.cameras}) : super(key: key);
  @override
  _CameraPanelState createState() => _CameraPanelState();
}

class _CameraPanelState extends State<CameraPanel> {
  late CameraController camController;
  late Future<void> initControlerFuture;
  final Predictor predictor = Predictor();
  late String imagePath;
  double result = 0;
  final List<Color> myColors = const [
    Color.fromARGB(255, 238, 238, 240),
    Color.fromARGB(255, 239, 239, 245),
    Color.fromARGB(255, 92, 87, 138),
    Color.fromARGB(255, 0, 0, 1),
    Color.fromARGB(255, 52, 55, 58)
  ];
  @override
  void initState() {
    super.initState();

    camController = CameraController(
      widget.cameras[0],
      ResolutionPreset.veryHigh,
    );
    initControlerFuture = camController.initialize();
  }

  Future<void> captureImage() async {
    try {
      final image = await camController.takePicture();
      imagePath = image.path;
      result = await predictor.predict(image.path);
    } catch (e) {
      debugPrint('Error Occured!: $e');
    }
  }

  @override
  void dispose() {
    camController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;
    double scrHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 200, 79, 204),
        title: Container(
          padding: EdgeInsets.all(scrWidth / 8),
          child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color.fromARGB(255, 230, 195, 240)),
              child: const Text(
                'FreshSCAN',
                style: TextStyle(
                    fontFamily: 'Arial', color: Color.fromARGB(255, 0, 0, 0)),
              )),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<void>(
        future: initControlerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                SizedBox(
                  width: scrWidth,
                  height: scrHeight,
                  child: AspectRatio(
                    aspectRatio: camController.value.aspectRatio,
                    child: CameraPreview(camController),
                  ),
                ),
                Positioned(
                  bottom: 35,
                  left: 62,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              shadowColor:
                                  MaterialStatePropertyAll<Color>(myColors[3]),
                              fixedSize: MaterialStatePropertyAll<Size>(
                                  Size((scrWidth * 0.65), 90.0)),
                              iconColor:
                                  MaterialStatePropertyAll<Color>(myColors[2]),
                              backgroundColor:
                                  MaterialStatePropertyAll<Color>(myColors[1]),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(35.0),
                                      side: const BorderSide(
                                          color: Colors.black))),
                            ),
                            onPressed: () {
                              captureImage().then((value) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Display(
                                              imgPath: imagePath,
                                              result: result,
                                            )));
                              });
                            },
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  child: const Icon(
                                    Icons.camera_sharp,
                                    size: 40,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(color: myColors[1]),
                                  child: Text('Take Picture',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontFamily: 'Arial',
                                          fontWeight: FontWeight.bold,
                                          backgroundColor: myColors[1],
                                          color: myColors[3])),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
