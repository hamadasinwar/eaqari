import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/services/firestore_service.dart';
import 'package:graduation_project/widgets/my_offers.dart';
import 'package:graduation_project/widgets/offer_widget.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../models/offer.dart';

class OffersPage extends StatelessWidget {
  const OffersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<MyCubit, MyStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        MyCubit cubit = MyCubit.get(ctx);
        var realStates = cubit.hasOffers;

        return SliverToBoxAdapter(
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: Text("عروضي", style: Theme.of(context).textTheme.bodyLarge),
                ),
                const Divider(height: 0),
                SizedBox(
                  height: 50,
                  child: TabBar(
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Theme.of(context).primaryColor,
                    tabs: const [
                      SizedBox(
                        height: 50,
                        child: Center(child: Text("عروضي للعقارات")),
                      ),
                      SizedBox(
                        height: 50,
                        child: Center(child: Text("العروض للعقاراتي")),
                      ),
                    ],
                    onTap: (int index){
                      cubit.changeOfferIndex(index);
                    },
                  ),
                ),
                cubit.offersIndex == 1 ? SizedBox(
                  height: size.height - 170,
                  child: ListView.builder(
                    itemCount: realStates.length,
                    padding: const EdgeInsets.only(bottom: 50),
                    itemBuilder: (context, index) {
                      return OfferWidget(
                        realState: realStates[index],
                        checkOffers: (dontHaveOffers){
                          if(dontHaveOffers){
                            cubit.dontHaveOffer(index);
                          }
                        },
                      );
                    },
                  ),
                ):SizedBox(
                  height: size.height - 170,
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirestoreServices.getMyOffersToRealStates(),
                    builder: (context, snapshot) {
                      List<Offer> data = [];
                      if(snapshot.hasData){
                        data = snapshot.data!.docs.map((e) => Offer(document: e).fromFirebase()).toList();
                      }
                      return ListView.builder(
                        itemCount: data.length,
                        padding: const EdgeInsets.only(bottom: 50),
                        itemBuilder: (context, index) {
                          var real = cubit.realStates.firstWhere((element) => element.id == data[index].realState);
                          return MyOffer(
                            realState: real,
                            offer: data[index],
                          );
                        },
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
