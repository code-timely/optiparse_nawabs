import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:optiparse_nawabs/components/date_picker.dart';
import 'package:optiparse_nawabs/constants.dart';
import 'package:optiparse_nawabs/storage/initialise_objectbox.dart';
import 'package:optiparse_nawabs/storage/models/transaction.dart';


final log = Logger();
class AddTransaction extends StatefulWidget {
  // final Function addTransaction;
  final Map<String, dynamic> initialData;
  final int? transactionId;

  const AddTransaction({super.key, required this.initialData, this.transactionId});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  late TextEditingController _titleController;
  late TextEditingController _vendorsNameController;
  late TextEditingController _invoiceIdController;
  late TextEditingController _buyerNameController;
  late TextEditingController _amountController;
  late DateTime _dateValue;
  bool _isExpense = true; // Default to expense

  @override
  void initState() {
    super.initState();
    DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    _titleController = TextEditingController(text: widget.initialData['title']);
    _vendorsNameController =
        TextEditingController(text: widget.initialData['vendors_name']);
    _invoiceIdController =
        TextEditingController(text: widget.initialData['invoice_id']);
    _buyerNameController =
        TextEditingController(text: widget.initialData['buyer_name']);
    _amountController = TextEditingController(
        text: widget.initialData['total_amount']?.toString() ?? '0.0');
    try {
      log.i('Date: ${widget.initialData['date']}');
      _dateValue = dateFormat.parse(widget.initialData['date']);
    } catch (e) {
      _dateValue = DateTime.now();
    }
    if (widget.transactionId != null) {
      _isExpense = widget.initialData['is_expense'];
    }
  }

  void setDate(DateTime newDate) {
    setState(() {
      _dateValue = newDate;
    });
  }

  void deleteTransaction() {
    if (widget.transactionId != null) {
      final box = objectbox.transactionBox;
      box.remove(widget.transactionId!);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DatePicker(updateDateValue: setDate),
                  Container(
                    decoration: BoxDecoration(
                      color: !(_isExpense)
                          ? Colors.green[100]
                          : Colors
                              .transparent, // Change background color if selected
                      borderRadius: BorderRadius.circular(
                          8), // Optional: Add border radius for rounded corners
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _isExpense = false;
                        });
                      },
                      icon: Image.asset(
                        'assets/income.png', // Replace with your actual asset path for income
                        width: 50,
                        height: 50,
                      ),
                      tooltip: 'Income', // Optional: Tooltip for accessibility
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: _isExpense
                          ? Colors.red[100]
                          : Colors
                              .transparent, // Change background color if selected
                      borderRadius: BorderRadius.circular(
                          8), // Optional: Add border radius for rounded corners
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _isExpense = true;
                        });
                      },
                      icon: Image.asset(
                        'assets/expeness.png', // Replace with your actual asset path for expense
                        width: 50,
                        height: 50,
                      ),
                      tooltip: 'Expense', // Optional: Tooltip for accessibility
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 20),
              const SizedBox(height: 20),
              buildText("Title :"),
              TextField(
                controller: _titleController,
                cursorColor: Theme.of(context).primaryColor,
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Write your title here',
                ),
                style: kTextFieldTextStyle.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 20),
              buildText("Amount :"),
              TextField(
                controller: _amountController,
                cursorColor: Theme.of(context).primaryColor,
                keyboardType: TextInputType.number,
                decoration: kTextFieldDecoration.copyWith(
                  hintText: '₹ Enter amount',
                ),
                style: kTextFieldTextStyle.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 20),
              buildText("Vendor's Name :"),
              TextField(
                controller: _vendorsNameController,
                cursorColor: Theme.of(context).primaryColor,
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Write vendor\'s name here',
                ),
                style: kTextFieldTextStyle.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 20),
              buildText("Invoice ID :"),
              TextField(
                controller: _invoiceIdController,
                cursorColor: Theme.of(context).primaryColor,
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Write invoice ID here',
                ),
                style: kTextFieldTextStyle.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 20),
              buildText("Buyer Name :"),
              TextField(
                controller: _buyerNameController,
                cursorColor: Theme.of(context).primaryColor,
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Write buyer name here',
                ),
                style: kTextFieldTextStyle.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  // Dismiss the keyboard
                  FocusScope.of(context).unfocus();

                  // Access the transaction box
                  final box = objectbox.transactionBox;

                  // Create or update the Transaction object
                  final newTransaction = Transaction(
                    id: widget.transactionId ??
                        0, // Use provided ID or 0 for new transaction
                    title: _titleController.text,
                    merchantName: _vendorsNameController.text,
                    amount: double.parse(_amountController.text),
                    date: _dateValue,
                    invoiceId: _invoiceIdController.text,
                    isExpense: _isExpense,
                    notes: _buyerNameController.text,
                  );

                  // Add the transaction to the ObjectBox store
                  box.put(newTransaction);
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.all(1.0),
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        blurRadius: 4,
                        offset: const Offset(0, 0),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      "Save",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              if (widget.transactionId != null) ...[
                const SizedBox(height: 20),
                InkWell(
                  onTap: deleteTransaction,
                  child: Container(
                    margin: const EdgeInsets.all(1.0),
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 213, 16, 2),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          blurRadius: 4,
                          offset: const Offset(0, 0),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        "Delete",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }

  Text buildText(String name) {
    return Text(
      name,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: InkWell(
        onTap: () {
          // Dismiss the keyboard
          FocusScope.of(context).unfocus();
          Navigator.pop(context);
        },
        child: const Icon(Icons.close, color: Colors.black),
      ),
      title: const Text(
        "Transaction Details",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }
}
