import 'package:label_pro_client/domain/models/enums/custom_data_type.dart';
import 'package:label_pro_client/domain/models/enums/custom_input_type.dart';
import 'package:label_pro_client/domain/models/label.dart';

class CustomTaskState {
  final bool isLoading;
  final bool isDatasetOver;
  final String data;
  final String idInFile;
  final String filename;
  final List<Label> availableLabels;
  final CustomInputType inputType;
  final CustomDataType dataType;
  final List<String> input;

  const CustomTaskState({
    required this.isLoading,
    required this.isDatasetOver,
    required this.data,
    required this.idInFile,
    required this.filename,
    required this.availableLabels,
    required this.inputType,
    required this.dataType,
    required this.input,
  });

  CustomTaskState.initial({
    this.isLoading = false,
    this.isDatasetOver = false,
    this.data = '',
    this.idInFile = '',
    this.filename = '',
    this.availableLabels = const [],
    this.inputType = CustomInputType.oneFromMany,
    this.dataType = CustomDataType.string,
    this.input = const [],
  });

  CustomTaskState copyWith({
    bool? isLoading,
    bool? isDatasetOver,
    String? data,
    String? idInFile,
    String? filename,
    List<Label>? availableLabels,
    CustomInputType? inputType,
    CustomDataType? dataType,
    List<String>? input,
  }) {
    return CustomTaskState(
      isLoading: isLoading ?? this.isLoading,
      isDatasetOver: isDatasetOver ?? this.isDatasetOver,
      data: data ?? this.data,
      idInFile: idInFile ?? this.idInFile,
      filename: filename ?? this.filename,
      availableLabels: availableLabels ?? this.availableLabels,
      inputType: inputType ?? this.inputType,
      dataType: dataType ?? this.dataType,
      input: input ?? this.input,
    );
  }
}
