import 'package:flutter/material.dart';
import 'package:label_pro_client/domain/models/label.dart';

class OneLabelSelector extends StatefulWidget {
  final List<Label> availableLabels;
  final Function(Label) onSelected;

  const OneLabelSelector({
    required this.availableLabels,
    required this.onSelected,
    super.key,
  });

  @override
  State<OneLabelSelector> createState() => _OneLabelSelectorState();
}

class _OneLabelSelectorState extends State<OneLabelSelector> {
  Label? selectedLabel;

  @override
  void initState() {
    super.initState();
    selectedLabel = widget.availableLabels.firstOrNull;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.availableLabels.map((label) {
        return RadioListTile<Label>(
          title: Text(label.name),
          value: label,
          groupValue: selectedLabel,
          onChanged: (Label? value) {
            if (value != null) {
              setState(() {
                selectedLabel = value;
              });
              widget.onSelected(value);
            }
          },
        );
      }).toList(),
    );
  }
}
