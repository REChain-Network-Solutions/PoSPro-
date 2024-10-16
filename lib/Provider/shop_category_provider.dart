import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Repository/API/business_category_repo.dart';
import '../model/business_category_model.dart';

BusinessCategoryRepository businessCategoryRepository = BusinessCategoryRepository();
final businessCategoryProvider = FutureProvider<List<BusinessCategory>>((ref) => businessCategoryRepository.getBusinessCategories());
