import 'package:flutter/material.dart';
import 'my_radio.dart';

class MyRadioGroup<T> extends StatefulWidget {
  const MyRadioGroup({Key? key, required this.items, required this.onSelected}) : super(key: key);
  final List<String> items;
  final ValueChanged<int> onSelected;

  @override
  State<MyRadioGroup> createState() => _MyRadioGroupState();
}

class _MyRadioGroupState extends State<MyRadioGroup> {

  int value = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.items
          .map(
            (item) => MyRadioListTile<int>(
              value: widget.items.indexOf(item),
              groupValue: value,
              leading: item,
              onChanged: (v){
                int current = v??-1;
                widget.onSelected(current);
                setState(() => value = current);
              },
            ),
          )
          .toList(),
    );
  }
}
