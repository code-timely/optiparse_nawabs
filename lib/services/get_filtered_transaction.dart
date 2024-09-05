import 'package:logger/logger.dart';
import 'package:optiparse_nawabs/objectbox.g.dart';
import 'package:optiparse_nawabs/storage/initialise_objectbox.dart';
import 'package:optiparse_nawabs/storage/models/transaction.dart';

final log = Logger();
final logger = Logger();

List<Transaction> getFilteredTransactions({
  required String searchText,
  required bool expense,
  required bool income,
  required double? min_amount,
  required double? max_amount,
  required DateTime? dateFrom,
  required DateTime? dateTo,

}) {

  logger.i("db filtering transactions");

  logger.i("$searchText\t$expense$dateFrom\t$dateTo\t$min_amount\t$max_amount");

  final adjustedDateTo = dateTo != null ? dateTo.add(const Duration(days: 1)).subtract(const Duration(seconds: 1)) : null;

  final queryBuilder = objectbox.transactionBox.query(
    (Transaction_.title.contains(searchText, caseSensitive: false) |
      Transaction_.merchantName.contains(searchText, caseSensitive: false)|
      Transaction_.invoiceId.contains(searchText,caseSensitive: false)) &
    (dateFrom != null ? Transaction_.date.greaterOrEqual(dateFrom.millisecondsSinceEpoch) : Transaction_.date.greaterThan(0)) &
    (adjustedDateTo != null ? Transaction_.date.lessOrEqual(adjustedDateTo.millisecondsSinceEpoch) : Transaction_.date.lessThan(DateTime.now().millisecondsSinceEpoch)) &
    (expense ? Transaction_.isExpense.equals(true) :Transaction_.isExpense.equals(true) | Transaction_.isExpense.equals(false))&
    (income ? Transaction_.isExpense.equals(false) :Transaction_.isExpense.equals(true) | Transaction_.isExpense.equals(false)) &
    (min_amount!=null?Transaction_.amount.greaterOrEqual(min_amount) :Transaction_.isExpense.equals(true) | Transaction_.isExpense.equals(false)) &
    (max_amount!=null?Transaction_.amount.lessOrEqual(max_amount):Transaction_.isExpense.equals(true) | Transaction_.isExpense.equals(false))
  ).order(Transaction_.id);

  final query = queryBuilder.build();
  final transactions = query.find();

  query.close();

  return transactions;
}

List<Transaction> getAnalysisFilteredTransactions({
  required DateTime? dateFrom,
  required DateTime? dateTo,

}) {

  logger.i("db filtering transactions");

  logger.i("$dateFrom\t$dateTo\t");

  final adjustedDateTo = dateTo != null ? dateTo.add(const Duration(days: 1)).subtract(const Duration(seconds: 1)) : null;

  final queryBuilder = objectbox.transactionBox.query(

      (dateFrom != null ? Transaction_.date.greaterOrEqual(dateFrom.millisecondsSinceEpoch) : Transaction_.date.greaterThan(0)) &
      (adjustedDateTo != null ? Transaction_.date.lessOrEqual(adjustedDateTo.millisecondsSinceEpoch) : Transaction_.date.lessThan(DateTime.now().millisecondsSinceEpoch))

  ).order(Transaction_.id);

  final query = queryBuilder.build();
  final transactions = query.find();

  query.close();

  return transactions;
}
