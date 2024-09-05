import 'package:optiparse_nawabs/storage/initialise_objectbox.dart';
import 'package:optiparse_nawabs/storage/models/transaction.dart';

List<Transaction> getTransactions() {
  return objectbox.transactionBox.getAll().reversed.toList();
}
