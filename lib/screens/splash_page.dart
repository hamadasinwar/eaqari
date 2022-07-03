import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/services/auth_service.dart';
import 'package:graduation_project/services/firestore_service.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../models/real_state.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyCubit, MyStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        MyCubit cubit = MyCubit.get(ctx);
        return Scaffold(
          body: Center(
            child: Lottie.asset(
              'assets/anim/splash.json',
              onLoaded: (p0) {
                loadData(cubit, context);
              },
            ),
          ),
        );
      },
    );
  }

  void loadData(MyCubit cubit, BuildContext ctx) async {
    var c = await FirestoreServices.allCategories;
    cubit.loadCategories(c);

    var r = await FirestoreServices.allRealStates;
    cubit.loadRealStates(r);

    List<RealState> myRealStates = [];
    for (var e in r) {
      if(e.userId == AuthService.getCurrentUserID()){
        myRealStates.add(e);
      }
    }
    cubit.hasOffers = myRealStates;

    var userid = AuthService.getCurrentUserID();
    if(userid != null){
      cubit.currentUser = await FirestoreServices.getUser(userid);
    }

    getRoute(ctx, userid, cubit);
  }

  void getRoute(BuildContext ctx, String? id, MyCubit cubit)async{
    final prefs = await SharedPreferences.getInstance();
    final bool? notFirst = prefs.getBool('notFirst');
    if(notFirst??false){
      if(id != null){
        Navigator.pushReplacementNamed(ctx, "main");
      }else{
        Navigator.pushReplacementNamed(ctx, "login");
      }
    }else{
      await prefs.setBool('notFirst', true);
      Navigator.pushReplacementNamed(ctx, "onboarding");
    }
  }
}
