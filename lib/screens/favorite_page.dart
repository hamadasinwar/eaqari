import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/services/firestore_service.dart';
import 'package:graduation_project/widgets/realstate_item.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<MyCubit, MyStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        MyCubit cubit = MyCubit.get(ctx);
        var favorites = cubit.realStates.where((e) => e.isFavorite).toList();
        return SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size(size.width, 50),
              child: Column(
                children: [
                  const Divider(height: 0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const IconButton(
                        onPressed: null,
                        icon: SizedBox(),
                      ),
                      SizedBox(
                        height: 50,
                        child: Center(
                          child: Text(
                            "المفضلة",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_forward_ios_rounded),
                      ),
                    ],
                  ),
                  const Divider(height: 0),
                ],
              ),
            ),
            body: ListView.builder(
              itemCount: favorites.length,
              padding: const EdgeInsets.only(bottom: 30),
              itemBuilder: (context, index) {
                return Dismissible(
                  key: ValueKey("$index"),
                  onDismissed: (_)async{
                    var result = await FirestoreServices.removeFavorite(favorites[index]);
                    if(result){
                      var real = cubit.realStates.firstWhere((element) => element.id == favorites[index].id);
                      cubit.realStates.remove(real);
                      real.isFavorite = false;
                      cubit.realStates.add(real);
                      favorites.remove(favorites[index]);
                    }
                  },
                  background: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(Icons.delete_outlined, color: Colors.red),
                        Icon(Icons.delete_outlined, color: Colors.red),
                      ],
                    ),
                  ),
                  child: RealStateItem(realState: favorites[index]),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
