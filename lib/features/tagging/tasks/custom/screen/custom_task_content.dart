import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:label_pro_client/core/utils/image_utils.dart';
import 'package:label_pro_client/core_ui/submit_button.dart';
import 'package:label_pro_client/domain/models/enums/custom_data_type.dart';
import 'package:label_pro_client/domain/models/enums/custom_input_type.dart';
import 'package:label_pro_client/features/tagging/bloc/tagging_cubit.dart';
import 'package:label_pro_client/features/tagging/tasks/custom/bloc/custom_task_cubit.dart';
import 'package:label_pro_client/features/tagging/tasks/custom/bloc/custom_task_state.dart';
import 'package:label_pro_client/features/tagging/tasks/custom/widget/audio_player_container.dart';
import 'package:label_pro_client/features/tagging/tasks/custom/widget/many_label_selector.dart';

import '../widget/one_label_selector.dart';

class CustomTaskContent extends StatefulWidget {
  final CustomTaskState state;

  const CustomTaskContent({
    required this.state,
    super.key,
  });

  @override
  State<CustomTaskContent> createState() => _CustomTaskContentState();
}

class _CustomTaskContentState extends State<CustomTaskContent> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController()
      ..addListener(
        () {
          context.read<CustomTaskCubit>().updateSelectedData([_textEditingController.text]);
        },
      );
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CustomTaskCubit>();
    final taggingCubit = context.read<TaggingCubit>();

    return BlocListener<CustomTaskCubit, CustomTaskState>(
      listener: (context, state) {
        _textEditingController.clear();
      },
      listenWhen: (previous, current) {
        return previous.data != current.data;
      },
      child: widget.state.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 12,
                            offset: Offset(2, 1),
                            color: Colors.black.withValues(alpha: 0.1),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      switch (widget.state.inputType) {
                                        CustomInputType.oneFromMany =>
                                          Text('Выберите подходящую характеристику'),
                                        CustomInputType.manyFromMany =>
                                          Text('Выберите подходящие характеристики'),
                                        CustomInputType.text => SizedBox(),
                                      },
                                      if (widget.state.inputType != CustomInputType.text)
                                        SizedBox(height: 24),
                                      switch (widget.state.dataType) {
                                        CustomDataType.sound => AudioPlayerContainer(
                                            filePath: widget.state.data,
                                          ),
                                        CustomDataType.image => SizedBox(
                                            height: MediaQuery.sizeOf(context).height * 0.5,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(16),
                                              child: Image.network(
                                                buildFileUrl(
                                                  widget.state.data,
                                                ),
                                                height: MediaQuery.sizeOf(context).height * 0.5,
                                              ),
                                            ),
                                          ),
                                        CustomDataType.string => Text(
                                            widget.state.data,
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                      },
                                    ],
                                  ),
                                ),
                                switch (widget.state.inputType) {
                                  CustomInputType.oneFromMany => OneLabelSelector(
                                      availableLabels: widget.state.availableLabels,
                                      onSelected: (label) {
                                        cubit.updateSelectedData(
                                          [label.name],
                                        );
                                      },
                                    ),
                                  CustomInputType.manyFromMany => ManyLabelsSelector(
                                      availableLabels: widget.state.availableLabels,
                                      onSelectionChanged: (labels) {
                                        cubit
                                            .updateSelectedData(labels.map((e) => e.name).toList());
                                      },
                                    ),
                                  CustomInputType.text => Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12)
                                          .copyWith(top: 12),
                                      child: TextField(
                                        controller: _textEditingController,
                                        decoration: InputDecoration(
                                          filled: true,
                                          hintText: taggingCubit.state.dataset?.helperText ?? '',
                                          fillColor: Colors.white,
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(16),
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(16),
                                            borderSide: BorderSide(
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                        maxLines: 5,
                                        onSubmitted: (value) {
                                          cubit.submitTask();
                                        },
                                      ),
                                    ),
                                }
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            child: SubmitButton(
                              onPressed: () {
                                cubit.submitTask();
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
