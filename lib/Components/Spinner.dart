import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ver2/Components/SplashScreen.dart';

class Spinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(

      child: Center(
        child: SpinKitWave(
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }
}