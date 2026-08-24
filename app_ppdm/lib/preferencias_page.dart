import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasPage extends StatefulWidget {
  const PreferenciasPage({super.key});

  @override
  State<PreferenciasPage> createState() => _PreferenciasPageState();
}

class _PreferenciasPageState extends State<PreferenciasPage> {

  bool notificacoes = false;
  String tamanhoFonte = "Médio";

  double tamanhoTexto = 20;


  @override
  void initState() {
    super.initState();
    carregarPreferencias();
  }


  Future<void> carregarPreferencias() async {

    final prefs = await SharedPreferences.getInstance();

    setState(() {

      notificacoes = prefs.getBool("notificacoes") ?? false;

      tamanhoFonte = prefs.getString("tamanhoFonte") ?? "Médio";

      atualizarFonte();

    });

  }


  void atualizarFonte(){

    if(tamanhoFonte == "Pequeno"){
      tamanhoTexto = 14;
    }
    else if(tamanhoFonte == "Grande"){
      tamanhoTexto = 28;
    }
    else{
      tamanhoTexto = 20;
    }

  }


  Future<void> salvarNotificacoes(bool valor) async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool("notificacoes", valor);

    setState(() {
      notificacoes = valor;
    });

  }


  Future<void> salvarFonte(String valor) async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("tamanhoFonte", valor);

    setState(() {

      tamanhoFonte = valor;

      atualizarFonte();

    });

  }


  Future<void> limparConfiguracoes() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    setState(() {

      notificacoes = false;

      tamanhoFonte = "Médio";

      atualizarFonte();

    });

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Configurações"),
      ),


      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            Text(
              "Exemplo de texto",
              style: TextStyle(
                fontSize: tamanhoTexto,
              ),
            ),


            const SizedBox(height: 30),


            DropdownButton<String>(

              value: tamanhoFonte,

              items: const [

                DropdownMenuItem(
                  value: "Pequeno",
                  child: Text("Pequeno"),
                ),

                DropdownMenuItem(
                  value: "Médio",
                  child: Text("Médio"),
                ),

                DropdownMenuItem(
                  value: "Grande",
                  child: Text("Grande"),
                ),

              ],


              onChanged: (valor){

                salvarFonte(valor!);

              },

            ),


            SwitchListTile(

              title: const Text(
                "Receber Notificações",
              ),

              value: notificacoes,

              onChanged: (valor){

                salvarNotificacoes(valor);

              },

            ),


            ElevatedButton(

              onPressed: limparConfiguracoes,

              child: const Text(
                "Limpar Configurações",
              ),

            )

          ],

        ),

      ),

    );

  }

}