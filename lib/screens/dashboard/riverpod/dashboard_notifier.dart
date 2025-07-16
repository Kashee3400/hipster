part of 'dashboard_provider.dart';

class DashboardNotifier extends StateNotifier<DashboardState> {
  late DioApiService dioApiService;
  Timer? _clearTimer;

  final ScrollController scrollController = ScrollController();

  DashboardNotifier() : super(DashboardState(status: Status.idle)) {
    _initialize();
    scrollController.addListener(scrollListener);
  }

  Future<void> _initialize() async {
    dioApiService = DioApiService();
    await fetchUsers();
    updateLastOpenedProfile();
  }

  void updateLastOpenedProfile() {
    final lastOpenedProfileId = SharedPref.getInt(Constants.userId);
    if (lastOpenedProfileId == 0) return;

    final lastOpenedProfile = state.userProfile.firstWhere(
      (e) => e.id == lastOpenedProfileId,
      orElse: () => const UserProfile(),
    );

    state = state.copyWith(lastOpenedProfile: lastOpenedProfile);
  }

  void scrollListener() {
    if (!scrollController.hasClients) return;
    final position = scrollController.position;
    final isNearBottom = position.pixels >= position.maxScrollExtent - 100;
    if (isNearBottom &&
        state.loadingMoreStatus == Status.idle &&
        state.status != Status.loading &&
        state.loadingMoreStatus != Status.completed) {
      fetchUsers(loadMore: true);
    }
  }

  Future<void> fetchUsers({
    bool scrollToNew = false,
    bool prepend = false,
    bool loadMore = false,
  }) async {
    if (state.loadingMoreStatus == Status.loading || state.loadingMoreStatus == Status.completed) {
      return;
    }
    if (loadMore) {
      state = state.copyWith(loadingMoreStatus: Status.loading);
    } else {
      state = state.copyWith(status: Status.loading);
    }

    try {
      final response = await dioApiService.getRequest(
        endPoint: 'users',
        queryParams: {
          "_page": state.page,
          "_limit": state.pageSize,
        },
      );

      if (response.statusCode == 200) {
        final list = response.data as List<dynamic>;
        if (list.isEmpty) {
          state = state.copyWith(loadingMoreStatus: Status.completed);
          return;
        }

        final existingIds = state.userProfile.map((e) => e.id).toSet();

        final usersList = list
            .whereType<Map<String, dynamic>>()
            .map((item) => UserProfile.fromJson(item))
            .where((user) => !existingIds.contains(user.id))
            .toList();

        if (usersList.isEmpty) {
          state = state.copyWith(loadingMoreStatus: Status.completed);
          return;
        }

        final updatedUsers =
            prepend ? [...usersList, ...state.userProfile] : [...state.userProfile, ...usersList];

        double scrollOffset = scrollController.offset;
        if (scrollToNew && prepend) {
          const itemHeight = 110.0;
          scrollOffset += usersList.length * itemHeight;
        }

        state = state.copyWith(
          userProfile: updatedUsers,
          page: state.page + 1,
          status: Status.success,
          loadingMoreStatus: usersList.length < state.pageSize ? Status.completed : Status.idle,
          message: "Data fetched successfully.",
        );

        if (scrollToNew && prepend) {
          await Future.delayed(const Duration(milliseconds: 100));
          scrollController.jumpTo(scrollOffset.clamp(
            scrollController.position.minScrollExtent,
            scrollController.position.maxScrollExtent,
          ));
        }
      } else {
        state = state.copyWith(
          status: Status.error,
          loadingMoreStatus: Status.error,
        );
      }
    } on DioError catch (e) {
      final errorResponse = DioResponseHandler.handleDioError(e);
      state = state.copyWith(
        status: Status.error,
        loadingMoreStatus: Status.error,
        message: errorResponse["message"],
      );
    } catch (e) {
      state = state.copyWith(
        status: Status.error,
        loadingMoreStatus: Status.error,
        message: "Something went wrong.",
      );
    } finally {
      clearMessage();
    }
  }

  void clearMessage() {
    _clearTimer?.cancel();
    _clearTimer = Timer(const Duration(seconds: 2), () {
      state = state.copyWith(message: "");
    });
  }

  @override
  void dispose() {
    _clearTimer?.cancel();
    super.dispose();
  }

  void resetData() {
    state = state.copyWith(
        status: Status.idle,
        message: "",
        userProfile: [],
        page: 1,
        pageSize: 10,
        loadingMoreStatus: Status.idle);
  }
}
