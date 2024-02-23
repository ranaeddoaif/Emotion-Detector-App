import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tensorflow_lite_flutter/tensorflow_lite_flutter.dart';
import 'main.dart';

class EmotionDetector extends StatefulWidget {
  const EmotionDetector({super.key});

  @override
  State<EmotionDetector> createState() => _EmotionDetectorState();
}

class _EmotionDetectorState extends State<EmotionDetector> {
  CameraController? cameraController;
  String output = '';
  double? per;
  int ? i;
  loadCamera() {
    cameraController = CameraController(cameras![0], ResolutionPreset.high);
    cameraController!.initialize().then((value) {
      if (!mounted) {
        return;
      } else {
        setState(() {
          cameraController!.startImageStream((image) {
            runModel(image);
          });
        });
      }
    });
  }

  runModel(CameraImage img) async {
    dynamic recognitions = await Tflite.runModelOnFrame(
        bytesList: img.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        // required
        imageHeight: img.height,
        imageWidth: img.width,
        imageMean: 127.5,
        // defaults to 127.5
        imageStd: 127.5,
        // defaults to 127.5
        rotation: 90,
        // defaults to 90, Android only
        numResults: 2,
        // defaults to 5
        threshold: 0.1,
        // defaults to 0.1
        asynch: true // defaults to true
    );
    for (var element in recognitions) {
      setState(() {
        output = element['label'];
      });
    }
    for (var element in recognitions) {
      setState(() {
        per = element['confidence']*100;
         i = per?.toInt();
      });
    }
  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model.tflite', labels: 'assets/labels.txt');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCamera();
    loadModel();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cameraController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title:const Text(
          'Emotion Detector',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height*0.5,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: CameraPreview(cameraController!),
                ),
              )
            ),
            SizedBox(height: 35,),
            Text( '$output $i%' , style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold , fontSize: 24),),
          //  Text( '$i%' , style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold , fontSize: 24),),
          ],
        ),
      ),
    );
  }
}
