import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/Screens/Expense/Model/expense_modle.dart';

import '../Repo/expanse_repo.dart';

ExpenseRepo expanseRepo = ExpenseRepo();
final expenseProvider = FutureProvider<List<Expense>>((ref) => expanseRepo.fetchExpense());
