import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {


  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();


  static Database? _database;



  Future<Database> get database async {

    if (_database != null) {
      return _database!;
    }


    _database = await initDatabase();

    return _database!;

  }



  Future<Database> initDatabase() async {


    final path = join(
      await getDatabasesPath(),
      'tarefas.db',
    );


    return await openDatabase(

      path,

      version: 1,


      onCreate: (db, version) async {


        await db.execute('''

          CREATE TABLE tarefas(

            id INTEGER PRIMARY KEY AUTOINCREMENT,

            titulo TEXT NOT NULL

          )

        ''');


      },

    );


  }




  Future<void> insertTask(String titulo) async {


    final db = await database;


    await db.insert(

      'tarefas',

      {
        'titulo': titulo,
      },

    );


  }





  Future<List<Map<String, dynamic>>> getTasks() async {


    final db = await database;


    return await db.query(
      'tarefas',
      orderBy: 'id DESC',
    );


  }




  // Exercício 01

  Future<int> countTasks() async {


    final db = await database;


    var resultado = await db.rawQuery(
      'SELECT COUNT(*) FROM tarefas',
    );


    return Sqflite.firstIntValue(resultado) ?? 0;


  }




  // Exercício 02

  Future<void> deleteAll() async {


    final db = await database;


    await db.delete(
      'tarefas',
    );


  }





  // Exercício 03

  Future<List<Map<String, dynamic>>> searchTask(String texto) async {


    final db = await database;


    return await db.query(

      'tarefas',

      where: 'titulo LIKE ?',

      whereArgs: [
        '%$texto%',
      ],

    );


  }


}