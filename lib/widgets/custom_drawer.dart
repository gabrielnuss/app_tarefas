import 'package:app_tarefas/repository/pontos_repository.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  PontosRepository pontosRepository = PontosRepository();
  int? quantidadePontos = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obterPontos();
  }

  void obterPontos() async {
    quantidadePontos = await pontosRepository.selectPontos();

    if (quantidadePontos == null) {
      quantidadePontos = 0;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    quantidadePontos.toString(),
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                  Icon(
                    Icons.monetization_on,
                    color: Colors.yellow,
                    size: 40,
                  )
                ],
              ),
              Text(
                "Moedas acumuladas",
                style: TextStyle(color: Colors.white, fontSize: 15),
              )
            ],
          )),
    );
  }
}
