import 'package:flutter/material.dart';
import 'package:ver2/Models/DetailScreenArgument.dart';

class AddRemarks extends StatelessWidget {
  static String id = "AddRemarks";

  @override
  Widget build(BuildContext context) {

    return Container(

      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.only(top: 40, left: 20, right: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "add remarks",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.grey[700],
              ),
            ),
            Container(

              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, top: 10, right: 15, bottom: 10),
                child: TextField(
                  decoration: InputDecoration(border: InputBorder.none),
                  autofocus: true,
                  maxLines: 8,
                  textAlign: TextAlign.left,
                  onChanged: (newText) {},
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FlatButton.icon(
                  color: Colors.grey[200],
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.done),
                  label: Text("Submit")),
            )
          ],
        ),
      ),
    );
  }
}
