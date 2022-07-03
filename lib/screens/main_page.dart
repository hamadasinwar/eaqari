import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/cubit/cubit.dart';
import 'package:graduation_project/cubit/states.dart';
import 'home_page.dart';
import 'notification_page.dart';
import 'offers_page.dart';
import 'profile_page.dart';
import 'package:lottie/lottie.dart';
import 'map_page.dart';
import 'real_states_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final List<Widget> _pages = [
    HomePage(),
    NotificationPage(),
    RealStatePage(),
    OffersPage(),
    ProfilePage(),
    MapPage(),
  ];

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<MyCubit, MyStates>(
      listener: (context, state){},
      builder: (context, state){
        return SafeArea(
          child: Scaffold(
            body: CustomScrollView(
              physics: !(MyCubit.get(context).isHome) ?const NeverScrollableScrollPhysics():null,
              slivers: [
                _pages[MyCubit.get(context).selectedIndex] == _pages.first ? buildAppBar(context) : const SliverToBoxAdapter(),
                _pages[MyCubit.get(context).selectedIndex] == _pages.first ? MyCubit.get(context).home : _pages[MyCubit.get(context).selectedIndex]
              ],
            ),
            floatingActionButton: Visibility(
              visible: [0, 2].contains(MyCubit.get(context).selectedIndex),
              child: MyCubit.get(context).selectedIndex ==0? FloatingActionButton(
                onPressed: ()async {
                  if (MyCubit.get(context).isHome) {
                    MyCubit.get(context).changeHomePage(MapPage());
                  } else {
                    MyCubit.get(context).changeHomePage(HomePage());
                  }
                },
                child: Icon(
                  !MyCubit.get(context).isHome ? Icons.view_list : Icons.location_on_outlined,
                  color: Colors.white,
                ),
              ):FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.pushNamed(context, "add");
                },
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
            bottomNavigationBar: buildBottomBar(context),
          ),
        );
      },
    );
  }

  Widget buildBottomBar(BuildContext ctx) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'الرئيسة',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined),
              label: 'الإشعارات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.real_estate_agent_outlined),
              label: 'عقاراتي',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books_outlined),
              label: 'عروضي',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              label: 'بروفايل',
            ),
          ],
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.grey,
          currentIndex: MyCubit.get(ctx).selectedIndex,
          selectedItemColor: Theme.of(ctx).primaryColor,
          onTap: (int index) {
            MyCubit.get(ctx).changeSelectedPage(index);
          },
        ),
      ),
    );
  }

  Widget buildAppBar(BuildContext ctx) {
    var size = MediaQuery.of(ctx).size;
    return SliverAppBar(
      pinned: true,
      snap: false,
      floating: true,
      expandedHeight: (MyCubit.get(ctx).isHome)?160.0:80.0,
      collapsedHeight: 80.0,
      flexibleSpace: FlexibleSpaceBar(
        expandedTitleScale: 1,
        centerTitle: true,
        background: Opacity(
          opacity: (MyCubit.get(ctx).isHome)?0.15:0.0,
          child: Transform.rotate(
            angle: pi / 2,
            child: Transform.scale(
              scale: 2.4,
              child: LottieBuilder.asset("assets/anim/appbar.json"),
            ),
          ),
        ),
        title: SizedBox(
          height: 45,
          width: size.width-32,
          child: TextFormField(
            readOnly: true,
            onTap: (){
              Navigator.of(context).pushNamed("search");
            },
            decoration: InputDecoration(
              hintText: "بحث...",
              fillColor: Colors.white,
              filled: true,
              prefixIcon: const Icon(Icons.search),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(ctx).primaryColor,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(-9408400), width: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
