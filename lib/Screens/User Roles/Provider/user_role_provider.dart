import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/Screens/User%20Roles/Model/user_role_model.dart';

import '../Repo/user_role_repo.dart';

UserRoleRepo repo = UserRoleRepo();
final userRoleProvider = FutureProvider<List<UserRoleModel>>((ref) => repo.fetchAllUsers());
