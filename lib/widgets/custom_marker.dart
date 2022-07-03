import 'package:clippy_flutter/triangle.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graduation_project/models/real_state.dart';

class CustomMarker {
  static Marker marker(BuildContext context, RealState realState, CustomInfoWindowController _customInfoWindowController){
    return Marker(
      markerId: MarkerId(realState.id??DateTime.now().millisecond.toString()),
      position: realState.location??const LatLng(0.0, 0.0),
      onTap: () {
        _customInfoWindowController.addInfoWindow!(
          Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "details", arguments: realState);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.16),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        )
                      ]
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(realState.name??'', style: Theme.of(context).textTheme.titleSmall),
                            Text(realState.address.toString(), style: Theme.of(context).textTheme.labelSmall),
                            Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: Theme.of(context).textTheme.labelSmall,
                                    children: [
                                      TextSpan(
                                          text: "${realState.price??000}₪", style: Theme.of(context).textTheme.displayMedium),
                                      const TextSpan(text: "/"),
                                      const TextSpan(text: "شهر"),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Image.asset("assets/icons/area.png", width: 15, height: 15),
                                const SizedBox(width: 5),
                                Text(
                                  "${realState.area??''}م",
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          width: 60,
                          height: 30,
                          decoration: const BoxDecoration(
                              color: Color(0xFF00C944),
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(10))),
                          child: Center(
                            child: Text(
                              realState.type??'',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Triangle.isosceles(
                edge: Edge.BOTTOM,
                child: Container(
                  color: Colors.white,
                  width: 20.0,
                  height: 10.0,
                ),
              ),
            ],
          ),
          realState.location??const LatLng(0.0, 0.0),
        );
      },
    );
  }
}
