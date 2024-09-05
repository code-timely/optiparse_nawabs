import 'package:objectbox/objectbox.dart';

@Entity()
class Transaction {
  @Id(assignable: true)
  int id;

  String title;
  String merchantName;
  double amount;
  DateTime date;
  String invoiceId;
  bool isExpense;
  String? notes;

  Transaction(
      {this.id = 0,
      required this.title,
      required this.merchantName,
      required this.amount,
      required this.date,
      required this.invoiceId,
      required this.isExpense,
      this.notes});
  // Method to convert Transaction to Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'vendors_name': merchantName,
      'total_amount': amount,
      'date': date.toIso8601String(),
      'invoice_id': invoiceId,
      'is_expense': isExpense,
      'buyer_name': notes,
    };
  }
}
