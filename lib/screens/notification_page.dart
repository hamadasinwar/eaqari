import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/models/notification.dart';
import 'package:graduation_project/services/firestore_service.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../utils/constants/constants.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SliverToBoxAdapter(
      child: BlocConsumer<MyCubit, MyStates>(
        listener: (ctx, state) {},
        builder: (ctx, state) {
          MyCubit cubit = MyCubit.get(ctx);
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirestoreServices.notifications(),
              builder: (context, snapshot) {
                if(!(snapshot.hasData)){
                  return const Center(child: CircularProgressIndicator());
                }
                var notifications = snapshot.data!.docs.map((e) => MyNotification(document: e).fromFirebase()).toList();
                return Column(
                  children: [
                    Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: Text("الإشعارات", style: Theme.of(context).textTheme.bodyLarge),
                    ),
                    const Divider(height: 0),
                    SizedBox(
                      height: size.height - 135,
                      child: ListView.separated(
                        itemCount: notifications.length,
                        itemBuilder: (BuildContext context, int index) {
                          var t = TimeOfDay.fromDateTime(DateTime.now().subtract(Duration(milliseconds: notifications[index].time?.millisecondsSinceEpoch??0))).format(context);
                          return ListTile(
                            title: Text(notifications[index].title??"", style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 16)),
                            subtitle: Text(notifications[index].content??"", style: Theme.of(context).textTheme.labelSmall),
                            trailing: Text(t, style: Theme.of(context).textTheme.labelSmall),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                notifications[index].icon??'',
                                height: 40,
                                width: 40,
                                fit: BoxFit.cover,
                                errorBuilder: (c, h, l) => Image.network(
                                  Constants.personPlaceHolder,
                                  fit: BoxFit.cover,
                                  height: 40,
                                  width: 40,
                                ),
                                loadingBuilder: (BuildContext context, Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return SizedBox(
                                    height: 40,
                                    width: 40,
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
                            onTap: ()async {
                              if(notifications[index].title?.contains("عرض جديد")??false){
                                cubit.changeSelectedPage(3);
                              }else{
                                var user = await FirestoreServices.getUser(notifications[index].action??'');
                                Navigator.pushReplacementNamed(context, "chat", arguments: user);
                              }
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(height: 0);
                        },
                      ),
                    ),
                  ],
                );
              }
          );
        },
      ),
    );
  }
}
