import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ProfileTileSkeleton extends StatelessWidget {
  const ProfileTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.colorScheme.surfaceVariant.withOpacity(0.5);
    final highlightColor = theme.colorScheme.surfaceVariant.withOpacity(0.2);
    final skeletonColor = theme.colorScheme.surfaceVariant;

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
        leading: Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: skeletonColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
        title: Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Container(
            height: 12.h,
            width: 100.w,
            color: skeletonColor,
            margin: EdgeInsets.symmetric(vertical: 4.h),
          ),
        ),
        subtitle: Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Container(
            height: 10.h,
            width: 160.w,
            color: skeletonColor,
            margin: EdgeInsets.only(top: 4.h),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward,
          size: 20.dg,
          color: theme.iconTheme.color?.withOpacity(0.3) ?? Colors.grey,
        ),
      ),
    );
  }
}
