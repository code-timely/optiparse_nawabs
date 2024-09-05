import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:optiparse_nawabs/components/add_transaction_details.dart';
import 'package:optiparse_nawabs/services/get_transaction_by_id.dart';
import 'package:optiparse_nawabs/storage/models/transaction.dart';

class TransactionCard extends StatefulWidget {
  final int transactionId;
  final Function onTransactionUpdated;

  TransactionCard(
      {required this.transactionId, required this.onTransactionUpdated});

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  Future<Transaction?> getTransaction() async {
    return getTransactionById(widget.transactionId);
  }

  String getImage(Transaction transaction) {
    if (transaction.isExpense) {
      return 'expeness'; // Image for expense
    } else {
      return 'income'; // Image for income
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // Get the current orientation
    Orientation orientation = MediaQuery.of(context).orientation;
    // Check if the orientation is portrait
    bool isPortrait = orientation == Orientation.portrait;

    return FutureBuilder<Transaction?>(
      future: getTransaction(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('Transaction not found'));
        } else {
          final transaction = snapshot.data!;

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTransaction(
                    initialData: transaction.toMap(),
                    transactionId: transaction.id,
                  ),
                ),
              ).then((_) => {setState(() {widget.onTransactionUpdated();})});
            },
            child: Container(
              margin: const EdgeInsets.only(left: 0, right: 0, top: 13),
              height: isPortrait ? size.height * 0.157 : size.height * 0.32,
              width: size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: transaction.isExpense
                    ? const Color.fromARGB(255, 255, 255, 255)
                    : const Color.fromARGB(255, 255, 255,
                        255), // Background color based on expense flag
              ),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        left: 10, right: 10), // Reduced left margin
                    height: size.height * 0.081,
                    width: size.height * 0.081,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 13,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Container(
                      child: Image.asset(
                        "assets/" + getImage(transaction) + ".png",
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: const EdgeInsets.only(top: 5),
                        padding: const EdgeInsets.only(right: 10, top: 1, bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    transaction.title,
                                    softWrap: false,
                                    overflow: TextOverflow.clip,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      DateFormat('d MMM yyyy')
                                          .format(transaction.date),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Expanded(
                              child: Text(
                                "₹${transaction.amount.toStringAsFixed(2)}",
                                softWrap: false,
                                overflow: TextOverflow.clip,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                transaction.merchantName,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            const SizedBox(height: 1),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
