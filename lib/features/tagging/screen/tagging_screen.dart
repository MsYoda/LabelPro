import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:label_pro_client/features/tagging/bloc/tagging_cubit.dart';
import 'package:label_pro_client/features/tagging/screen/tagging_content.dart';

import '../bloc/tagging_state.dart';

@RoutePage()
class TaggingScreen extends StatelessWidget {
  const TaggingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaggingCubit(),
      child: BlocBuilder<TaggingCubit, TaggingState>(
        builder: (context, state) {
          return TaggingContent(state: state);
        },
      ),
    );
  }
}
