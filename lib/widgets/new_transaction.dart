import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './adaptive_button.dart';

class NewTransaction extends StatefulWidget {
  final Function addNewTransaction;
  const NewTransaction({Key? key,required this.addNewTransaction}) : super(key: key);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime? _selectedDate;
  void submitData(){
    if(amountController.text.isEmpty){
      return;
    }
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);
    if(enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null){
      return;
    }
    widget.addNewTransaction(enteredTitle,enteredAmount,_selectedDate);
    Navigator.of(context).pop();
  }
  void _presenteDatePicker(){
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((value){
      if(value == null){
        return;
      }
      setState(() {
        _selectedDate = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            left: 10,
            top: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                onSubmitted: (_) => submitData(),
              ),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                ),
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitData(),
              ),
              SizedBox(
                height: 70,
                child: Row(
                  children: [
                    Text(_selectedDate == null?'No Data Chosen' : DateFormat.yMd().format(_selectedDate!)),
                    AdaptiveButton(chosenDate: 'Choose Date', presenteDatePicker: _presenteDatePicker)
                  ],
                ),
              ),
              ElevatedButton(
                style: TextButton.styleFrom(
                    textStyle: TextStyle(
                        color: Theme.of(context).textTheme.labelLarge!.color,
                    ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                onPressed: submitData,
                child: const Text('Add Transaction'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
