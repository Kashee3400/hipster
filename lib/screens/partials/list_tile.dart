import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../dashboard/models/user_profile_model.dart';

class ProfileTile extends StatelessWidget {
  final UserProfile employee;
  final VoidCallback onTap;

  const ProfileTile({
    super.key,
    required this.employee,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
        onTap: onTap,
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
  }
}
