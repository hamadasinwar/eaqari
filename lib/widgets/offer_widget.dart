import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/models/offer.dart';
import 'package:graduation_project/models/real_state.dart';
import 'package:graduation_project/models/user.dart';
import 'package:graduation_project/services/firestore_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../utils/constants/constants.dart';

class OfferWidget extends StatefulWidget {
  const OfferWidget({
    Key? key,
    required this.realState,
    this.checkOffers,
  }) : super(key: key);

  final RealState realState;
  final ValueChanged<bool>? checkOffers;

  @override
  State<OfferWidget> createState() => _OfferWidgetState();
}

class _OfferWidgetState extends State<OfferWidget> {
  List<Offer> offers = [];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirestoreServices.getOffersFormMyRealStates(widget.realState.id),
        builder: (context, snapshot) {
          List data = [];
          if (snapshot.hasData) {
            data = snapshot.data!.docs;
            widget.checkOffers!(data.isEmpty);
            offers = snapshot.data!.docs.map((e) => Offer(document: e).fromFirebase()).toList();
          }
          return Container(
            height: size.height / 3.25,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          widget.realState.images?[0] ?? "",
                          width: 120,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.realState.name ?? "",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Text(
                              widget.realState.address.toString(),
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        "${widget.realState.price ?? 000}",
                                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                              color: Theme.of(context).accentColor,
                                            ),
                                      ),
                                      Text("/شهريا", style: Theme.of(context).textTheme.labelSmall),
                                    ],
                                  ),
                                ),
                                Image.asset("assets/icons/area.png", width: 12, height: 12),
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
                    ],
                  ),
                ),
                Container(
                  color: Theme.of(context).accentColor,
                  height: 35,
                  width: size.width,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(
                    "العروض المقدمة: ${data.length} عرض",
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          fixedSize:
                              MaterialStateProperty.resolveWith((states) => Size(size.width / 2.5, 35))),
                      onPressed: (){
                        showOffers(context, offers);
                      },
                      child: Text(
                        "شاهد العروض",
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  Future showOffers(BuildContext ctx, List<Offer> list)async {
    List<MyUser> users = [];
    for (var offer in list) {
      users.add(await FirestoreServices.getUser(offer.user??""));
    }
    showDialog(
        context: ctx,
        builder: (_) {
          return AlertDialog(
            title: Text(
              "العروض",
              textAlign: TextAlign.center,
              style: Theme.of(ctx).textTheme.labelLarge,
            ),
            content: SizedBox(
              height: MediaQuery.of(ctx).size.height*0.25,
              width: 300.0,
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(users[index].name??"", style: Theme.of(ctx).textTheme.bodyLarge),
                    subtitle: Text(users[index].phone??"", style: Theme.of(ctx).textTheme.labelSmall),
                    trailing: SizedBox(
                      width: 115*2/3,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Theme.of(ctx).accentColor,
                            child: IconButton(
                              icon: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 18,
                              ),
                              onPressed: ()async {
                                if(offers.length == 1){
                                  Navigator.pop(context);
                                }
                                await FirestoreServices.updateOffer(list[index], "مقبول");
                              },
                            ),
                          ),
                          const SizedBox(width: 3),
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.red,
                            child: IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 18,
                              ),
                              onPressed: ()async {
                                if(offers.length == 1){
                                  Navigator.pop(context);
                                }
                                await FirestoreServices.updateOffer(list[index], "تم الرفض");
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    leading: CircleAvatar(
                      radius: 30.0,
                      backgroundImage: NetworkImage("${users[index].image}"),
                      backgroundColor: Colors.transparent,
                    ),
                    onTap: () async {
                      String url = "tel:${users[index].phone}";
                      if (await canLaunchUrlString(url)) {
                        await launchUrlString(url);
                      }
                    },
                  );
                },
              ),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            actionsAlignment: MainAxisAlignment.center,
            titlePadding: const EdgeInsets.only(top: 15),
            contentPadding: const EdgeInsets.only(bottom: 25),
            actionsPadding: const EdgeInsets.only(bottom: 10),
            actions: [
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.resolveWith(
                    (states) => RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  fixedSize: MaterialStateProperty.resolveWith(
                    (states) => const Size(150, 40),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text("موافق"),
              )
            ],
          );
        });
  }
}
