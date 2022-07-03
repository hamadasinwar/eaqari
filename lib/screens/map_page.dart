import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../widgets/custom_marker.dart';

class MapPage extends StatelessWidget {
  MapPage({Key? key}) : super(key: key);

  late GoogleMapController mapController;
  final CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();
  Set<Marker> _markers = {};
  final LatLng _latLng = const LatLng(31.412516170323315, 34.354923395413955);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    _customInfoWindowController.googleMapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<MyCubit, MyStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        MyCubit cubit = MyCubit.get(ctx);
        _markers = cubit.realStates.map((r) => CustomMarker.marker(context, r, _customInfoWindowController)).toSet();
        print(_markers.length);
        return SliverToBoxAdapter(
          child: SizedBox(
            height: size.height - 160,
            width: size.width,
            child: Stack(
              children: [
                GoogleMap(
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: true,
                  mapToolbarEnabled: false,
                  zoomGesturesEnabled: true,
                  onTap: (position) {
                    _customInfoWindowController.hideInfoWindow!();
                  },
                  onCameraMove: (position) {
                    _customInfoWindowController.onCameraMove!();
                  },
                  onMapCreated: _onMapCreated,
                  markers: _markers,
                  initialCameraPosition: CameraPosition(
                    target: _latLng,
                    zoom: 10.5,
                  ),
                ),
                CustomInfoWindow(
                  controller: _customInfoWindowController,
                  height: 95,
                  width: 280,
                  offset: 35,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
