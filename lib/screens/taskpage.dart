import 'package:flutter/material.dart';
import 'package:todo_app/database_helper.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/widgets.dart';

class TaskPage extends StatefulWidget {
  final Task task;
  TaskPage({@required this.task});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {

  DatabaseHelper _dbHelper = DatabaseHelper();

  String _taskTitle = '';
  String _taskDescription = '';
  String _todo = '';
  int _taskId = 0;


  /*
  * TextField를 식별하기 위해 FocusNode 활용
  * 이것을 통해 focus를 줄 수 있음
  * initState를 통해 만들고
  * dispose를 통해 제
  * */
  FocusNode _titleFocus;
  FocusNode _desFocus;
  FocusNode _todoFocus;

  bool _contentVisible = false;


  //생성될 때 호
  @override
  void initState() {

    if(widget.task!=null){
      // set visibility true
      _contentVisible = true;

      _taskId = widget.task.id;
      _taskTitle = widget.task.title;
      _taskDescription = widget.task.description;
    }

    _titleFocus = FocusNode();
    _desFocus = FocusNode();
    _todoFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {

    _titleFocus.dispose();
    _desFocus.dispose();
    _todoFocus.dispose();


    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 25,
                      bottom: 5
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 24,
                              horizontal: 24
                            ),
                            child: Image(image: AssetImage(
                              'assets/images/back_arrow_icon.png'
                            )),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            focusNode: _titleFocus,
                            onSubmitted: (value) async {

                              // check if field is notempty
                              if(value != "") {

                                // check if the task is null
                                if(widget.task == null){
                                  Task _newTask =  Task(
                                    title: value,
                                  );
                                  _taskId = await _dbHelper.insertTask(_newTask);
                                  setState(() {
                                    _contentVisible = true;
                                    _taskTitle = value;
                                  });
                                } else {
                                  // update existing task
                                  await _dbHelper.updateTaskTitle(_taskId, value);
                                  setState(() {
                                    _taskTitle = value;
                                  });
                                }
                                _desFocus.requestFocus();
                              }
                            },
                            controller: TextEditingController()..text = _taskTitle,
                            decoration: InputDecoration(
                              hintText: 'Enter Task Title',
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff211551)
                            ),
                          ),
                        ) //Task Name input field
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 12
                      ),
                      child: TextField(
                        onSubmitted: (value){
                          if(value!=""){
                            if(_taskId != 0){
                              _dbHelper.updateTaskDescription(_taskId, value);
                              setState(() {
                                _taskDescription = value;
                              });
                            }
                          }
                          _todoFocus.requestFocus();
                        },
                        focusNode: _desFocus,
                        controller: TextEditingController()..text = _taskDescription,
                        decoration: InputDecoration(
                          hintText: 'Enter Task Description',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 25
                          )
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getTodosById(_taskId),
                      builder: (context, snapShot){
                        return Expanded(
                          child: ListView.builder(
                            itemBuilder: (context,index){
                              return GestureDetector(
                                onTap: () async{
                                  // switch the complete state
                                  await _dbHelper.updateTodoIsDone(snapShot.data[index].id, snapShot.data[index].isDone==0?1:0);
                                  setState(() {});
                                },
                                child: TodoWidget(
                                  isDone: snapShot.data[index].isDone==0?
                                    false:true,
                                  text: snapShot.data[index].title,
                                ),
                              );
                            },
                            itemCount: snapShot.data.length,
                          ),
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25
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
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [BoxShadow(color: Colors.black12)]
                            ),
                            child: Image(image:
                            AssetImage(
                                'assets/images/check_icon.png'
                            ),),
                          ),
                          Expanded(
                            child: TextField(
                              controller: TextEditingController()..text = _todo,
                              focusNode: _todoFocus,
                              onSubmitted: (value) async {
                                if(value!=''){
                                  if(widget.task!=null){
                                    Todo _newTodo = Todo(title: value, isDone: 0, taskId: widget.task.id);
                                    await _dbHelper.insertTodo(_newTodo);
                                  } else {
                                    Todo _newTodo = Todo(title: value, isDone: 0, taskId: _taskId);
                                    await _dbHelper.insertTodo(_newTodo);
                                    print('Task does not exist');
                                  }
                                  setState(() {});

                                  _todoFocus.requestFocus();
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter your To-do Item...',
                                border: InputBorder.none,

                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Visibility(
                visible: _contentVisible,
                child: Positioned(
                  bottom: 24,
                  right: 24,
                  child: InkWell(
                    onTap: () async{
                      if(_taskId!=0){
                        await _dbHelper.deleteTask(_taskId);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Color(0xfffe3577),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Image(
                        image: AssetImage(
                          'assets/images/delete_icon.png'
                        ),
                      ),
                    ),
                  )
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}
