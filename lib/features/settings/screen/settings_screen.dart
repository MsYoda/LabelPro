import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:label_pro_client/core/core.dart';
import 'package:label_pro_client/features/settings/bloc/settings_cubit.dart';
import 'package:label_pro_client/features/settings/screen/settings_content.dart';

import '../bloc/settings_state.dart';

@RoutePage()
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsCubit>(
      create: (_) => SettingsCubit(
        settingsRepository: appLocator(),
        datasetRepository: appLocator(),
      ),
      child: BlocBuilder<SettingsCubit, SettingsState>(builder: (context, state) {
        return SettingsContent(
          state: state,
        );
      }),
    );
  }
}
