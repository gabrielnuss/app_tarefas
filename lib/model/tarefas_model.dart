class TarefasModel {
  int _id = 0;
  String _descricao = "";
  String _horario = "";
  DateTime _data = DateTime.now();
  bool _concluido = false;

  TarefasModel(
      this._id, this._descricao, this._horario, this._data, this._concluido);

  int get id => _id;
  String get descricao => _descricao;
  String get horario => _horario;
  DateTime get data => _data;
  bool get concluido => _concluido;

  void setDescricao(String descricao) {
    _descricao = descricao;
  }

  void setHorario(String horario) {
    _horario = horario;
  }

  void setData(DateTime data) {
    _data = data;
  }

  void setConcluido(bool concluido) {
    _concluido = concluido;
  }
}
