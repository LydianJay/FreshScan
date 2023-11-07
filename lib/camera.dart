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
    const ButtonStyle bStyle = ButtonStyle(
      iconColor:
          MaterialStatePropertyAll<Color>(Color.fromARGB(255, 200, 79, 204)),
      backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
    );

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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton.icon(
                            style: bStyle,
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
                            icon: const Icon(
                              Icons.camera_sharp,
                              size: 65,
                            ),
                            label: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.white),
                                child: const Text(
                                  'Take Picture',
                                  style: TextStyle(
                                      fontFamily: 'Calibre',
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                )),
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
