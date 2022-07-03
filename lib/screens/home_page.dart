import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/models/real_state.dart';
import 'package:graduation_project/services/auth_service.dart';
import 'package:graduation_project/services/firestore_service.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../widgets/category_item.dart';
import '../widgets/realstate_item.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  List<RealState> data = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyCubit, MyStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        MyCubit cubit = MyCubit.get(ctx);
        data = [];
        for (var real in cubit.realStates) {
          if (real.category == cubit.categories[cubit.selectedCategoryIndex].id) {
            data.add(real);
          }
        }
        checkUser(cubit);
        return SliverToBoxAdapter(
          child: Column(
            children: [
              SizedBox(
                  height: 70.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: cubit.categories.length,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemBuilder: (context, index) {
                      return CategoryItem(
                        category: cubit.categories[index],
                        selected: cubit.selectedCategoryIndex == index,
                        onPressed: () {
                          cubit.changeSelectedCategory(index);
                        },
                      );
                    },
                  )),
              ListView.builder(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return RealStateItem(
                    realState: data[index],
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }

  void checkUser(MyCubit cubit) async {
    if (cubit.currentUser.id == null) {
      var user = await FirestoreServices.getUser(AuthService.getCurrentUserID() ?? '');
      cubit.currentUser = user;
    }
  }
}
