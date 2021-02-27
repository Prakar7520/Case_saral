import 'package:flutter/material.dart';

class FeedbackScreen extends StatelessWidget {
  static String id = "FeedbackScreen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("FeedBack Page"),
          )
        ],
      ),

    );
  }
}
