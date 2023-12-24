import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './widgets/transaction_list.dart';
import './models/transaction.dart';
import './widgets/new_transaction.dart';
import './widgets/chart.dart';

void main(){
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Planner',
      theme: ThemeData(
        fontFamily: 'Quicksand',
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: const TextTheme(
            titleLarge: TextStyle(
              fontFamily: 'OpenSans',
            ),
            labelLarge: TextStyle(
              color: Colors.white,
            )
        ),
      ),
      home: const MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  bool _showChart = false;
  final List<Transaction> _userTransactions = [
    Transaction(id: 't1',title: 't-shirt' , amount: 99.99,date: DateTime.now()),
    Transaction(id: 't2',title: 'shoes' , amount: 99.99,date: DateTime.now()),
  ];

  void _addNewTransaction(String txTitle,double txAmount,DateTime selectedDate){
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: selectedDate,
    );
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx){
  showModalBottomSheet(context: ctx, builder: (_){
    return GestureDetector(
      onTap: (){},
      behavior: HitTestBehavior.opaque,
      child: NewTransaction(addNewTransaction: _addNewTransaction,),
    );
  });
  }
  void _deleteTransaction(String id){
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }
  List<Transaction> get _recentTransactions{
    return _userTransactions.where((tx){
      return tx.date.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }
  @override
  /*void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    super.didChangeAppLifecycleState(state);
  }*/
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final dynamic appBar = Platform.isIOS ? CupertinoNavigationBar(
    middle: const Text('Expense Planner'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => _startAddNewTransaction(context),
            child: const Icon(CupertinoIcons.add),
          )
        ],
      ),
    ) :AppBar(
      title: const Text('Expense Planner'),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        )
      ],
    );
    final chartWidget = SizedBox(
        height: (MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top) * 0.7,
        child: Chart(recentTransactions: _recentTransactions));
    final txListWidget = SizedBox(
        height: (MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top) * 0.7,
        child: TransactionList(transactions: _userTransactions,deleteTransaction: _deleteTransaction,));
    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(isLandscape) Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Show Chart',style: Theme.of(context).textTheme.titleMedium,),
                Switch.adaptive(
                  value: _showChart,
                  activeColor: Theme.of(context).colorScheme.secondary,
                  onChanged: (val){
                    setState(() {
                      _showChart = val;
                    });
                  },)
              ],
            ),
            if(!isLandscape) chartWidget,
            if(!isLandscape) txListWidget,
            if(isLandscape) _showChart ?
            chartWidget : txListWidget
          ],
        ),
      ),
    );
    return Platform.isIOS ? CupertinoPageScaffold(
      navigationBar: appBar,
      child: pageBody,
    ) : Scaffold(
      appBar: appBar,
      body: pageBody,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS ? const SizedBox() : FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}



