import 'package:flutter/material.dart';
import 'package:emotion_detector/emotion_detector.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2),(){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>EmotionDetector()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white70,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Emotion Detector', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold , fontSize: 30,letterSpacing: 1),),
            Text('Powered by : Rana Eddoaif', style: TextStyle(color: Colors.black26 , fontSize: 10,letterSpacing: 1),),
            SizedBox(height: 35,),
            CircularProgressIndicator(color: Colors.black,),


          ],
        ),
      ),
    );
  }
}
