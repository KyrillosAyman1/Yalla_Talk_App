import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodePage extends StatelessWidget {
  const QRCodePage({super.key});

  static const String id = 'qrcode_page';

  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(title: Text("QR Code")),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                color: Colors.white,
                child: QrImageView(
                  data: email,
                  size: 200,
                  version: 3,
                  errorCorrectionLevel: QrErrorCorrectLevel.H,
                  embeddedImage: AssetImage("assets/images/222.png"),
                  embeddedImageStyle: QrEmbeddedImageStyle(size: Size(40, 40)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
