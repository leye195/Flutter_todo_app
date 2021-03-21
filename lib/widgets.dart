import 'package:flutter/material.dart';

class TaskCardWidget extends StatelessWidget {
  final String title;
  final String desc;
  TaskCardWidget({this.title,this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 32,
        horizontal: 24,
      ),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [BoxShadow(color: Colors.black12,spreadRadius: 1,blurRadius: 1,offset: Offset(0,2))]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title??'Unnamed Task',
            style: TextStyle(
              color: Color(0xff211551),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top:20
            ),
            child: Text(
              desc??'No Description Added',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff868290),
                height: 1.5
              )
            ),
          )
        ],
      ),
    );
  }
}

class TodoWidget extends StatelessWidget {
  final String text;
  final bool isDone;

  TodoWidget({this.text, @required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 10
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              margin: EdgeInsets.only(
                right: 10
              ),
              decoration: BoxDecoration(
                color: isDone?Color(0xff7349fe): Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: Colors.black26)]
              ),
              child: Image(image:
                AssetImage(
                  'assets/images/check_icon.png'
                ),),
            ),
            Flexible(
              child: Text(
                text?? 'Unnamed Task',
                style: TextStyle(
                  color: isDone? Color(0xff211553):Colors.black26,
                  fontSize: 16,
                  fontWeight: isDone? FontWeight.bold: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//remove glow
class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}