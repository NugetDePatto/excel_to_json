import 'package:excel_to_json/ejemplo.dart';
import 'package:flutter/material.dart';

class ProfesorView extends StatefulWidget {
  const ProfesorView({super.key});

  @override
  State<ProfesorView> createState() => _ProfesorViewState();
}

class _ProfesorViewState extends State<ProfesorView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profesores'),
      ),
      body: ListView(
        children: [
          //mostrar el nombre de los profesores de un mapa
          for (var profesor in profesores.values)
            ListTile(
              title: Text(profesor['nombre']),
              subtitle: Text('Clases totales: ${profesor['horarios'].length}'),
              leading: Text(profesor['id']),
            ),
        ],
      ),
    );
  }
}
