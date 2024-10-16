import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/Screens/Due%20Calculation/Model/due_collection_model.dart';

import '../Model/due_collection_invoice_model.dart';
import '../Repo/due_repo.dart';

DueRepo repo = DueRepo();
final dueInvoiceListProvider = FutureProvider.family<DueCollectionInvoice, int>((ref, id) => repo.fetchDueInvoiceList(id: id));
final dueCollectionListProvider = FutureProvider<List<DueCollection>>((ref) => repo.fetchDueCollectionList());
