part of 'dashboard_provider.dart';

class DashboardState {
  final Status status;
  final Status loadingMoreStatus;
  final String message;
  final int page;
  final int pageSize;
  final List<UserProfile> userProfile;
  final UserProfile? lastOpenedProfile;

  DashboardState({
    this.status = Status.idle,
    this.loadingMoreStatus = Status.idle,
    this.message = "",
    this.pageSize = 10,
    this.page = 1,
    this.userProfile = const [],
    this.lastOpenedProfile,
  });

  DashboardState copyWith({
    Status? status,
    Status? loadingMoreStatus,
    String? message,
    int? pageSize,
    int? page,
    List<UserProfile>? userProfile,
    UserProfile? lastOpenedProfile,
  }) {
    return DashboardState(
      status: status ?? this.status,
      loadingMoreStatus: loadingMoreStatus ?? this.loadingMoreStatus,
      message: message ?? this.message,
      pageSize: pageSize ?? this.pageSize,
      userProfile: userProfile ?? this.userProfile,
      page: page ?? this.page,
      lastOpenedProfile: lastOpenedProfile ?? this.lastOpenedProfile,
    );
  }
}
