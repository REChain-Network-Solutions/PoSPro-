import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/Screens/Expense/Model/expanse_category.dart';

import '../Repo/expanse_category_repo.dart';

ExpanseCategoryRepo expenseCategoryRepo = ExpanseCategoryRepo();
final expanseCategoryProvider = FutureProvider.autoDispose<List<ExpenseCategory>>((ref) => expenseCategoryRepo.fetchAllExpanseCategory());
