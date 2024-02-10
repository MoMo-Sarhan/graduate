import 'package:flutter/material.dart';

class CustomDropDown extends StatefulWidget {
 const CustomDropDown({
    super.key,
    required this.validator,
    required this.items,
    required this.value,
    required this.leading,
    required this.onChange,
    required this.isEnabled,
  });

final  String? Function(dynamic) validator;
  final List<String> items;
  final String value;
  final String leading;
  final Function(String?)? onChange;
  final bool isEnabled;

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField(
          validator: widget.validator,
          alignment: Alignment.centerLeft,
          isExpanded: widget.isEnabled,
          decoration: InputDecoration(
              enabled: widget.isEnabled,
              label: Text(
                widget.leading,
                style: const TextStyle(fontSize: 19),
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
          borderRadius: BorderRadius.circular(10),
          value: widget.value,
          items: widget.items.map((String item) {
            return DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style:const TextStyle(
                    fontSize: 19,
                    color: Colors.black,
                  ),
                ));
          }).toList(),
          onChanged: widget.isEnabled ? widget.onChange : null),
    );
  }
}
