import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Model/subscription_plan_model.dart';
import '../Repo/subscriptionPlanRepo.dart';

SubscriptionPlanRepo subscriptionRepo = SubscriptionPlanRepo();
final subscriptionPlanProvider = FutureProvider.autoDispose<List<SubscriptionPlanModel>>((ref) => subscriptionRepo.fetchAllPlans());
