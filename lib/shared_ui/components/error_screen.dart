import 'package:flutter/material.dart';
import 'package:pruzi_korak/app/theme/colors.dart';

import '../../core/localization/app_localizations.dart';


class ErrorComponent extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const ErrorComponent(
      {super.key, required this.errorMessage, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            color: AppColors.error,
            size: 80.0,
          ),
          SizedBox(height: 20),
          Text(
            errorMessage,
            style: TextStyle(fontSize: 18, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(AppLocalizations.of(context)!.retry),
          ),
        ],
      )),
    );
  }
}
