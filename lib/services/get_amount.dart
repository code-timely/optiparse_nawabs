import 'package:logger/logger.dart';
import 'package:optiparse_nawabs/objectbox.g.dart';
import 'package:optiparse_nawabs/storage/initialise_objectbox.dart';
import 'package:optiparse_nawabs/storage/models/transaction.dart';

final log = Logger();
Map<String, double> getAmount() {
  double income = 0;
  double expenses = 0;
  double balance = 0;
  Box<Transaction> transactionBox;
  transactionBox = objectbox.transactionBox;
  // Query all transactions and sum income and expenses
  for (var transaction in transactionBox.getAll()) {
    if (!transaction.isExpense) {
      income += transaction.amount;
    } else {
      expenses += transaction.amount;
    }
  }
  balance = income - expenses;

  return {
    'income': income,
    'expenses': expenses,
    'balance': balance,
  };
}
