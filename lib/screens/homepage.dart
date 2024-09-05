import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:optiparse_nawabs/components/add_transaction_details.dart';
import 'package:optiparse_nawabs/components/bottom_bar.dart';
import 'package:optiparse_nawabs/components/dasboard_card.dart';
import 'package:optiparse_nawabs/components/last_transaction_see_all.dart';
import 'package:optiparse_nawabs/components/no_transaction.dart';
import 'package:optiparse_nawabs/components/transaction_small_card.dart';
import 'package:optiparse_nawabs/constants.dart';
import 'package:optiparse_nawabs/services/get_amount.dart';
import 'package:optiparse_nawabs/services/get_transactions.dart';
import 'package:optiparse_nawabs/services/img_service.dart';
import 'package:optiparse_nawabs/storage/initialise_objectbox.dart';
import 'package:optiparse_nawabs/storage/models/transaction.dart';
import 'package:optiparse_nawabs/ui/one_curveClipper.dart';
import 'package:optiparse_nawabs/ui/two_curvesClipper.dart';

final log = Logger();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Transaction> transaction;
  late Map<String, double> amount;
  bool isBottomNavBarVisible = false; // State variable for visibility
  bool establishingConnectionWithServer = false;
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    amount = getAmount();
    transaction = getTransactions();
  }

  Future<void> handleImageUpload() async {
    setState(() {
      establishingConnectionWithServer = true;
    });
    try{
      const url = "http://52.140.76.58:8000/api/";
      Response response = await dio.get(url, options: Options(
      receiveTimeout: const Duration(seconds: 4),
      sendTimeout: const Duration(seconds: 4),
      ));
      if (response.statusCode == 200) {
        log.i('Server is up and running');
        setState(() {
          establishingConnectionWithServer = false;
        });
        createTransaction();
      }
      else {
        log.i('Server is down');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Server is down, please try again later..."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    catch(e){
      log.e(e);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Server is down, please try again later..."),
            backgroundColor: Colors.red,
          ),
      );
    }
    finally{
      setState(() {
        establishingConnectionWithServer = false;
      });
    }
  }


  void createTransaction() async {
    ImgService imgService = ImgService();

    var data = await imgService.showOptions(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTransaction(
          initialData: data,
        ),
      ),
    ).then((_) => {
          setState(() {
            amount = getAmount();
            transaction = getTransactions();
          })
        });
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Welcome Back!",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
            fontFamily: 'Proxima Nova',
            textBaseline: TextBaseline.alphabetic,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    bool isPortrait = orientation == Orientation.portrait;

    Size size = MediaQuery.of(context).size;
    final realHeight = MediaQuery.of(context).size.height -
        buildAppBar(context).preferredSize.height -
        MediaQuery.of(context).padding.top;
    final realWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(context),
      body: isPortrait
          ? Column(
              children: [
                // Big Container with ry
                Container(
                  height: realHeight * 0.46,
                  width: realWidth,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: ClipPath(
                          clipper: OneCurve(),
                          child: Container(
                              height: size.height * 0.34,
                              color: kOneCurveColor),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: ClipPath(
                          clipper: TwoCurves(),
                          child: Container(
                            height: size.height * 0.15,
                            color: kTwoCurvesColor,
                          ),
                        ),
                      ),
                      Dashboard(
                        income: amount['income'] ?? 0.0,
                        expenses: amount['expenses'] ?? 0.0,
                        balance: amount['balance'] ?? 0.0,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: realHeight * 0.025,
                ),
                // to see all last transactions
                const LastTseeAll(),
                // Recent Transactions Section
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: realHeight * 0.01),
                    width: double.infinity,
                    child: transaction.length == 0
                        ? const Notransaction()
                        : SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment:
                                  objectbox.transactionBox.getAll().length <= 2
                                      ? MainAxisAlignment.start
                                      : MainAxisAlignment.spaceEvenly,
                              children: transaction
                                  .getRange(
                                      0,
                                      transaction.length < 3
                                          ? transaction.length
                                          : 3)
                                  .map<Widget>((tx) {
                                return TransactionCard(
                                  transactionId: tx.id,
                                  onTransactionUpdated: () => {
                                    setState(() {
                                      amount = getAmount();
                                      transaction = getTransactions();
                                    })
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                  ),
                ),
              ],
            )
          : Stack(children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ClipPath(
                  clipper: OneCurve(),
                  child: Container(
                      height: size.height * 0.45, color: kOneCurveColor),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ClipPath(
                  clipper: TwoCurves(),
                  child: Container(
                    height: size.height * 0.25,
                    color: kTwoCurvesColor,
                  ),
                ),
              ),
              Dashboard(
                income: amount['income'] ?? 0.0,
                expenses: amount['expenses'] ?? 0.0,
                balance: amount['balance'] ?? 0.0,
              ),
              Positioned(
                top: size.height * 0.01,
                bottom: size.height * 0.1,
                left: size.width / 2,
                child: Container(
                  margin: EdgeInsets.only(top: realHeight * 0.1),
                  width: size.width / 2,
                  child: transaction.length == 0
                      ? const Notransaction()
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment:
                                objectbox.transactionBox.getAll().length <= 2
                                    ? MainAxisAlignment.start
                                    : MainAxisAlignment.spaceEvenly,
                            children: transaction
                                .getRange(
                                    0,
                                    transaction.length < 3
                                        ? transaction.length
                                        : 3)
                                .map<Widget>((tx) {
                              return TransactionCard(
                                transactionId: tx.id,
                                onTransactionUpdated: () => {
                                  setState(() {
                                    amount = getAmount();
                                    transaction = getTransactions();
                                  })
                                },
                              );
                            }).toList(),
                          ),
                        ),
                ),
              ),
            ]),
      // bottomNavigationBar: buildBottomNavBar(context),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
      floatingActionButton: establishingConnectionWithServer
          ? const CircularProgressIndicator()
          :
        FloatingActionButton(
        onPressed: handleImageUpload,
        shape: const CircleBorder(),
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
