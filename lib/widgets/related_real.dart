import 'package:flutter/material.dart';
import 'package:graduation_project/models/real_state.dart';

class RelatedReal extends StatelessWidget {
  const RelatedReal({Key? key, required this.realState}) : super(key: key);

  final RealState realState;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width/2 -20,
      height: 160,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.15), offset: const Offset(0, 3), blurRadius: 6)
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                realState.images?[0]??"",
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          RichText(
                            textWidthBasis: TextWidthBasis.longestLine,
                            overflow: TextOverflow.fade,
                            text: TextSpan(
                              style: Theme.of(context).textTheme.labelSmall,
                              children: [
                                TextSpan(
                                    text: "${realState.price}\$",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium),
                                const TextSpan(text: "/"),
                                const TextSpan(text: "شهر"),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          Image.asset("assets/icons/area.png",
                              width: 15, height: 15),
                          const SizedBox(width: 5),
                          Text(
                            "1500م",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                      Text("منزل للإيجار بجانب مفترق ضبيط",
                          style: Theme.of(context).textTheme.labelSmall, maxLines: 1),
                      Text("غزة - الجلاء - مفترق ضبيط",
                          style: Theme.of(context).textTheme.labelSmall, maxLines: 1),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
