import 'package:flutter/material.dart';
import 'package:hipster/utils/error_message.dart';

import '../../utils/base_status.dart';

class NoInternetPage extends StatelessWidget {
  final VoidCallback onRetry;
  final bool? loading;

  const NoInternetPage({Key? key, required this.onRetry, this.loading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: MessageBox(
        imageAsset: "assets/images/no-internet.png",
        message: "No Internet Connection",
        imageSize: 100,
        icon: Icons.help,
        type: Status.error,
        isLoading: loading ?? false,
        onRetry: onRetry,
      ),
    );
  }
}
