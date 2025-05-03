import 'package:flutter/material.dart';
import 'package:label_pro_client/domain/models/label.dart';

class ManyLabelsSelector extends StatefulWidget {
  final List<Label> availableLabels;
  final Function(List<Label>) onSelectionChanged;

  const ManyLabelsSelector({
    super.key,
    required this.availableLabels,
    required this.onSelectionChanged,
  });

  @override
  State<ManyLabelsSelector> createState() => _ManyLabelsSelectorState();
}

class _ManyLabelsSelectorState extends State<ManyLabelsSelector> {
  final Set<Label> selectedLabels = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.availableLabels.map((label) {
        return CheckboxListTile(
          title: Text(label.name),
          value: selectedLabels.contains(label),
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (bool? isChecked) {
            setState(() {
              if (isChecked == true) {
                selectedLabels.add(label);
              } else {
                selectedLabels.remove(label);
              }
            });
            widget.onSelectionChanged(selectedLabels.toList());
          },
        );
      }).toList(),
    );
  }
}
