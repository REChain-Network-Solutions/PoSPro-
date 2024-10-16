import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/Screens/Products/Model/product_model.dart';

import '../Repo/product_repo.dart';

ProductRepo productRepo = ProductRepo();
final productProvider = FutureProvider<List<ProductModel>>((ref) => productRepo.fetchAllProducts());
