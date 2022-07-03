import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyCubit, MyStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        MyCubit cubit = MyCubit.get(ctx);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "الرسائل",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w100),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black.withOpacity(0.9)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0.0,
          ),
          backgroundColor: Colors.white,
          body: ConditionalBuilder(
              condition: true,
              fallback: (_) => const Center(child: CircularProgressIndicator()),
              builder: (context) {
                return ListView.separated(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    var message = cubit.recentMessages[index];
                    print(message.toMap());
                    return ListTile(
                      title: Text(
                        "الاسم",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      subtitle: Text(
                        "الرسالة",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: const Color(0xFFA0A0A0),
                            ),
                      ),
                      minVerticalPadding: 0,
                      trailing: Text(
                        "06:07م",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: const Color(0xFFA0A0A0),
                              fontSize: 10,
                            ),
                      ),
                      leading: SizedBox(
                        height: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            "https://lh3.googleusercontent.com/fife/AAWUweVwyaXn3yAJbknE02s-bWZibn8-iHc3hcT0fm6xA2yZ6rtxr5UtGO5kojty-3D-l5FqGlIedkIllN-aJPopyevwQ1WS3jvxbTa20w897RNeAVXxcoeWU9jbjBhQ-wY2F9Ja3mxxU4lobSv_enkIG-Vw5zVAea4mEN_Nv4filMWXysUAaOBC7yGIakMkqQfQRRNFbDS97OcLar7MNL5VMvOEQ89_eqnIK8xIzkcIBlwg1hlUy7s2kustnFo6oNhnJJhEUkz06aPnXJvbvayJU08StuGZUewazlB6V7h4jW0iT5ejzdZPLJ5CMPor25SKzeq_01pxR2HNeGITest2Hb11CdWQ05rB8h-PRn5d7dE17s9CnCh6yLqR3mSBxeD88Z69R1GvSf69Xed403rQgT9T-yUGjisLOGjzznXcGtcFR3UiEMFncllpV392QgvDKUFc5WaSXCaIeCrb7fSyn6jScS3eAoormta5iLudvoap0LbXCOz2O8D3SUlBthQGNvPoOmpFEsLXLDcOMYYJzjMZDSAPkofEhk4CaH06LmA3tp-5WKyI2VWtnYhxKUnDJVOOgIjF21OQtUz9B6AT2ecfKTIKq1h3VA9kKIZC_Z0V3fj5QaFdf0xTinnKU1auAUhFeyWShV1EocLZ9Ymz4lraxP_kkhcebiyRn8G7F3KXNiq4YXdC2JZzC8q_FwcVD7UxyqZaTcGG_iwG_pCUTpEQpzANFxoRvXD1NXb8h3zjvtaGGanSA8q5xmT_2ZU1kQagVD6XEkDOQoGuYXMK9RN0mNEq3gHCHjoVCZVxmRw=w1842-h992",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, "chat");
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(height: 0);
                  },
                );
              }),
        );
      },
    );
  }
}
