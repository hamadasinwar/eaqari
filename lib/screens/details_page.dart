import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/models/offer.dart';
import 'package:graduation_project/models/real_state.dart';
import 'package:graduation_project/services/auth_service.dart';
import 'package:graduation_project/services/firestore_service.dart';
import 'package:graduation_project/widgets/my_alert.dart';
import 'package:graduation_project/widgets/real_state_accessories.dart';
import 'package:graduation_project/widgets/real_state_details.dart';
import 'package:graduation_project/widgets/related_real.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:math' as math;
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../utils/constants/constants.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final realState = ModalRoute.of(context)!.settings.arguments as RealState;
    var isDisabled = realState.userId != AuthService.getCurrentUserID();
    return BlocConsumer<MyCubit, MyStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        MyCubit cubit = MyCubit.get(ctx);
        final related = cubit.realStates.where((element) => element.category == realState.category).toList();
        return SafeArea(
          child: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Stack(
                    children: [
                      CarouselSlider(
                        items: realState.images?.map((image) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, "preview", arguments: image);
                            },
                            child: Hero(
                              tag: "preview",
                              child: Image.network(
                                image,
                                width: size.width,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }).toList(),
                        carouselController: CarouselController(),
                        options: CarouselOptions(
                          height: size.height * 0.27 + 32,
                          viewportFraction: 1.0,
                          enlargeCenterPage: false,
                          autoPlay: true,
                          reverse: true,
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.share_rounded, color: Colors.white),
                              onPressed: () {
                                Share.share('${realState.name} https://play.google.com/');
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        top: (size.height * 0.27) - 32,
                        child: Container(
                          width: size.width,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
                            child: Row(
                              children: [
                                Text("${realState.price??000}", style: Theme.of(context).textTheme.displayLarge),
                                Text("₪ ", style: Theme.of(context).textTheme.displayMedium),
                                Text("شهريا", style: Theme.of(context).textTheme.labelSmall),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 30,
                        right: 30,
                        top: (size.height * 0.27) - 55,
                        child: Row(
                          children: [
                            Container(
                              width: 72,
                              height: 30,
                              child: Center(
                                child: Text(
                                  "${realState.type}",
                                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).accentColor, borderRadius: BorderRadius.circular(7)),
                            ),
                            const Spacer(),
                            FloatingActionButton(
                              backgroundColor: Colors.white,
                              mini: true,
                              child: Icon(
                                realState.isFavorite?Icons.bookmark_rounded:Icons.bookmark_border_rounded,
                                color: Theme.of(context).accentColor,
                              ),
                              onPressed: () async{
                                realState.isFavorite = await changeFavorite(cubit, realState);
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    width: size.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                    ),
                    child: Column(
                      children: [
                        const Divider(height: 0),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("عن العقار :", style: Theme.of(context).textTheme.labelLarge),
                              const SizedBox(height: 7),
                              Text(
                                "${realState.details}",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 10),
                              const Divider(height: 0),
                              const SizedBox(height: 10),
                              Text("العنوان :", style: Theme.of(context).textTheme.labelLarge),
                              const SizedBox(height: 7),
                              Text(
                                realState.address.toString(),
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 10),
                              const Divider(height: 0),
                              const SizedBox(height: 10),
                              Text("تفاصيل العقار :", style: Theme.of(context).textTheme.labelLarge),
                              const SizedBox(height: 8),
                              realState.bedroomsNum != null?Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black.withOpacity(0.15), width: 1)),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        RealStateDetails(title: "غرف: 🛏️", count: realState.bedroomsNum),
                                        const Spacer(),
                                        RealStateDetails(title: "المساحة: 🔳", count: realState.area),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        RealStateDetails(title: "غرف المعيشة: 🛋️", count: realState.livingRoomsNum),
                                        const Spacer(),
                                        RealStateDetails(title: "الطابق: 🏢", count: realState.address?.floorNum),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        RealStateDetails(title: "دورات المياه: 🛁", count: realState.bathroomsNum),
                                        const Spacer(),
                                        RealStateDetails(title: "رقم الشقة : 🔢", count: realState.address?.apartmentNum),
                                      ],
                                    ),
                                  ],
                                ),
                              ):Row(
                                children: [
                                  Image.asset("assets/icons/area.png", width: 15, height: 15),
                                  const SizedBox(width: 5),
                                  Text(
                                    "${realState.area}م",
                                    style: Theme.of(context).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                              realState.hasKitchen??false?Container(
                                color: Colors.blue,
                                width: size.width,
                                height: 30,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    realState.hasKitchen??false?const RealStateAccessories(title: "مطبخ"):const SizedBox(),
                                  ],
                                ),
                              ):const SizedBox(),
                              const SizedBox(height: 15),
                              realState.userId != AuthService.getCurrentUserID()?Center(
                                child: SizedBox(
                                  width: size.width/1.6,
                                  child: ElevatedButton(
                                    onPressed: ()async{
                                      var user = await FirestoreServices.getUser(realState.userId??'');
                                      Navigator.pushReplacementNamed(context, "chat", arguments: user);
                                    },
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.resolveWith(
                                            (states) => RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Transform.rotate(
                                          angle: math.pi,
                                          child: const Icon(Icons.send),
                                        ),
                                        const SizedBox(width: 10),
                                        Text("مراسلة صاحب العقار", style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ),
                              ):const SizedBox(),
                              const SizedBox(height: 20),
                              Text("عقارات مشابهة :", style: Theme.of(context).textTheme.labelLarge),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    width: size.width,
                    height: 180,
                    color: Colors.white,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: related.length,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemBuilder: (context, index) {
                        return RelatedReal(realState: related[index]);
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                    child: TextButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.report_outlined, color: Colors.red),
                          Text(
                            "الإبلاغ عن هذا العقار",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            bottomNavigationBar: SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
                child: Text(isDisabled?"أبدا الرهن الان":"هذا العقار خاص بك"),
                onPressed: isDisabled?()async {
                  Timestamp timeStamp = Timestamp.fromDate(DateTime.now());
                        var offer = Offer(
                          realState: realState.id,
                          state: "بإنتظار الموافقة",
                          owner: realState.userId,
                          user: AuthService.getCurrentUserID(),
                          timestamp: timeStamp,
                        );
                        await FirestoreServices.addOffer(offer, realState);
                    showDialog(context: context, builder: (_) {
                      return const MyAlert();
                    });
                }:null,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> changeFavorite(MyCubit cubit, RealState realState)async{
    bool result;
    if(realState.isFavorite){
      await FirestoreServices.removeFavorite(realState);
      result = false;
    }else{
      await FirestoreServices.addFavorite(realState);
      result = true;
    }
    var real = cubit.realStates.firstWhere((element) => element.id == realState.id);
    cubit.realStates.remove(real);
    real.isFavorite = result;
    cubit.updateRealStates(real);
    return result;
  }
}
