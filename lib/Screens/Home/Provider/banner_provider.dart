import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Model/banner_model.dart';
import '../Repo/banner_repo.dart';

BannerRepo imageRepo = BannerRepo();
final bannerProvider = FutureProvider<List<Banner>>((ref) => imageRepo.fetchAllIBanners());
