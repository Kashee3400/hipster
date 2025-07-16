import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hipster/app_constants.dart';
import 'package:hipster/utils/error_message.dart';
import 'package:hipster/utils/shared_pref.dart';

import '../../app_router/route_constants.dart';
import '../dashboard/models/user_profile_model.dart';
import '../dashboard/riverpod/dashboard_provider.dart';

class ReportList extends ConsumerWidget {
  final DashboardState currentState;

  const ReportList({super.key, required this.currentState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = currentState.userProfile;
    final theme = Theme.of(context);

    if (results.isEmpty) {
      return MessageBox(
        message: "No data found",
        type: currentState.status,
        icon: Icons.error_outline,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8.0, bottom: 15.0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final UserProfile employee = results[index];

        return Container(
          margin: EdgeInsets.fromLTRB(5.dg, 4.dg, 5.dg, 0.dg),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(6.r),
            border: Border(
              right: BorderSide(color: theme.primaryColor, width: 2),
              bottom: BorderSide(color: theme.primaryColor, width: 2),
            ),
          ),
          child: ListTile(
            onTap: () {
              SharedPref.storeInt(Constants.userId, employee.id ?? 0);
              ref.read(dashboardNotifierProvider.notifier).updateLastOpenedProfile();
              context.push('/${Routes.employeeDetail}', extra: employee);
            },
            leading: Container(
              height: double.infinity,
              width: 60,
              alignment: Alignment.center,
              child: ClipOval(
                child: Image.network(
                  employee.photo ?? "",
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 28,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      width: 48,
                      height: 48,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                      ),
                    );
                  },
                ),
              ),
            ),
            title: Text(
              employee.name ?? "N/A",
              style: TextStyle(
                fontSize: 12.sp,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            subtitle: Text(
              employee.email ?? "N/A",
              style: TextStyle(
                fontSize: 12.sp,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward,
              size: 20.dg,
            ),
          ),
        );
      },
    );
  }
}
