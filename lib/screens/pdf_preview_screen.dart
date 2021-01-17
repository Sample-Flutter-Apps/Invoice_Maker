import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:share/share.dart';

class PdfPreviewScreen extends StatelessWidget {
  final String path;

  PdfPreviewScreen(
    this.path,
  );

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      appBar: AppBar(
        title: Text('Document'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () async {
              final RenderBox box = context.findRenderObject();
              await Share.shareFiles([path],
                  text: 'Test',
                  subject: 'Test',
                  sharePositionOrigin:
                      box.localToGlobal(Offset.zero) & box.size);
            },
          ),
        ],
      ),
      path: path,
    );
  }
}
