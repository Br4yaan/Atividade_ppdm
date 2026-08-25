class Task {

  int? id;
  String titulo;

  Task({
    this.id,
    required this.titulo,
  });


  Map<String, dynamic> toMap(){

    return {
      'id': id,
      'titulo': titulo,
    };

  }


  factory Task.fromMap(Map<String, dynamic> map){

    return Task(
      id: map['id'],
      titulo: map['titulo'],
    );

  }

}