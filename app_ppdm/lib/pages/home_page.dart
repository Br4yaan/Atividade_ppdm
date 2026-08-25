import 'package:flutter/material.dart';
import '../database/database_helper.dart';


class HomePage extends StatefulWidget {

  const HomePage({super.key});


  @override
  State<HomePage> createState() => _HomePageState();

}



class _HomePageState extends State<HomePage> {


  final tituloController = TextEditingController();


  String pesquisa = "";



  Future<List<Map<String,dynamic>>> carregarTarefas(){


    if(pesquisa.isEmpty){

      return DatabaseHelper.instance.getTasks();

    }


    return DatabaseHelper.instance.searchTask(pesquisa);


  }




  void adicionarTarefa() async {


    if(tituloController.text.isEmpty){

      return;

    }


    await DatabaseHelper.instance.insertTask(
      tituloController.text,
    );


    tituloController.clear();


    setState(() {});


  }




  void limparTarefas() async {


    await DatabaseHelper.instance.deleteAll();


    setState(() {});


  }




  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar: AppBar(

        title: const Text(
          "Tarefas SQLite",
        ),


        actions: [


          IconButton(

            icon: const Icon(
              Icons.delete_forever,
            ),


            onPressed: limparTarefas,

          )


        ],


      ),




      body: Column(

        children: [



          Padding(

            padding: const EdgeInsets.all(10),

            child: TextField(


              decoration: const InputDecoration(

                labelText: "Pesquisar tarefa",

                prefixIcon: Icon(Icons.search),

              ),



              onChanged: (valor){


                setState(() {

                  pesquisa = valor;

                });


              },


            ),

          ),





          Padding(

            padding: const EdgeInsets.all(10),


            child: Row(

              children: [


                Expanded(

                  child: TextField(

                    controller: tituloController,


                    decoration: const InputDecoration(

                      labelText: "Nova tarefa",

                    ),

                  ),

                ),




                IconButton(

                  icon: const Icon(
                    Icons.add,
                  ),


                  onPressed: adicionarTarefa,

                )


              ],

            ),

          ),





          Expanded(

            child: FutureBuilder(

              future: carregarTarefas(),


              builder: (context, snapshot){


                if(!snapshot.hasData){


                  return const Center(

                    child: CircularProgressIndicator(),

                  );


                }




                final tarefas = snapshot.data!;




                if(tarefas.isEmpty){


                  return const Center(

                    child: Text(
                      "Nenhuma tarefa cadastrada",
                    ),

                  );


                }





                return ListView.builder(


                  itemCount: tarefas.length,



                  itemBuilder: (context,index){



                    return Card(

                      child: ListTile(


                        leading: const Icon(
                          Icons.task,
                        ),



                        title: Text(

                          tarefas[index]['titulo'],

                        ),


                      ),

                    );


                  },


                );


              },


            ),

          ),


        ],


      ),





      bottomNavigationBar: FutureBuilder<int>(


        future: DatabaseHelper.instance.countTasks(),



        builder:(context,snapshot){


          return Container(


            padding: const EdgeInsets.all(15),



            child: Text(


              "Total de tarefas: ${snapshot.data ?? 0}",


              textAlign: TextAlign.center,


            ),


          );


        },


      ),



    );


  }



}