import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:optiparse_nawabs/constants.dart';
import 'package:optiparse_nawabs/services/get_filtered_transaction.dart';
import 'package:optiparse_nawabs/storage/models/transaction.dart';

class TheBarChart extends StatefulWidget {
  final List listOftransactions;
  TheBarChart({required this.listOftransactions});

  @override
  State<StatefulWidget> createState() => TheBarChartState();
}

class TheBarChartState extends State<TheBarChart> {
  final Color leftBarColor = kPrimaryColor;
  final Color rightBarColor = const Color(0xffff5182);
  final Color nullBarColor = Colors.grey.withOpacity(0.2);
  final Color exceedBarColor = Colors.orange;
  final double width = 7;
  List myList = [];
  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;
  DateTime? _dateFrom;
  DateTime? _dateTo;
  late DateTime? prevFrom;
  late DateTime? prevTo;
  List<Transaction> _filteredTransactions = [];

  void _filterTransactions() {
    setState(() {
      // Logic to filter transactions based on user input
      _filteredTransactions = getAnalysisFilteredTransactions(
        dateFrom: _dateFrom,
        dateTo: _dateTo,
      );
      
      myList = [];
    });
    makeList();
    setState(() {
      int i = -1;
      final items = myList.reversed.map((e) {
        i++;
        return makeGroupData(
          i,
          (e['expense']).toDouble(),
          (e['income']).toDouble(),
        );
      }).toList();

      rawBarGroups = items;
      showingBarGroups = rawBarGroups;
    });
  }

