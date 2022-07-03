import 'package:flutter/material.dart';
import 'package:graduation_project/models/offer.dart';

import '../models/real_state.dart';

class MyOffer extends StatelessWidget {
  const MyOffer({Key? key, required this.realState, required this.offer, }) : super(key: key);

  final RealState realState;
  final Offer offer;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var color = Theme.of(context).primaryColor;
    if(offer.state == "مقبول"){
      color = Theme.of(context).accentColor;
    }else if(offer.state == "تم الرفض"){
      color = Colors.red;
    }
    return Container(
      height: size.height/5.0,
      width: size.width,
      margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF707070), width: 0.5),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x29000000),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        realState.images?[0] ?? "",
                        width: 120,
                        height: size.height/5.0-33,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            realState.name??"",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            realState.address.toString(),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      "${realState.price ?? 000}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(color: Theme.of(context).accentColor,
                                      ),
                                    ),
                                    Text("/شهريا", style: Theme.of(context).textTheme.labelSmall),
                                  ],
                                ),
                              ),
                              Image.asset("assets/icons/area.png", width: 12, height: 12),
                              const SizedBox(width: 5),
                              Text(
                                "${realState.area}م",
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              height: 30,
              width: 110,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10)),
              ),
              child: Center(
                child: Text(
                  offer.state??"",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
