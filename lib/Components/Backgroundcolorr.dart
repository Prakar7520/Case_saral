import 'package:flutter/material.dart';

class BackgroundColorr extends StatelessWidget {

  final Widget child;
  const BackgroundColorr({
    Key key,
    @required this.child,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: size.height,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color.fromRGBO(110, 85, 202, 1),Color.fromRGBO(181, 81, 194,1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
            )
        ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            child,
          ],
        )
    );
  }
}
