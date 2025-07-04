import 'package:isar/isar.dart';

//this line is needed to generate isar file 
// run cmd terminal : dart run build_runner build
part 'expenses.g.dart';

@Collection()
class Expenses{
  Id id = Isar.autoIncrement;
  final String name ;
  final double amount;
  final DateTime date ;

  Expenses({
    required this.name,
    required this.amount,
    required this.date,
  });
}