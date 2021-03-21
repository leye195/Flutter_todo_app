import 'package:flutter/material.dart';
import 'package:todo_app/database_helper.dart';
import 'package:todo_app/screens/taskpage.dart';
import 'package:todo_app/widgets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 25,
          ),
          color: Color(0xFFF6F6),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      top: 32,
                      bottom: 32
                    ),
                    child: Image(image: AssetImage(
                      'assets/images/logo.png'
                    )),
                  ),
                  Expanded(
                    child: ScrollConfiguration( //setting Scroll Effect
                      behavior: NoGlowScrollBehavior(),
                      child: FutureBuilder(
                        initialData: [],
                        future: _dbHelper.getTasks(),
                        builder: (context,snapShot){  // get data from snapShot
                          return ListView.builder(itemBuilder: (context,index){
                            return GestureDetector(
                              onTap: (){
                                print(snapShot.data[index].title);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TaskPage(task: snapShot.data[index])
                                  )
                                ).then((value){
                                  setState(() {});
                                });
                              },
                              child: TaskCardWidget(
                                title: snapShot.data[index].title,
                                desc: snapShot.data[index].description,
                              ),
                            );
                          },itemCount: snapShot.data.length);
                        },
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: 32,
                right: 0,
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => TaskPage(task: null))
                    ).then((value) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff7349fe),
                          Color(0xff643fd8)
                        ],
                        begin: Alignment(0.0,-1.0),
                        end: Alignment(0.0,1.0),
                      ),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Image(
                      image: AssetImage(
                        'assets/images/add_icon.png'
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
