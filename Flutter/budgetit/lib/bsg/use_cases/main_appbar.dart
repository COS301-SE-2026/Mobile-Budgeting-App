import 'package:budgetit/bsg/preview_support.dart';
import 'package:budgetit/shared/widgets/main_appbar.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Main App Bar', type: MainAppbar, path: '[Widgets]')
Widget mainAppbarUseCase(BuildContext context) {
  return appPreview(
    child: Scaffold(
      backgroundColor: context.colours.background,
      appBar: const MainAppbar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Help, themes, profiles and settings: the whole top shelf!',
            style: context.colours.b1,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );
}
