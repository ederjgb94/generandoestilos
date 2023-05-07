import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:generandoestilos/data.dart';
import 'package:generandoestilos/estadisticaspdf.dart';
import 'package:generandoestilos/reporte.dart';
import 'package:generandoestilos/ticketpdf.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';

void main() {
  runApp(
    const MaterialApp(
      title: "My App",
      home: HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Directory> getDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My App"),
      ),
      body: Center(
        child: FutureBuilder(
          future: getDirectory(),
          builder: (BuildContext context, AsyncSnapshot<Directory> snapshot) {
            String? dir = snapshot.data?.path.toString();
            if (snapshot.hasData) {
              return Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      var pdf = await generateReporte(PdfPageFormat.letter);
                      final file = File('$dir/example5.pdf');
                      await file.writeAsBytes(pdf);
                    },
                    child: const Text("Click Me2"),
                  ),
                  Text('$dir/example5.pdf'),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            appBar: AppBar(),
                            body: PDFView(
                              filePath: '$dir/example5.pdf',
                              enableSwipe: true,
                              swipeHorizontal: true,
                              autoSpacing: false,
                              pageFling: false,
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Text("pdf Me"),
                  ),
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
