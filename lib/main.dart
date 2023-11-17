import 'package:app_tarefas/my_app.dart';
import 'package:app_tarefas/notification/notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(
    providers: [
      Provider<NotificationService>(
        create: (context) => NotificationService(),
      )
    ],
    child: const MyApp(),
  ));
}
