import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class PDFViewerPage extends StatefulWidget {
  final String path;

  const PDFViewerPage({Key? key, required this.path}) : super(key: key);

  @override
  PDFViewerPageState createState() => PDFViewerPageState();
}

class PDFViewerPageState extends State<PDFViewerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          lang.S.of(context).invoiceViewr,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 20.0,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: PDFView(
              filePath: widget.path,
              // onViewCreated: (PDFViewController controller) {
              //   _pdfViewController = controller;
              // },
              // onPageChanged: (int page, int total) {
              //   setState(() {
              //     _currentPage = page;
              //     _pages = total;
              //   });
              // },
            ),
          ),
          // Container(
          //   padding: EdgeInsets.all(8.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: <Widget>[
          //       IconButton(
          //         icon: Icon(Icons.chevron_left),
          //         // onPressed: () {
          //         //   _pdfViewController.previousPage(
          //         //     duration: Duration(milliseconds: 250),
          //         //     curve: Curves.ease,
          //         //   );
          //         // },
          //       ),
          //       Text('$_currentPage/$_pages'),
          //       IconButton(
          //         icon: const Icon(Icons.chevron_right),
          //         onPressed: () {
          //           _pdfViewController.setPage(
          //
          //             duration: Duration(milliseconds: 250),
          //             curve: Curves.ease,
          //           );
          //         },
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
