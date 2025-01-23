import 'package:hive/hive.dart';

class MyHive {
  static const String _budget = 'Budget';
  static const String _remainingBudget = 'RemainingBudget';


  static late Box _ins;

  Box get ins => _ins;

  static init() async {
    _ins = await Hive.openBox('expense_tracker_DB');
  }


  static setBudget(double? amount){
    _ins.put(_budget, amount);
  }

  static getBudget(){
    return _ins.get(_budget, defaultValue: 0.0);
  }

  static setRemainingBudget(double? amount){
    _ins.put(_remainingBudget, amount);
  }

  static getRemainingBudget(){
    double budget = getBudget();
    return _ins.get(_remainingBudget, defaultValue: budget);
  }
}
