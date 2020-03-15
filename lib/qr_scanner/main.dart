import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class ScannerPage extends StatefulWidget {
  static String routeName = "scanner_page";
  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  var qrText = "";
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController controller;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
      });
      Clipboard.setData(ClipboardData(text: scanData));
      final snackBar = SnackBar(content: Text('Yay! A SnackBar!'));
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 6,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  Text(
                    'Result',
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 30,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                      onPressed: () async {
                        if (qrText.length > 0) {
                          if (await canLaunch(qrText)) {
                            await launch(qrText);
                          } else {
                            print("Can't load");
                          }
                        }
                      },
                      child: Text('$qrText'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
