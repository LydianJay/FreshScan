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
  late Widget resultWidget;

  @override
  void initState() {
    super.initState();

    if (widget.result >= 0.5) {
      resultWidget = Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          color: Colors.redAccent,
        ),
        child: const Text(
          'Classified as: ',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "Arial"),
        ),
      );
    } else {
      resultWidget = Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            gradient: LinearGradient(colors: [
              Colors.redAccent,
              Colors.red,
            ], stops: [
              0.2,
              0.7
            ])),
        child: const Text(
          'FRESH',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "Arial"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 200, 79, 204),
        title: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color.fromARGB(255, 230, 195, 240)),
            child: const Text(
              'Image Result',
              style: TextStyle(
                  fontFamily: 'Arial', color: Color.fromARGB(255, 0, 0, 0)),
            )),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            color: const Color.fromARGB(255, 200, 79, 204),
            child: Column(
              children: [
                Container(
                  child: Image.file(File(widget.imgPath)),
                ),
                resultWidget,
              ],
            ),
          )
        ],
      ),
    );
  }
}
