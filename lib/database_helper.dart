import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/todo.dart';

class DatabaseHelper {

  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(),'todos.db'),
      onCreate: (db,version) async {
        await db.execute(
          "CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT)",
        );

        await db.execute(
          "CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT, taskId INTEGER, title TEXT, isDone INTEGER)",
        );

        return db;
      },
      version: 1
    );
  }

  Future<int> insertTask(Task task) async{
    int taskId = 0;
    final Database _db = await database();
    await _db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    ).then((value){
      taskId = value;
    });

    return taskId;
  }

  Future<void> insertTodo(Todo todo) async {
    final Database _db = await database();
    await _db.insert(
      'todos',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<List<Task>> getTasks() async {
    final Database _db = await database();
    List<Map<String,dynamic>> taskMap = await _db.query('tasks');
    print(taskMap.toString());
    return List.generate(taskMap.length, (index) {
      return Task(id: taskMap[index]['id'],title: taskMap[index]['title'], description: taskMap[index]['description']);
    });
  }

  Future<List<Todo>> getTodosById(int taskId) async {
    final Database _db = await database();
    List<Map<String,dynamic>> todoMap = await _db.rawQuery(
      'SELECT * FROM todos WHERE taskId=$taskId'
    );
    return List.generate(todoMap.length, (index) {
      return Todo(id: todoMap[index]['id'],title: todoMap[index]['title'],isDone: todoMap[index]['isDone'],taskId: todoMap[index]['taskId']);
    });
  }

  Future<void> updateTaskTitle(int id, String title) async {
    final _db = await database();
    await _db.rawUpdate("UPDATE tasks SET title = '$title' WHERE id = '$id'");
  }

  Future<void> updateTaskDescription(int id, String desc) async {
    final _db = await database();
    await _db.rawUpdate("UPDATE tasks SET description = '$desc' WHERE id = '$id'");
  }
  
  Future<void> updateTodoIsDone(int id, int isDone) async {
    final _db = await database();
    await _db.rawUpdate("UPDATE todos SET isDone = '$isDone' WHERE id = '$id'");
  }
  
  Future<void> deleteTask(int id) async {
    final _db = await database();
    await _db.rawDelete("DELETE FROM tasks WHERE id = '$id'");
    await _db.rawDelete("DELETE FROM todos WHERE taskId = '$id'");
  }
}