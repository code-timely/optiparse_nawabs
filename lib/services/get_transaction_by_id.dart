import 'package:optiparse_nawabs/storage/initialise_objectbox.dart';
import 'package:optiparse_nawabs/storage/models/transaction.dart';

// Transaction? getTransactionById(int id) {
//   return objectbox.transactionBox.get(id);
// }

Future<Transaction?> getTransactionById(int id) async {
  return objectbox.transactionBox.get(id);
}
