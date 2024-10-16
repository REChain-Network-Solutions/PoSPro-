// ignore_for_file: file_names

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/Screens/Products/Model/brands_model.dart';
import 'package:mobile_pos/Screens/Products/Model/category_model.dart';

import '../Model/unit_model.dart';
import '../Repo/brand_repo.dart';
import '../Repo/category_repo.dart';
import '../Repo/unit_repo.dart';

CategoryRepo categoryRepo = CategoryRepo();
final categoryProvider = FutureProvider<List<CategoryModel>>((ref) => categoryRepo.fetchAllCategory());

BrandsRepo brandsRepo = BrandsRepo();
final brandsProvider = FutureProvider<List<Brand>>((ref) => brandsRepo.fetchAllBrands());

UnitsRepo unitsRepo = UnitsRepo();
final unitsProvider = FutureProvider<List<Unit>>((ref) => unitsRepo.fetchAllUnits());
