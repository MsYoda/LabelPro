import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:label_pro_client/domain/models/label.dart';
import 'package:label_pro_client/features/tagging/tasks/word_marker/bloc/word_marker_task_cubit.dart';

import '../../../../../core_ui/submit_button.dart';
import '../bloc/word_marker_task_state.dart';

class WordMarkerTaskContent extends StatelessWidget {
  final WordMarkerTaskState state;

  const WordMarkerTaskContent({
    super.key,
    required this.state,
  });

  void _showMenu({
    required BuildContext context,
    required Offset position,
    required int wordIndex,
  }) {
    final cubit = context.read<WordMarkerTaskCubit>();
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(position);
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        localPosition.dx,
        localPosition.dy,
        localPosition.dx + 1,
        localPosition.dy + 1,
      ),
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
              Text('Удалить')
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
    final cubit = context.read<WordMarkerTaskCubit>();
    return Material(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32),
            Expanded(
              child: state.isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : state.isDatasetEmpty
                      ? Center(
                          child: Text(
                            'Все элементы датасета размечены, вы можете выбрать другой в настройках',
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.07),
                                blurRadius: 12,
                              )
                            ],
                          ),
                          child: ListView(
                            children: [
                              Text(
                                'Нажмите на слово и выберите метку',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 24),
                              Text(
                                'Легенда',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              for (var i = 0;
                                  i < state.availableLabels.length;
                                  i++)
                                LabelRow(
                                  color: state
                                      .colors[state.availableLabels[i].id]!,
                                  label: state.availableLabels[i],
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 22),
                                ),
                              SizedBox(height: 24),
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
                                                position:
                                                    details.globalPosition,
                                                wordIndex: i,
                                              );
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: state.colors[state
                                                            .markedWords[i]?.id]
                                                        ?.withValues(
                                                            alpha: 0.3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  child: Text(
                                                    state.words[i].data,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
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
            ),
            SizedBox(height: 24),
            Center(
              child: SizedBox(
                width: 150,
                child: SubmitButton(
                  onPressed: () {
                    cubit.submitTask();
                  },
                ),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class LabelRow extends StatelessWidget {
  final Label label;
  final Color color;
  final TextStyle? style;

  const LabelRow({
    super.key,
    required this.label,
    required this.color,
    this.style,
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
          style: style ??
              TextStyle(
                color: Colors.black,
              ),
        ),
      ],
    );
  }
}
