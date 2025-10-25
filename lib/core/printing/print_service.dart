import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../domain/entities/models/financial_transaction.dart';

class ReceiptService {
  // Define the target width for visual spacing mimicry
  static const int _receiptWidth = 40;

  /// Helper to format the current date and time for the receipt header.
  String _formatDateTime(DateTime now) {
    final monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final hour = now.hour;
    final displayHour = (hour % 12) == 0 ? 12 : (hour % 12);
    final period = hour >= 12 ? 'PM' : 'AM';
    final minute = now.minute.toString().padLeft(2, '0');

    final monthName = monthNames[now.month - 1];
    final day = now.day;
    final year = now.year;

    return '${displayHour.toString().padLeft(2, '0')}:$minute $period - $monthName $day, $year';
  }

  /// Helper to generate a motivational message based on attendance percentage.
  pw.Widget _generateMotivation(double percentage) {
    final roundedPercentage = percentage.toStringAsFixed(0);
    String message = '';

    if (percentage >= 80.0) {
      message =
          'ELITE PERFORMANCE! \n\nYour $roundedPercentage% attendance in the last month is incredible.\nKeep the momentum high, we are proud of you!';
    } else if (percentage >= 50.0) {
      message =
          'GREAT CONSISTENCY! \n\nYour $roundedPercentage% attendance is strong. Push for that 80% mark next month!';
    } else {
      message =
          'WE MISSED YOU! \n\nYour current attendance is $roundedPercentage%.\nA little progress adds up—lets make the next 30 days your strongest yet!';
    }

    // Return as a centered PDF widget
    return pw.Center(
      child: pw.Text(
        message,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          fontSize: 8,
          font: pw.Font.courier(), // Use monospaced font
          lineSpacing: 1.2,
        ),
      ),
    );
  }

  // Helper function to create aligned receipt rows using PDF widgets.
  pw.Widget _buildReceiptRow(String label, String value, {bool bold = false}) {
    final style = pw.TextStyle(
      fontSize: 9,
      fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
      font: pw.Font.courier(), // Crucial for a clean, receipt-like look
    );

    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: style),
          pw.Expanded(child: pw.Container()), // Spacer to push the value right
          pw.Text(value, style: style),
        ],
      ),
    );
  }

  /// Generates the receipt PDF and sends it to the native printer service.
  Future<bool> generateAndPrintReceipt({
    required FinancialTransaction params,
    double? percentage,
    String? userName,
  }) async {
    try {
      // 2. Calculate financial totals
      const tax = 0.00; // Based on your code setting tax to 0
      final total = params.amount ?? 1000.0;
      final timestamp = _formatDateTime(DateTime.now());
      // Placeholder attendance percentage for the motivational message
      final finalAmountStr = params.amount?.toStringAsFixed(2) ?? "1000.0";
      final taxStr = tax.toStringAsFixed(2);
      final totalStr = total.toStringAsFixed(2);

      // 3. Generate the PDF document
      final doc = pw.Document();
      final dividerText = List.generate(_receiptWidth, (index) => '-').join();

      // Define page format: 5 inches wide (5 * 72.0 points) and infinite height
      doc.addPage(
        pw.Page(
          pageFormat: const PdfPageFormat(
            5 * 72.0, // Width: 5 inches (360 points)
            double.infinity, // Height: Continuous roll
            marginAll: 0.2 * 72.0, // Margin: 0.2 inches (14.4 points)
          ),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Transaction Details
                pw.Text(
                  'Transaction ID: PWH${DateTime.now().microsecondsSinceEpoch}',
                  style: pw.TextStyle(fontSize: 8, font: pw.Font.courier()),
                ),
                pw.Text(
                  'Date: $timestamp',
                  style: pw.TextStyle(fontSize: 8, font: pw.Font.courier()),
                ),
                pw.SizedBox(height: 3),
                pw.Text(
                  dividerText,
                  style: pw.TextStyle(fontSize: 8, font: pw.Font.courier()),
                ),

                // Member Details
                pw.Text(
                  'MEMBER DETAILS:',
                  style: pw.TextStyle(
                    fontSize: 9,
                    font: pw.Font.courier(),
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  'Name: $userName',
                  style: pw.TextStyle(fontSize: 8, font: pw.Font.courier()),
                ),
                pw.Text(
                  'ID: ${params.relatedMemberId}',
                  style: pw.TextStyle(fontSize: 8, font: pw.Font.courier()),
                ),
                pw.Text(
                  dividerText,
                  style: pw.TextStyle(fontSize: 8, font: pw.Font.courier()),
                ),

                // Items Table Header
                _buildReceiptRow('ITEM', 'AMOUNT (PKR)', bold: true),
                pw.Text(
                  dividerText,
                  style: pw.TextStyle(fontSize: 8, font: pw.Font.courier()),
                ),

                // Items Row
                _buildReceiptRow(
                  params.type?.toUpperCase() ?? 'Service',
                  'PKR $finalAmountStr',
                ),
                pw.Text(
                  dividerText,
                  style: pw.TextStyle(fontSize: 8, font: pw.Font.courier()),
                ),

                // Totals
                _buildReceiptRow('Subtotal', 'PKR $finalAmountStr'),
                _buildReceiptRow('Tax (0%)', 'PKR $taxStr'),

                // Total Line
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 3),
                  child: _buildReceiptRow(
                    'TOTAL DUE',
                    'PKR $totalStr',
                    bold: true,
                  ),
                ),
                pw.Text(
                  dividerText,
                  style: pw.TextStyle(fontSize: 8, font: pw.Font.courier()),
                ),

                // Footer
                pw.Text(
                  'Cashier: Power House Admin',
                  style: pw.TextStyle(fontSize: 8, font: pw.Font.courier()),
                ),
                pw.Text(
                  dividerText,
                  style: pw.TextStyle(fontSize: 8, font: pw.Font.courier()),
                ),
                pw.SizedBox(height: 10),

                // Motivational Message
                _generateMotivation(percentage ?? 50.00),
              ],
            );
          },
        ),
      );

      // 4. Send the generated PDF to the native OS printer dialog
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save(),
        name: 'PowerHouse_Receipt_${params.id}', // Name shown in print queue
      );

      return true;
    } catch (e) {
      print('Error during receipt printing: $e');
      return false;
    }
  }
}
