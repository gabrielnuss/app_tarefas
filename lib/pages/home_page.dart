import 'package:app_tarefas/model/tarefas_model.dart';
import 'package:app_tarefas/pages/cadastrar_tarefa_page.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TarefasModel> tarefas = [
    TarefasModel(1, "Tarefa teste", "10:00", DateTime.now(), true)
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          title: const Text("Tarefas"),
        ),
        body: ListView.builder(
          itemCount: tarefas.length,
          itemBuilder: (context, index) {
            var tarefa = tarefas[index];
            return Dismissible(
                background: Container(
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Card(
                        elevation: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            Expanded(child: Container()),
                            const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    )),
                onDismissed: (direction) {
                  tarefas.remove(tarefa);
                  setState(() {});
                },
                key: Key(tarefa.id.toString()),
                child: Column(
                  children: [
                    ListTile(
                        title: Text(
                      tarefa.descricao,
                      style: const TextStyle(color: Colors.white),
                    )),
                    const Divider()
                  ],
                ));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => const CadastrarTarefaPage())));
          },
          tooltip: 'Adicionar tarefa',
          child: const Icon(Icons.add),
          backgroundColor: Theme.of(context).secondaryHeaderColor,
        ),
      ),
    );
  }
}
