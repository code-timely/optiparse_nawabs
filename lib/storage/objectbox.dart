import 'package:optiparse_nawabs/storage/models/transaction.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../objectbox.g.dart';

class ObjectBox {

  late final Store store;

  late final Box<Transaction> transactionBox;

  ObjectBox._create(this.store) {
    transactionBox = Box<Transaction>(store);
  }
  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: p.join(docsDir.path, "optiparser"));
    return ObjectBox._create(store);
  }
}