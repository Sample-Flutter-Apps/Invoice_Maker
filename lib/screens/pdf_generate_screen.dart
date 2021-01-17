import 'dart:io';

import 'package:flutter/material.dart';
import 'package:invoice_maker_2/helpers/pdf_generator.dart';
import 'package:invoice_maker_2/screens/pdf_preview_screen.dart';
import 'package:path_provider/path_provider.dart';

class PdfGenerateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Sample PDF'),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(bottom: 20.0),
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.deepOrange.shade900,
            boxShadow: [
              BoxShadow(
                blurRadius: 8,
                color: Colors.black26,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Text(
            'Welcome to Invoice PDF Generator',
            style: TextStyle(
              // ignore: deprecated_member_use
              color: Theme.of(context).accentTextTheme.title.color,
              fontSize: 17,
              fontFamily: 'Anton',
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          PdfGenerator pdfGenerator = new PdfGenerator();
          final pdfInBytes = await pdfGenerator.createPDF();
          //debugPrint(pdfInBytes.toString());

          //write file to doc directory
          Directory directory = await getApplicationDocumentsDirectory();
          String documentPath = directory.path + '/test2.pdf';
          File file = new File(documentPath);
          file.writeAsBytesSync(pdfInBytes);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfPreviewScreen(documentPath),
            ),
          );
        },
        //backgroundColor: Theme.of(context).appBarTheme.color,
        icon: Icon(Icons.picture_as_pdf),
        label: Text("Generate PDF"),
      ),
    );
  }
}
