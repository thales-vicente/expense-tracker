import 'package:isar/isar.dart';

//TODO this line is needed to generate isar file
// TODO run cmd in terminal: dart run build_runner build
part 'expense.g.dart';

@Collection()
class Expense{
  Id id = Isar.autoIncrement; // 0,1,2...
  final String name;
  final double amount;
  final DateTime date;

  Expense({
    required this.name,
    required this.amount,
    required this.date,
});
}