import 'package:flutter/material.dart';

class RealStateDetails extends StatelessWidget {
  const RealStateDetails({Key? key, this.title, this.count}) : super(key: key);
  final String? title;
  final dynamic count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("$title $count", style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.black))
      ],
    );
  }
}
