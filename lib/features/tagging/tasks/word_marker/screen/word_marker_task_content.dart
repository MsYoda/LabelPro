import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:label_pro_client/domain/models/label.dart';
import 'package:label_pro_client/features/tagging/tasks/word_marker/bloc/word_marker_task_cubit.dart';

import '../bloc/word_marker_task_state.dart';

class WordMarkerTaskContent extends StatelessWidget {
  final WordMarkerTaskState state;

  const WordMarkerTaskContent({
    super.key,
    required this.state,
  });

  void foo(String text) {
    print(text);
  }

  void _showMenu({
    required BuildContext context,
    required Offset position,
    required int wordIndex,
  }) {
    final cubit = context.read<WordMarkerTaskCubit>();
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(position.dx, position.dy, position.dx + 1, position.dy + 1),
      items: [
        PopupMenuItem(
          child: Text(
            state.words[wordIndex].data,
            style: TextStyle(fontSize: 17),
          ),
        ),
        PopupMenuItem(
          onTap: () {
            cubit.clearMark(
              wordIndex: wordIndex,
            );
          },
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8),
              Text('None')
            ],
          ),
        ),
        for (var i = 0; i < state.availableLabels.length; i++)
          PopupMenuItem(
            onTap: () {
              cubit.updateMark(
                wordIndex: wordIndex,
                label: state.availableLabels[i],
              );
            },
            child: LabelRow(
              label: state.availableLabels[i],
              color: state.colors[state.availableLabels[i].id]!,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print(state.markedWords);
    return Material(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black),
                children: [
                  for (var i = 0; i < state.words.length; i++)
                    WidgetSpan(
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTapDown: (details) {
                            _showMenu(
                              context: context,
                              position: details.globalPosition,
                              wordIndex: i,
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: state.colors[state.markedWords[i]?.id]
                                      ?.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  state.words[i].data,
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Text(' '),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LabelRow extends StatelessWidget {
  final Label label;
  final Color color;

  const LabelRow({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Text(
          label.name,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
