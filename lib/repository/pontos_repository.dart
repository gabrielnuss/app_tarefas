import 'package:app_tarefas/repository/database.dart';

class PontosRepository {
  Future<int> selectPontos() async {
    var db = await DataBaseSQLite().getDataBase();

    var result = await db.rawQuery("SELECT ponto FROM pontos");
    if (result.isEmpty) {
      return 0;
    } else {
      var mapResult = result[0];
      return int.parse(mapResult["ponto"].toString());
    }
  }

  Future<void> somarPonto(int pontuacao) async {
    var db = await DataBaseSQLite().getDataBase();
    var result = await db.rawQuery("SELECT ponto FROM pontos");
    if (result.isEmpty) {
      await db.rawInsert("INSERT INTO pontos (ponto) values(?)", [pontuacao]);
    } else {
      var mapResult = result[0];
      int ponto = int.parse(mapResult["ponto"].toString());
      await db.rawUpdate("UPDATE pontos SET ponto = ?", [ponto + pontuacao]);
    }
  }
}
