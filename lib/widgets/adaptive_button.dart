import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveButton extends StatelessWidget {
  final String chosenDate;
  final dynamic presenteDatePicker;
  const AdaptiveButton({Key? key,required this.chosenDate,required this.presenteDatePicker}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ? CupertinoButton(
      // color: Colors.blue,
      onPressed: presenteDatePicker,
      child: Text(chosenDate,style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),),
    ) : TextButton(
      onPressed: presenteDatePicker,
      style: TextButton.styleFrom(
          textStyle: TextStyle(
            color: Theme.of(context).primaryColor,
          )
      ),
      child: Text(chosenDate,style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),),
    );
  }
}
