import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:optiparse_nawabs/components/bottom_bar.dart';
import 'package:optiparse_nawabs/components/noSearch.dart';
import 'package:optiparse_nawabs/components/transaction_small_card.dart';
import 'package:optiparse_nawabs/services/get_filtered_transaction.dart';
import 'package:optiparse_nawabs/storage/models/transaction.dart';

final log = Logger();

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  double? _min_amount;
  double? _max_amount;
  DateTime? _dateFrom;
  DateTime? _dateTo;
  bool _isExpense = false;
  bool _isIncome = false;

  List<Transaction> _filteredTransactions = [];

  @override
  void initState() {
    super.initState();
    _filterTransactions();
  }

  void _filterTransactions() {
    setState(() {
      // Logic to filter transactions based on user input
      _filteredTransactions = getFilteredTransactions(
        searchText: _searchController.text,
        min_amount: _min_amount,
        max_amount: _max_amount,
        dateFrom: _dateFrom,
        dateTo: _dateTo,
        expense: _isExpense,
        income: _isIncome,
      );
    });
  }

  void _showAmountBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        double _startValue = _min_amount ?? 0.0;
        double _endValue = _max_amount ?? 100000.0;

        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Select Amount Range',
                      style: Theme.of(context).textTheme.headlineLarge),
                  RangeSlider(
                    values: RangeValues(_startValue, _endValue),
                    min: 0,
                    max: 100000,
                    divisions: 100000,
                    labels: RangeLabels(
                      _startValue.toStringAsFixed(0),
                      _endValue.toStringAsFixed(0),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _startValue = values.start;
                        _endValue = values.end;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _min_amount = null;
                            _max_amount = null;
                            _filterTransactions();
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _min_amount = _startValue;
                            _max_amount = _endValue;
                          });
                          _filterTransactions();
                          Navigator.pop(context);
                        },
                        child: const Text('Apply'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showDateBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('From Date'),
                trailing: const Icon(Icons.calendar_today),
                subtitle: _dateFrom != null
                    ? Text(DateFormat('dd/MM/yyyy').format(_dateFrom!))
                    : const Text('Select a date'),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _dateFrom ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _dateFrom = picked;
                    });
                    Navigator.pop(context);
                    _showDateBottomSheet();
                  }
                },
              ),
              ListTile(
                title: const Text('To Date'),
                trailing: const Icon(Icons.calendar_today),
                subtitle: _dateTo != null
                    ? Text(DateFormat('dd/MM/yyyy').format(_dateTo!))
                    : const Text('Select a date'),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _dateTo ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _dateTo = picked;
                    });
                    Navigator.pop(context);
                    _showDateBottomSheet();
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _dateFrom = null;
                        _dateTo = null;
                        _filterTransactions();
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _filterTransactions();
                      Navigator.pop(context);
                    },
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search transactions...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.white,
            filled: true,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _filterTransactions();
              },
            ),
          ),
          onChanged: (value) {
            _filterTransactions();
          },
        ),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('Income'),
                  selected: _isIncome & !(_isIncome & _isExpense),
                  onSelected: (selected) {
                    setState(() {
                      _isIncome = selected;
                      _isExpense = false;
                    });
                    _filterTransactions();
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Date'),
                  selected: _dateFrom != null || _dateTo != null,
                  onSelected: (selected) {
                    _showDateBottomSheet();
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Amount'),
                  selected: _min_amount != null || _max_amount != null,
                  onSelected: (selected) {
                    _showAmountBottomSheet();
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Expense'),
                  selected: _isExpense & !(_isIncome & _isExpense),
                  onSelected: (selected) {
                    setState(() {
                      _isExpense = selected;
                      _isIncome = false;
                    });
                    _filterTransactions();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredTransactions.length == 0
                ? const Center(child: Nosearch())
                : ListView.separated(
                    itemCount: _filteredTransactions.length,
                    padding: const EdgeInsets.all(16.0),
                    separatorBuilder: (context, index) =>
                        Divider(color: Colors.grey[300]),
                    itemBuilder: (context, index) {
                      final transaction =
                          _filteredTransactions.reversed.toList()[index];
                      return TransactionCard(
                        transactionId: transaction.id,
                        onTransactionUpdated: () => {_filterTransactions()},
                      );
                    },
                  ),
          ),
        ],
      ),
      // bottomNavigationBar: buildBottomNavBar(context),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}