  void _showDateBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
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
                      prevFrom = _dateFrom;
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
                      prevTo = _dateTo;
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
                        _dateFrom = prevFrom;
                        _dateTo = prevTo;
                        myList = [];
                        _filterTransactions();
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_dateTo!.difference(_dateFrom!).inDays > 6){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Date Error'),
                              content: Text('Select dates than span a week or lesser'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                      else if (_dateTo!.difference(_dateFrom!).inDays <= 0){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Date Error'),
                              content: Text('Seriously Bruhh!! Check those damn dates. Who puts the FROM date to occur after the TO date'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                      else{
                        myList = [];
                        _filterTransactions();
                        Navigator.pop(context);
                      }
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
  void initState() {
    super.initState();
    setState(() {
      this._dateTo = DateTime.now();
      this._dateFrom = DateTime.now().subtract(Duration(days: 6));
      this.prevFrom = _dateFrom;
      this.prevTo = _dateTo;
    });
    _filteredTransactions = getAnalysisFilteredTransactions(
        dateFrom: _dateFrom,
        dateTo: _dateTo,
      );
    makeList();

    int i = -1;
    final items = myList.reversed.map((e) {
      i++;
      return makeGroupData(
        i,
        (e['expense']).toDouble(),
        (e['income']).toDouble(),
      );
    }).toList();

    rawBarGroups = items;
    showingBarGroups = rawBarGroups;
  }

  void makeList() {
    myList = [];
    for (int i = 0; i < 7; i++) {
      var dayVar = _dateTo?.subtract(Duration(days: i));
      double expenses = 0;
      double incomes = 0;
      for (int j = 0; j < _filteredTransactions.length; j++) {
        if (_filteredTransactions[j].date.day == dayVar?.day &&
            _filteredTransactions[j].date.month == dayVar?.month &&
            _filteredTransactions[j].date.year == dayVar?.year) {
          if( _filteredTransactions[j].isExpense == true){
            expenses += _filteredTransactions[j].amount;
          }
          else{
            incomes += _filteredTransactions[j].amount;
          }
        }
      }
      if(expenses > 2500){
        expenses = 2501;
      }
      if(incomes > 2500){
        incomes = 2501;
      }
      _filteredTransactions.removeWhere((element) =>
      element.date.day == dayVar?.day &&
          element.date.month == dayVar?.month &&
          element.date.year == dayVar?.year);
      myList.add({
        'expense': expenses,
        'income': incomes,
        'day': dayVar,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${DateFormat(DateFormat.MONTH).format(DateTime.now())} - ${DateTime.now().year}",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 15),
          Row(
            children: [
              ChoiceChip(
              label: const Text('Date'),
              selected: _dateFrom != null || _dateTo != null,
              onSelected: (selected) {
                _showDateBottomSheet();
              },
            ),Align(alignment: Alignment.centerRight,child:Padding(padding: const EdgeInsets.only(bottom: 10,left:25),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    "${_dateFrom?.day} ${DateFormat(DateFormat.ABBR_MONTH).format(_dateFrom!)} ----> ${_dateTo?.day} ${DateFormat(DateFormat.ABBR_MONTH).format(_dateTo!)} \n",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),),)
              
            ],
          ),

          AspectRatio(
            aspectRatio: 1,
            child: Card(
              margin: EdgeInsets.all(3),
              elevation: 1.2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 6, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        makeTransactionsIcon(),
                        const SizedBox(width: 38),
                        const Text(
                          'Transactions',
                          style: TextStyle(color: Colors.indigo, fontSize: 22),
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        width: screenwidth > 450? 0.7*screenwidth:screenwidth,
                        child :Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: BarChart(
                          BarChartData(
                            maxY: 2500,
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                    final index = value.toInt();
                                    final day = myList[6 - index]['day'];
                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      child: Text(
                                        DateFormat(DateFormat.ABBR_WEEKDAY)
                                            .format(day)
                                            .substring(0, 2),
                                        style: const TextStyle(
                                          color: Colors.indigo,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    );
                                  },
                                  // margin: 20,
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                    String text;
                                    if (value == 500) {
                                      text = '500';
                                    } else if (value == 1000) {
                                      text = '1K';
                                    } else if (value == 1500) {
                                      text = '1.5K';
                                    } else if (value == 2000) {
                                      text = '2K';
                                    } else if (value == 2500) {
                                      text = '2.5K';
                                    } else {
                                      text = '';
                                    }
                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      child: Text(
                                        text,
                                        style: const TextStyle(
                                          color: Colors.indigo,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    );
                                  },
                                  // margin: 32,
                                ),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: false,
                                  reservedSize: 40,

                                )
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: false
                                )
                              )
                            ),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            barGroups: showingBarGroups,
                            gridData: FlGridData(
                              drawVerticalLine: false,
                            ),
                          ),
                        ),
                      ),
                    ),),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                            child:
                                indicators(context, rightBarColor, "Income")),
                        Expanded(
                            child:
                                indicators(context, leftBarColor, "Expenses")),
                                Expanded(
                            child:
                                indicators(context, exceedBarColor, "2.5K + ")),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  FlLine horizontal_grid(){
    return FlLine(
      color: Colors.grey.shade300,
      strokeWidth: 1,
      dashArray: [5, 5], // Dashed vertical lines
    );
  }

  Widget indicators(BuildContext context, Color color, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 15),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: color,
            radius: 5,
          ),
          const SizedBox(width: 7),
          Text(
            text,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    Color select_colour1;
    if(y1 > 2500){
      select_colour1 = exceedBarColor;
    }else if(y1 == 0){
      select_colour1 = nullBarColor;
    }else{
      select_colour1 = leftBarColor;
    }
    Color select_colour2;
    if(y2 > 2500){
      select_colour2 = exceedBarColor;
    }else if(y2 == 0){
      select_colour2 = nullBarColor;
    }else{
      select_colour2 = rightBarColor;
    }
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1 == 0 ? 20 : y1,
          color: select_colour1,
          width: width,
        ),
        BarChartRodData(
          toY: y2 == 0 ? 20 : y2,
          color: select_colour2,
          width: width,
        ),
      ],
    );
  }

  Widget makeTransactionsIcon() {
    const double width = 4.5;
    const double space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.blue.withOpacity(0.7),
        ),
        const SizedBox(width: space),
        Container(
          width: width,
          height: 28,
          color: Colors.amber.withOpacity(0.6),
        ),
        const SizedBox(width: space),
        Container(
          width: width,
          height: 42,
          color: Colors.blue,
        ),
        const SizedBox(width: space),
        Container(
          width: width,
          height: 28,
          color: Colors.amber.withOpacity(0.6),
        ),
        const SizedBox(width: space),
        Container(
          width: width,
          height: 10,
          color: Colors.blue.withOpacity(0.7),
        ),
      ],
    );
  }
}
