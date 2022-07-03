import 'package:flutter/material.dart';

class BoardingModel extends StatelessWidget {
  final String title;
  final String body;
  final String image;

  const BoardingModel({
    Key? key,
    required this.title,
    required this.body,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var width = MediaQuery.of(context).size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image, width: width,height: width),
        SizedBox(
          width: width/1.5,
          child: Text(title, style: Theme.of(context).textTheme.bodyMedium),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: width/1.5,
          child: Text(
            body,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 3,
          ),
        ),
      ],
    );
  }
}
