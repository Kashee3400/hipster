import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api_services/dio_api_service.dart';
import '../../../api_services/dio_response_handler.dart';
import '../../../app_constants.dart';
import '../../../utils/base_status.dart';
import '../../../utils/shared_pref.dart';
import '../models/user_profile_model.dart';

part 'dashboard_state.dart';
part 'dashboard_notifier.dart';


final dashboardNotifierProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>(
        (ref) => DashboardNotifier());
