import 'package:flutter/material.dart';

class RealStateAccessories extends StatelessWidget {
  const RealStateAccessories({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "$title",
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: Colors.white,
          ),
        ),
        const SizedBox(width: 5),
        const Icon(
          Icons.check_circle_rounded,
          color: Colors.white,
          size: 15,
        ),
      ],
    );
  }
}
