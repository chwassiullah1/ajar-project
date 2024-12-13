import 'package:ajar/models/booking/invoice_invoice.dart';

class BookingInvoice {
    final InvoiceInvoice invoice;

    BookingInvoice({
        required this.invoice,
    });

    factory BookingInvoice.fromJson(Map<String, dynamic> json) => BookingInvoice(
        invoice: InvoiceInvoice.fromJson(json["invoice"]),
    );

    Map<String, dynamic> toJson() => {
        "invoice": invoice.toJson(),
    };
}