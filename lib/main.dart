import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:generandoestilos/reporte.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:share_whatsapp/share_whatsapp.dart';
import 'package:flimer/flimer.dart';
import 'package:url_launcher/url_launcher.dart';

const _kTextMessage =
    'Hola *ROBERTO!* Te recordamos que tienes una visita programada en nuestro taller _AUTROMOTRIZ MARTINEZ_ *MAÑANA* a las *11:30am* para *SERVICIO DE FRENOS*. ¡Esperamos verte pronto!';

void main() {
  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
  // runApp(const MaterialApp(
  //   home: HomePage(),
  // ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _mapInstalled =
      WhatsApp.values.asMap().map<WhatsApp, String?>((key, value) {
    return MapEntry(value, null);
  });

  @override
  void initState() {
    super.initState();
    _checkInstalledWhatsApp();
  }

  Future<void> _checkInstalledWhatsApp() async {
    String whatsAppInstalled = await _check(WhatsApp.standard),
        whatsAppBusinessInstalled = await _check(WhatsApp.business);

    if (!mounted) return;

    setState(() {
      _mapInstalled[WhatsApp.standard] = whatsAppInstalled;
      _mapInstalled[WhatsApp.business] = whatsAppBusinessInstalled;
    });
  }

  Future<String> _check(WhatsApp type) async {
    try {
      return await shareWhatsapp.installed(type: type)
          ? 'INSTALLED'
          : 'NOT INSTALLED';
    } on PlatformException catch (e) {
      return e.message ?? 'Error';
    }
  }

  Future<Directory> getDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  void sendWhatsAppMessage() async {
    String phoneNumber =
        '+52 1 833 382 0929'; // Número de teléfono del destinatario
    String message = 'Hola, ¿cómo estás?'; // Mensaje a enviar

    var url = 'https://wa.me/$phoneNumber?text=HelloWorld';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'No se pudo abrir la URL: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share WhatsApp Example'),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            // const ListTile(title: Text('STATUS INSTALLATION')),
            // ...WhatsApp.values.map((type) {
            //   final status = _mapInstalled[type];

            //   return ListTile(
            //     title: Text(type.toString()),
            //     trailing: status != null
            //         ? Text(status)
            //         : const CircularProgressIndicator.adaptive(),
            //   );
            // }),
            // const ListTile(title: Text('SHARE CONTENT')),
            // ListTile(
            //   title: const Text('Share Text'),
            //   trailing: const Icon(Icons.share),
            //   onTap: () => shareWhatsapp.shareText(_kTextMessage),
            // ),
            // ListTile(
            //   title: const Text('Share Image'),
            //   trailing: const Icon(Icons.share),
            //   onTap: () async {
            //     final file = await flimer.pickImage();
            //     if (file != null) {
            //       shareWhatsapp.shareFile(file);
            //     }
            //   },
            // ),
            ListTile(
              title: const Text('Enviar PDF a número especifico'),
              trailing: const Icon(Icons.share),
              onTap: () async {
                final dir = (await getDirectory()).path;
                XFile file = XFile('$dir/example6.pdf', name: 'example.pdf');

                await shareWhatsapp.share(
                  text: 'Hello World',
                  file: file,
                  phone: '+52 1 833 295 6072',
                );
              },
            ),
            ListTile(
              title: const Text('Enviar Mensaje de Cita'),
              trailing: const Icon(Icons.share),
              onTap: () => shareWhatsapp.share(
                text: _kTextMessage,
                // change with real whatsapp number
                phone: '+52 1 833 295 6072',
              ),
            ),
            ListTile(
              title: const Text('Generar Reporte'),
              trailing: const Icon(Icons.share),
              onTap: () async {
                final dir = (await getDirectory()).path;
                var pdf = await generateReporte(PdfPageFormat.letter);
                final file = File('$dir/example6.pdf');
                await file.writeAsBytes(pdf);
              },
            ),
            ListTile(
              title: const Text('Ver PDF Generado'),
              trailing: const Icon(Icons.share),
              onTap: () async {
                final dir = (await getDirectory()).path;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(),
                      body: PDFView(
                        filePath: '$dir/example6.pdf',
                        enableSwipe: true,
                        swipeHorizontal: true,
                        autoSpacing: false,
                        pageFling: false,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ).toList(),
      ),
    );
  }
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
                      final file = File('$dir/example6.pdf');
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
                              filePath: '$dir/example6.pdf',
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
