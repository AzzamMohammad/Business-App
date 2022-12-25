import 'package:flutter/material.dart';

Widget MyDivider(BuildContext context , double Thickness){
  return Divider(
    thickness: Thickness ,
    color: Theme.of(context).colorScheme == ColorScheme.light() ? Colors.black : Colors.white,
  );
}