import 'package:flutter/material.dart';

class WelcomeInstruction extends StatelessWidget {
  static String id = "WelcomeInstruction";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 8, right: 8,bottom: 12),
        child: Column(
          children: [

            Center(child: Text("ABOUT THE APP", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('          The sole purpose of this application is to ease the work of officers who need to access their day to day'
                  ' workload. Instead of searching for the case file just to check a minor detail, they can rather use this '
                  'application to check their case details, add any type of remark, check the status of their daily cases and search for '
                  'past cases under them.'),
            ),
            Divider(color: Colors.grey, height: 20,),
            Text("INSTRUCTION ON USE",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            Text('  *   The My Case section shows a graph which visualises the case of the person logged in for 5 consucative days.'),
            SizedBox(height: 6,),
            Text('  *   The Case Search Menu is made for the ease of a person to search any case according to the case id or date or both.'),
            SizedBox(height: 6,),
            Text('  *   Case Status shows the current status of a case according to the colors represented.'),
            SizedBox(height: 6,),
            Text('  *   Case List shows all the cases that are available for today.'),
            SizedBox(height: 6,),
            Text('  *   The refresh button present on the bottom-right part of the screen helps to reload the data in-case of any updation.'),
            SizedBox(height: 10,),
            Divider(color: Colors.grey, height: 20,),

            Padding(
                padding: EdgeInsets.all(8.0),
            )

          ],
        ),
      )
    );
  }
}
