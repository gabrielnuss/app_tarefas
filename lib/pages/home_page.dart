// ignore_for_file: use_build_context_synchronously

import 'package:app_tarefas/model/tarefas_model.dart';
import 'package:app_tarefas/notification/notifications_service.dart';
import 'package:app_tarefas/pages/cadastrar_tarefa_page.dart';
import 'package:app_tarefas/repository/pontos_repository.dart';
import 'package:app_tarefas/repository/tarefas_repository.dart';
import 'package:app_tarefas/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<TarefasModel> tarefas = [];
  TarefaRepository tarefaRepository = TarefaRepository();
  PontosRepository pontosRepository = PontosRepository();

  @override
  void initState() {
    super.initState();
    obterLista();
  }

  Future<void> obterLista() async {
    tarefas = await tarefaRepository.selectAll(false);
    setState(() {});
  }

  void deletarNotificacao(TarefasModel tarefa) {
    Provider.of<NotificationService>(context, listen: false)
        .deleteNotification(tarefa.id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          title: const Text("Tarefas"),
        ),
        body: RefreshIndicator(
          onRefresh: obterLista,
          child: ListView.builder(
            itemCount: tarefas.length,
            itemBuilder: (context, index) {
              var tarefa = tarefas[index];
              return Card(
                elevation: 5,
                shadowColor: Theme.of(context).secondaryHeaderColor,
                color: Theme.of(context).primaryColor,
                child: Dismissible(
                    movementDuration: Duration(milliseconds: 200),
                    secondaryBackground: Container(
                        color: Colors.red,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.delete,
                                color: Color.fromARGB(255, 190, 182, 182),
                              ),
                            ],
                          ),
                        )),
                    background: Container(
                        color: Colors.green,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        )),
                    onDismissed: (DismissDirection direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        tarefa.setConcluido(true);
                        await tarefaRepository.update(tarefa);
                        await pontosRepository.somarPonto();
                        deletarNotificacao(tarefa);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Parabéns! Você ganhou mais 10 pontos!  "),
                            Icon(
                              Icons.monetization_on,
                              color: Colors.yellow,
                            )
                          ],
                        )));
                      } else {
                        await tarefaRepository.delete(tarefa);
                        deletarNotificacao(tarefa);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Tarefa Excluída"),
                            Expanded(child: Container()),
                            TextButton(
                                onPressed: () async {
                                  await tarefaRepository.insert(tarefa);
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  obterLista();
                                  setState(() {});
                                },
                                child: Text(
                                  "Desfazer",
                                  style: TextStyle(color: Colors.blue),
                                ))
                          ],
                        )));
                      }
                      obterLista();
                      setState(() {});
                    },
                    key: Key(tarefa.id.toString()),
                    child: ListTile(
                      title: Text(
                        tarefa.descricao,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20),
                      ),
                      subtitle: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              "${tarefa.data.day}/${tarefa.data.month}/${tarefa.data.year}",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              tarefa.horario,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    )),
              );
            },
          ),
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
        drawer: CustomDrawer(),
      ),
    );
  }
}
