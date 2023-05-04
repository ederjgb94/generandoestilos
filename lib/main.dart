import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:pdf/widgets.dart' as pw;

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
                      final pdf = pw.Document();
                      pdf.addPage(
                        pw.Page(
                          build: (pw.Context context) => pw.Center(
                            child: pw.Text(
                              'CAMPUSTD',
                              style: pw.TextStyle(
                                  fontSize: 40, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                        ),
                      );

                      final file = File('$dir/example.pdf');
                      await file.writeAsBytes(await pdf.save());
                    },
                    child: const Text("Click Me"),
                  ),
                  Text('$dir/example.pdf'),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            appBar: AppBar(),
                            body: PDFView(
                              filePath: '$dir/example.pdf',
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

          // child:
        ),
      ),
    );
  }
}
