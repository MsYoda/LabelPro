import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:label_pro_client/features/tagging/bloc/tagging_state.dart';

class TaggingContent extends StatelessWidget {
  final TaggingState state;

  const TaggingContent({
    required this.state,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (state.dataset != null) {
      return AutoTabsRouter();
    }
    return Center(
      child: Text('Configure dataset access in settings first'),
    );
  }
}
