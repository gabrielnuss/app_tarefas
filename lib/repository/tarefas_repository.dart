import 'package:app_tarefas/model/tarefas_model.dart';
import 'package:app_tarefas/repository/database.dart';

class TarefaRepository {
  Future<List<TarefasModel>> selectAll(bool concluido) async {
    List<TarefasModel> tarefas = [];
    var db = await DataBaseSQLite().getDataBase();
    var result = await db.rawQuery(concluido
        ? "SELECT * FROM tarefas WHERE concluido = 1"
        : "SELECT * FROM tarefas WHERE concluido = 0");

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

  Future<void> delete(TarefasModel tarefa) async {
    var db = await DataBaseSQLite().getDataBase();
    await db.rawDelete("DELETE FROM tarefas WHERE id = ?", [tarefa.id]);
  }

  Future<void> update(TarefasModel tarefa) async {
    var db = await DataBaseSQLite().getDataBase();
    await db.rawUpdate(
        "UPDATE tarefas SET descricao = ?, horario = ?, data = ?, concluido = ? WHERE id = ?",
        [
          tarefa.descricao,
          tarefa.horario,
          tarefa.data.toString(),
          tarefa.concluido,
          tarefa.id
        ]);
  }

  Future<int> insert(TarefasModel tarefa) async {
    var db = await DataBaseSQLite().getDataBase();
    await db.rawInsert(
        "INSERT INTO tarefas (descricao, horario, data, concluido) values(?,?,?,?)",
        [
          tarefa.descricao,
          tarefa.horario,
          tarefa.data.toString(),
          tarefa.concluido
        ]);

    var result =
        await db.rawQuery("SELECT id FROM tarefas ORDER BY id DESC limit 1");
    var mapResult = result[0];

    return int.parse(mapResult["id"].toString());
  }
}
