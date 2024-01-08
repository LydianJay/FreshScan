import 'package:flutter/material.dart';
import 'dart:io';
import 'predictor.dart';

class Display extends StatefulWidget {
  final double result;
  final String imgPath;

  const Display({super.key, required this.imgPath, required this.result});

  @override
  State<Display> createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  final Predictor predictor = Predictor();
  late String resString;
  late Color resColor;
  late double freshness;
  @override
  void initState() {
    super.initState();
    freshness = 0;

    if (widget.result > 0.5) {
      resColor = const Color.fromARGB(255, 255, 0, 0);
      resString = 'NOT FRESH';
    } else {
      resColor = const Color.fromARGB(255, 0, 255, 0);

      resString = 'FRESH';
    }
    freshness = (1.0 - widget.result) * 100.0;
    debugPrint('confidence: $freshness');
    debugPrint('prediction: ${widget.result}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Result',
              style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Calibre',
                  color: Color.fromARGB(255, 0, 0, 0)),
            )),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.white54,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 35),
                  child: Image.file(File(widget.imgPath)),
                ),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Text(
                        "Classified as: ",
                        style: TextStyle(
                          fontSize: 36,
                          fontFamily: "Arial",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    resString,
                    style: TextStyle(
                      fontSize: 58,
                      color: resColor,
                      fontFamily: "Arial",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    'Freshness Percentage: ${freshness.toStringAsFixed(3)}%',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      color: Colors.black,
                      fontFamily: "Arial",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
