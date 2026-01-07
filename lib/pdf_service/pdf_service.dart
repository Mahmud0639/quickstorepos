
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:quick_store_pos/pdf_service/invoice_design.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/material.dart';

class PdfService {
  static final ScreenshotController screenshotController = ScreenshotController();

  static Future<void> generateInvoice({
    required Map<String, dynamic> data,
    required bool isShare,
    bool isPosPrinter = false
  }) async {
    double targetWidth = isPosPrinter ? 300 : 450;
    PdfPageFormat format = isPosPrinter ? PdfPageFormat.roll80 : PdfPageFormat.a4;

    final Uint8List? imageBytes = await screenshotController.captureFromWidget(

      Material(
        child: Container(
          color: Colors.white,
          child: InvoiceDesignWidget(data: data,width: targetWidth,),
        ),
      ),
      pixelRatio: 3.0,
    );

    if (imageBytes == null) return;

    final pdf = pw.Document();
    final image = pw.MemoryImage(imageBytes);

    pdf.addPage(
      pw.Page(

        pageFormat: format,
        margin: const pw.EdgeInsets.all(10),
        build: (pw.Context context) {
          return pw.Align(
            alignment: pw.Alignment.topCenter,
            child: pw.Image(image, width: isPosPrinter ? null : PdfPageFormat.a4.width-40,fit: pw.BoxFit.contain),
          );
        },
      ),
    );

    if (isShare) {
      await Printing.sharePdf(bytes: await pdf.save(), filename: 'invoice_${data['saleId']}.pdf');
    } else {

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        format: format,
        name: 'Invoice_${data['saleId']}',
      );
    }
  }
}