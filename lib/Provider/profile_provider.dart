import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/model/business_info_model.dart';
import 'package:mobile_pos/model/dashboard_overview_model.dart';
import '../Repository/API/business_info_repo.dart';
import '../model/todays_summary_model.dart';

BusinessRepository businessRepository = BusinessRepository();
final businessInfoProvider = FutureProvider<BusinessInformation>((ref) => businessRepository.fetchBusinessData());
final summaryInfoProvider = FutureProvider<TodaysSummaryModel>((ref) => businessRepository.fetchTodaySummaryData());
final dashboardInfoProvider = FutureProvider.family.autoDispose<DashboardOverviewModel,String>((ref,type) => businessRepository.dashboardData(type));
