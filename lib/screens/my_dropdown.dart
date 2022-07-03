import 'package:flutter/material.dart';

class MyDropDown extends StatefulWidget {
  const MyDropDown({Key? key, required this.list, this.onChanged}) : super(key: key);

  final List<String> list;
  final ValueChanged<String>? onChanged;

  @override
  State<MyDropDown> createState() => _MyDropDownState();
}

class _MyDropDownState extends State<MyDropDown> {

  late String _currentSelectedValue;

  @override
  void initState() {
    super.initState();
    _currentSelectedValue = widget.list.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.16),
              blurRadius: 6,
              spreadRadius: 1,
              offset: const Offset(0, 3)
          )
        ],
      ),
      child: FormField<String>(
        builder: (FormFieldState<String> state) {
          return InputDecorator(
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Color(-9408400), width: 0.5),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                icon: const Icon(
                  Icons.arrow_drop_down_rounded,
                  size: 30,
                ),
                value: _currentSelectedValue,
                isDense: true,
                onChanged: (String? newValue) {
                  if(widget.onChanged != null){
                    widget.onChanged!(newValue??'');
                  }
                  setState(() {
                    _currentSelectedValue = newValue ?? '';
                    state.didChange(newValue);
                  });
                },
                items: widget.list.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1,
                      overflow: TextOverflow.visible,
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
