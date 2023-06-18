import 'package:excel_to_json/views/profesor_view.dart';
import 'package:flutter/material.dart';
import 'package:excel_to_json/controllers/archivo_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ArchivoController archivoController = ArchivoController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Excel to JSON'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ProfesorView();
                    },
                  ),
                );
              },
              child: const Text('Ver Profesores'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await archivoController.abrirExcel();
                setState(() {});
              },
              child: const Text('Seleccionar archivo Excel'),
            ),
            const SizedBox(height: 20),
            archivoController.archivo != null
                ? Text(archivoController.archivo!.files.single.name)
                : const Text('No se ha seleccionado un archivo'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                archivoController.leerExcel();
              },
              child: const Text('Convertir a JSON'),
            ),
          ],
        ),
      ),
    );
  }
}
