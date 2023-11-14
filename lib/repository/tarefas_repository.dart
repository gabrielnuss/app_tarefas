import 'package:app_tarefas/model/tarefas_model.dart';
import 'package:app_tarefas/repository/database.dart';

class TarefaRepository {
  Future<List<TarefasModel>> selectAll(bool concluido) async {
    List<TarefasModel> tarefas = [];
    var db = await DataBaseSQLite().getDataBase();
    var result = await db.rawQuery(concluido
        ? "SELECT * FROM tarefas WHERE concluido = 1"
        : "SELECT * FROM tarefas");

    for (var element in result) {
      tarefas.add(TarefasModel(
          int.parse(element["id"].toString()),
          element["descricao"].toString(),
          element["horario"].toString(),
          DateTime.parse(element["data"].toString()),
          element["concluido"] == 1));
    }
    return tarefas;
  }

  void delete(TarefasModel tarefa) async {
    var db = await DataBaseSQLite().getDataBase();
    await db.rawDelete("DELETE FROM tarefas WHERE id = ?", [tarefa.id]);
  }

  void update(TarefasModel tarefa) async {
    var db = await DataBaseSQLite().getDataBase();
    await db.rawUpdate("UPDATE FROM tarefas WHERE id = ?", [tarefa.id]);
  }

  void insert(TarefasModel tarefa) async {
    var db = await DataBaseSQLite().getDataBase();
    await db.rawInsert(
        "INSERT INTO tarefas (id, descricao, horario, data, concluido) values(?,?,?,?,?)",
        [
          tarefa.id,
          tarefa.descricao,
          tarefa.horario,
          tarefa.data.toString(),
          tarefa.concluido
        ]);
  }
}
