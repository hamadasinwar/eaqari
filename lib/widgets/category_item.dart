import 'package:flutter/material.dart';
import 'package:graduation_project/models/category.dart';

class CategoryItem extends StatelessWidget {
  final bool selected;
  final Category category;
  final VoidCallback? onPressed;

  const CategoryItem({Key? key, required this.selected, required this.category, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.resolveWith((states) => const Size(70, 50)),
          backgroundColor: MaterialStateProperty.resolveWith((states) => !selected
              ? Colors.white
              : Theme.of(context).primaryColor),
          shape: MaterialStateProperty.resolveWith(
                (states) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          category.name??'',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: selected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
    /*return Container(
      width: 70,
      height: 50,
      decoration: BoxDecoration(
        color: !selected
            ? Colors.white
            : Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0x4D000000), width: 0.5)
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold
              , color: selected?Colors.white:Colors.black),
        ),
      ),
    );*/
  }
}
