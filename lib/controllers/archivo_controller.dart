import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
// import 'dart:convert';
// import 'package:universal_html/html.dart' as html;

class ArchivoController {
  FilePickerResult? archivo;

  Future<void> abrirExcel() async {
    try {
      //abrir el explorador de archivos, solo se pueden seleccionar archivos .xlsx
      archivo = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        allowMultiple: false,
      );
      //imprimir nombre del archivo
      print(archivo!.files.single.name);
    } catch (e) {
      print('Error al seleccionar archivos: $e');
    }
  }

  void leerExcel() {
    try {
      if (archivo != null) {
        Map<String, dynamic> profesoresMapa = {};
        String key = '';
        //se decodifican los bytes del archivo
        Uint8List? bytes = archivo!.files.single.bytes;
        Excel excel = Excel.decodeBytes(bytes!);
        Sheet tabla = excel.tables['Sheet1']!;

        //primer for para recorrer la hoja de excel, como se sabe que solo tiene una hoja, se puede acceder directamente, se empieza en la fila 7 porque no contiene información relevante antes de esa fila
        print('empieza el for');
        for (int i = 7; i < tabla.rows.length; i++) {
          List<Data?> row = tabla.rows[i];
          //si la primera celda es diferente de null, es porque contiene información
          if (row[0] != null) {
            //si la primera celda contiene un numero, es un profesor y ese numero es su id
            //si no contiene un numero, es un horario de un profesor
            if (row[0]!.value.toString().contains(RegExp(r'[0-9]'))) {
              //como varios datos estan en la misma celda, se separan por medio de un split
              List<String> datos =
                  row[0]!.value.toString().substring(8).split(' - ');
              String nombre = datos[0];
              String tipo = datos[1];
              String codigo = datos[2];
              String id = row[0]!.value.toString().substring(0, 5);

              //se crea la llave del profesor para el mapa
              key = '$id-$nombre';

              //se agrega el profesor al mapa
              profesoresMapa[key] = {
                'id': id,
                'nombre': nombre,
                'tipo': tipo,
                'codigo': codigo,
                'horarios': []
              };

              //se salta una fila porque no contiene información relevante
              i = i + 1;
            } else {
              //se agrega el horario al profesor a la lista de horarios
              profesoresMapa[key]['horarios'].add(
                {
                  'grupo': row[0]!.value.toString(),
                  'clave': row[1]!.value.toString(),
                  'materia': row[2]!.value.toString(),
                  'sit': row[3]!.value.toString(),
                  'f.f': row[4]!.value.toString(),
                  'dias': [
                    row[5]!.value.toString(),
                    row[6]!.value.toString(),
                    row[7]!.value.toString(),
                    row[8]!.value.toString(),
                    row[9]!.value.toString(),
                    row[10]!.value.toString(),
                    row[11]!.value.toString(),
                  ],
                  'hrsSem': row[12]!.value.toString(),
                  'hrsM': row[13]!.value.toString(),
                  'hrsNom': row[14]!.value.toString(),
                  'aula': row[15]!.value.toString(),
                  'inscritos': row[16]!.value.toString(),
                  'asistencias': {
                    //'17/06': {'asis': false, 'imagen': ''},
                  },
                },
              );
            }
          }
        }
        print(profesoresMapa);

        // String jsonString = jsonEncode(profesoresMapa);
        // final bytesJson = utf8.encode(jsonString);
        // final blob = html.Blob([bytesJson]);
        // final url = html.Url.createObjectUrlFromBlob(blob);
        // final anchor = html.document.createElement('a') as html.AnchorElement
        //   ..href = url
        //   ..style.display = 'none'
        //   ..download = 'datos.json';
        // html.document.body?.children.add(anchor);
        // anchor.click();
        // html.document.body?.children.remove(anchor);
        // html.Url.revokeObjectUrl(url);
      }
    } catch (e) {
      print('Error al leer el archivo: $e');
    }
  }
}
