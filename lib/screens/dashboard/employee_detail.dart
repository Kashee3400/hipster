import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hipster/screens/dashboard/models/user_profile_model.dart';

import '../partials/build_header.dart';

class UserDetailPage extends StatelessWidget {
  final UserProfile user;

  const UserDetailPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 220.h,
            backgroundColor: theme.primaryColor,
            leading: BackButton(
              color: theme.colorScheme.onPrimary,
            ),
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double top = constraints.biggest.height;
                final bool isCollapsed =
                    top <= (kToolbarHeight + MediaQuery.of(context).padding.top + 10);
                return FlexibleSpaceBar(
                  centerTitle: false,
                  title: isCollapsed
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 200),
                                style: TextStyle(
                                  fontSize: isCollapsed ? 16.sp : 20.sp,
                                  color: theme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                                child: Text(
                                  user.name ?? "User Details",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                            // Small profile icon appears only when collapsed
                            AnimatedOpacity(
                              opacity: isCollapsed ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 200),
                              child: Padding(
                                padding: EdgeInsets.only(right: 20.w),
                                child: CircleAvatar(
                                  radius: 18.r,
                                  backgroundImage: user.photo != null && user.photo!.isNotEmpty
                                      ? NetworkImage(user.photo!)
                                      : null,
                                  backgroundColor: theme.colorScheme.onPrimary,
                                  child: user.photo == null || user.photo!.isEmpty
                                      ? Icon(Icons.person, size: 18.r, color: theme.primaryColor)
                                      : null,
                                ),
                              ),
                            )
                          ],
                        )
                      : null,
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      AnimatedOpacity(
                        opacity: isCollapsed ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: Image.network(
                          user.photo ?? '',
                          width: 100.w,
                          height: 100.w,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => CircleAvatar(
                            radius: 50.r,
                            backgroundColor: theme.colorScheme.onPrimary,
                            child: Icon(Icons.person, size: 40, color: theme.primaryColor),
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.black54, Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        bottom: 16,
                        child: isCollapsed
                            ? const SizedBox.shrink()
                            : SizedBox(
                          width: MediaQuery.of(context).size.width - 32, // full width minus padding
                          child: Text(
                            user.name ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionCard(
                    title: 'Contact Information',
                    children: [
                      _buildDetailRow(Icons.email, 'Email', user.email),
                      _buildDetailRow(Icons.phone, 'Phone', user.phone),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  _sectionCard(
                    title: 'Address',
                    children: [
                      _buildDetailRow(Icons.home, 'Address', user.address),
                      _buildDetailRow(Icons.location_city, 'City/State/Country',
                          '${user.state}, ${user.country}'),
                      _buildDetailRow(Icons.local_post_office, 'ZIP Code', user.zip),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  _sectionCard(
                    title: 'Company & Username',
                    children: [
                      _buildDetailRow(Icons.business, 'Company', user.company),
                      _buildDetailRow(Icons.person, 'Username', user.username),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: title),
            SizedBox(height: 12.h),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String? value) {
    if (value == null || value.trim().isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: Colors.blueGrey),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey[600],
                    )),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
