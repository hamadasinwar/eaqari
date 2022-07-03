import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/models/real_state.dart';
import 'package:graduation_project/services/firestore_service.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class RealStateItem extends StatefulWidget {
  final RealState realState;

  const RealStateItem({Key? key, required this.realState}) : super(key: key);

  @override
  _RealStateItemState createState() => _RealStateItemState();
}

class _RealStateItemState extends State<RealStateItem> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<MyCubit, MyStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        return Container(
          height: size.height/3.8,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                      child: Image.network(
                        widget.realState.images?[Random().nextInt(widget.realState.images?.length??0)]??"",
                        height: 120,
                        width: size.width,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return SizedBox(
                            height: 120,
                            width: size.width,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("${widget.realState.name}", style: Theme.of(context).textTheme.titleSmall),
                                Text(widget.realState.address.toString(), style: Theme.of(context).textTheme.labelSmall),
                                Row(
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        style: Theme.of(context).textTheme.labelSmall,
                                        children: [
                                          TextSpan(
                                              text: "${widget.realState.price}₪", style: Theme.of(context).textTheme.displayMedium),
                                          const TextSpan(text: "/"),
                                          const TextSpan(text: "شهر"),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Image.asset("assets/icons/area.png", width: 15, height: 15),
                                    const SizedBox(width: 5),
                                    Text(
                                      "${widget.realState.area}م",
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
                                  "${widget.realState.type}",
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
                    )
                  ],
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                    splashColor: Theme.of(context).primaryColor.withOpacity(0.2),
                    highlightColor: Colors.white.withOpacity(0.05),
                    onTap: () {
                      Navigator.pushNamed(context, "details", arguments: widget.realState);
                    },
                  ),
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: IconButton(
                  onPressed: () async {
                    if (widget.realState.isFavorite) {
                      await FirestoreServices.removeFavorite(widget.realState);
                      _controller.reset();
                    } else {
                      await FirestoreServices.addFavorite(widget.realState);
                      _controller.forward();
                    }
                    widget.realState.isFavorite = !widget.realState.isFavorite;
                    setState(() {

                    });
                  },
                  icon: Icon(
                    widget.realState.isFavorite?Icons.bookmark_rounded:Icons.bookmark_border_rounded,
                    color: widget.realState.isFavorite?Theme.of(context).primaryColor:Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
