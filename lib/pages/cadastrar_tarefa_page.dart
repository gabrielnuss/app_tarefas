import 'package:app_tarefas/model/tarefas_model.dart';
import 'package:app_tarefas/notification/notifications_service.dart';
import 'package:app_tarefas/repository/tarefas_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CadastrarTarefaPage extends StatefulWidget {
  const CadastrarTarefaPage({super.key});

  @override
  State<CadastrarTarefaPage> createState() => _CadastrarTarefaPageState();
}

class _CadastrarTarefaPageState extends State<CadastrarTarefaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        title: Text("Cadastrar tarefa"),
      ),
      body: TaskScreen(),
    );
  }
}

class Task {
  String name;
  String description;
  DateTime dateTime;

  Task({required this.name, required this.description, required this.dateTime});
}

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  TextEditingController _taskController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  late TarefaRepository tarefaRepository = TarefaRepository();

  _addTask() async {
    DateTime DiaHorario = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
      20,
    );
    TarefasModel tarefa;

    if (DiaHorario.isBefore(DateTime.now()) ||
        DiaHorario.isAtSameMomentAs(DateTime.now())) {
      tarefa = TarefasModel.semId(
          _descriptionController.text,
          TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
          DateTime.now().add(Duration(minutes: 1)),
          false);
    } else {
      tarefa = TarefasModel.semId(
          _descriptionController.text,
          TimeOfDay(hour: DiaHorario.hour, minute: DiaHorario.minute),
          DiaHorario,
          false);
    }

    var id = await tarefaRepository.insert(tarefa, context);
    Provider.of<NotificationService>(context, listen: false).showNotification(
        CustomNotification(
            id: id,
            title: tarefa.descricao,
            body: "Você tem uma tarefa para agora",
            payload: '/home'),
        tarefa.data);
    // Limpar os controladores após adicionar uma tarefa
    _taskController.clear();
    _descriptionController.clear();

    setState(() {});
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 10.0),
          TextField(
            controller: _descriptionController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                hintText: 'Descrição',
                hintStyle: TextStyle(color: Colors.white)),
          ),
          SizedBox(height: 10.0),
          Row(
            children: [
              Expanded(
                child: Text('Data: ${_selectedDate.toLocal()}',
                    style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () => _selectDate(context),
                child: Text('Selecionar Data',
                    style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor)),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Hora: ${_selectedTime.format(context)}',
                    style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () => _selectTime(context),
                child: Text(
                  'Selecionar Hora',
                  style:
                      TextStyle(color: Theme.of(context).secondaryHeaderColor),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              if (_descriptionController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text('Preencha corretamente o campo de "Descrição".')));
              } else {
                _addTask();
              }
            },
            child: Text('Adicionar Tarefa'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).secondaryHeaderColor),
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
