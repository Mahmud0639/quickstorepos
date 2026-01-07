import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoiceHelper {
  static final ScreenshotController screenshotController = ScreenshotController();

  static Future<void> generatePerfectBanglaPdf(dynamic myInvoiceWidget) async {

    final uint8list = await screenshotController.captureFromWidget(
      myInvoiceWidget,
      delay: Duration(milliseconds: 100),
    );


    final pdf = pw.Document();
    final image = pw.MemoryImage(uint8list);

    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Center(child: pw.Image(image));
      },
    ));

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}