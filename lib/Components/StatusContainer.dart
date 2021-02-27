import 'package:flutter/material.dart';

class StatusContainer extends StatelessWidget {

  final Widget child;

  const StatusContainer({
    Key key, this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      width: 15,
      child: child,
    );
  }
}