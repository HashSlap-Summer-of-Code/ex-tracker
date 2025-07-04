/*
These are some helpful function used across the app 
*/

import 'package:intl/intl.dart';
//convert string to a double 
double convertStringToDouble(String string){
  double? amount = double.tryParse(string);
  return amount ?? 0;
}

//formate double amount into ruppes and paisa
String formateAmount (double amount){
  final format = NumberFormat.currency(locale: "en_INR" , symbol: "\₹",decimalDigits: 2);
  return format.format(amount);
}