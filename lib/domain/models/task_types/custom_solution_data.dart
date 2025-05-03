import 'package:label_pro_client/domain/models/enums/custom_input_type.dart';

class CustomSolutionData {
  final CustomInputType type;
  final List<String> result;

  const CustomSolutionData({
    required this.type,
    required this.result,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.toJson(),
      'result': result,
    };
  }
}
