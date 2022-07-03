import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/services/auth_service.dart';
import 'package:graduation_project/utils/constants/constants.dart';
import 'package:graduation_project/widgets/profile_item.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<MyCubit, MyStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        MyCubit cubit = MyCubit.get(ctx);
        return SliverToBoxAdapter(
          child: SizedBox(
            height: size.height - 60,
            child: ListView(
              children: [
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: Text("الملف الشخصي", style: Theme.of(context).textTheme.bodyLarge),
                ),
                const Divider(height: 0),
                const SizedBox(height: 30),
                Container(
                  width: size.width,
                  height: 120,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x29000000),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.network(
                            cubit.currentUser.image??'',
                            fit: BoxFit.cover,
                            errorBuilder: (c, h, l)=> Image.network(Constants.personPlaceHolder, fit: BoxFit.cover,),
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return SizedBox(
                                height: 80,
                                width: 80,
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
                      ),
                      const SizedBox(width: 12),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${cubit.currentUser.name}",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "${cubit.currentUser.phone}",
                            style:
                            Theme.of(context).textTheme.labelSmall?.copyWith(color: const Color(0x66000000)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                ProfileItem(
                  title: "المعلومات الشخصية",
                  icon: Icons.person_outlined,
                  onTap: (){
                    Navigator.pushNamed(context, "edit");
                  },
                ),
                ProfileItem(
                  title: "عقاراتي المفضلة",
                  icon: Icons.favorite_border_rounded,
                  onTap: (){
                    Navigator.pushNamed(context, "favorite");
                  },
                ),
                ProfileItem(
                  title: "الدعم الفني والمعلومات القانونية",
                  icon: Icons.settings_outlined,
                  onTap: (){
                    Navigator.pushNamed(context, "settings");
                  },
                ),
                const Divider(height: 0),
                const SizedBox(height: 30),
                TextButton(
                  onPressed: () {
                    showLogoutAlertDialog(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.logout_rounded,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "تسجيل الخروج",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.red),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  showLogoutAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("إلغاء"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("تسجيل الخروج", style: TextStyle(color: Colors.red)),
      onPressed:  () {
        Navigator.pushReplacementNamed(context, "splash");
        AuthService.logout();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("تسجيل الخروج"),
      content: Text("هل أنت متأكد أنك تريد تسجيل الخروج؟", style: Theme.of(context).textTheme.bodySmall),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
