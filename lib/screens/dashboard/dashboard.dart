import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hipster/screens/dashboard/models/user_profile_model.dart';
import 'package:hipster/screens/partials/build_no_internet.dart';
import 'package:hipster/screens/partials/list_tile.dart';

import '../../app_router/route_constants.dart';
import '../../utils/base_status.dart';
import '../../utils/error_message.dart';
import '../loaders/list_skeleton_loader.dart';
import '../partials/build_header.dart';
import '../partials/list_view.dart';
import '../partials/message_widget.dart';
import 'riverpod/dashboard_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardNotifierProvider);
    final notifier = ref.watch(dashboardNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/logo/logo.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          return connected
              ? child
              : NoInternetPage(
                  onRetry: () {
                    _onRefresh();
                  },
                  loading: state.status == Status.loading,
                );
        },
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: Theme.of(context).colorScheme.primary,
          child: ListView(
            controller: notifier.scrollController,
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              if (state.message.isNotEmpty)
                GenericAnimatedSwitcherBox<String>(
                  data: state.message.isNotEmpty ? state.message : null,
                  builder: (msg) => MessageBox(
                    type: state.status,
                    message: msg,
                  ),
                ),
              if (state.status == Status.success &&
                  state.lastOpenedProfile != null &&
                  state.lastOpenedProfile!.id != null) ...[
                buildLastOpenedProfile(state.lastOpenedProfile!),
              ],
              if (state.status == Status.loading)
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 9,
                  itemBuilder: (_, __) => const ProfileTileSkeleton(),
                )
              else if (state.status == Status.error)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(state.message),
                  ),
                )
              else if (state.status == Status.success) ...[
                const SectionHeader(title: "Employee List"),
                ReportList(currentState: state),
              ],
              if (state.loadingMoreStatus == Status.loading)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLastOpenedProfile(UserProfile employee) {
    final state = ref.watch(dashboardNotifierProvider);
    return Column(
      children: [
        const SectionHeader(title: "Last Opened Profile"),
        state.status == Status.loading
            ? const ProfileTileSkeleton()
            : ProfileTile(
                employee: employee,
                onTap: () {
                  context.push('/${Routes.employeeDetail}', extra: employee);
                }),
        const Divider()
      ],
    );
  }

  Future<void> _onRefresh() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(dashboardNotifierProvider.notifier).resetData();
      ref.read(dashboardNotifierProvider.notifier).fetchUsers();
    });
  }
}
