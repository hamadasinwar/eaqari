import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/services/auth_service.dart';
import 'package:graduation_project/widgets/realstate_item.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class RealStatePage extends StatelessWidget {
  const RealStatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<MyCubit, MyStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        MyCubit cubit = MyCubit.get(ctx);
        var data = cubit.realStates.where((e) => e.userId == AuthService.getCurrentUserID()).toList();
        return SliverToBoxAdapter(
          child: SizedBox(
            height: size.height-80,
            child: Column(
              children: [
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: Text("عقاراتي", style: Theme.of(context).textTheme.bodyLarge),
                ),
                const Divider(height: 0),
                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    padding: const EdgeInsets.only(bottom: 15),
                    itemBuilder: (context, index) {
                      return RealStateItem(realState: data[index]);
                    },
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
