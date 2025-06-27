import 'package:pdf/widgets.dart' as pw;            // PDF Widgets
import 'package:printing/printing.dart';            // For preview/sharing/printing
import 'package:pdf/pdf.dart'; // <-- This is essential for PdfColors
Future<void> exportDiaryToPdf(List<Map<String, dynamic>> entries) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      build: (context) => [
        pw.Header(
          level: 0,
          child: pw.Text('My Diary Entries', style: pw.TextStyle(fontSize: 24)),
        ),
        ...entries.map((entry) {
          return pw.Container(
            margin: const pw.EdgeInsets.symmetric(vertical: 10),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(entry['title'] ?? 'Untitled',
                    style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                // ...existing code...
                pw.Text(
  entry['date'] ?? '',
  style: pw.TextStyle(
    fontSize: 12,
    color: PdfColors.grey, // ✅ This works when `pdf.dart` is imported
  ),
),

               // ...existing code...
                pw.Text('Mood: ${entry['mood'] ?? '🙂'}', style: pw.TextStyle(fontSize: 14)),
                pw.SizedBox(height: 4),
                pw.Text(entry['content'] ?? '', style: pw.TextStyle(fontSize: 14)),
              ],
            ),
          );
        })
      ],
    ),
  );

  // Show the PDF preview and allow sharing/printing
  await Printing.layoutPdf(onLayout: (format) async => pdf.save());
}
