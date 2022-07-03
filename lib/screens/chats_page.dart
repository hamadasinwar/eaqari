import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../models/message.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../utils/constants/constants.dart';
import '../widgets/my_text_field.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final receiver = ModalRoute.of(context)!.settings.arguments as MyUser;
    return Builder(
      builder: (context) {
        MyCubit.get(context).getMessages(receiver.id ?? '');
        return BlocConsumer<MyCubit, MyStates>(
          listener: (ctx, state) {},
          builder: (ctx, state) {
            MyCubit cubit = MyCubit.get(ctx);
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                toolbarHeight: 70,
                title: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        receiver.image ?? '',
                        fit: BoxFit.cover,
                        height: 45,
                        width: 45,
                        errorBuilder: (c, h, l) => Image.network(
                          Constants.personPlaceHolder,
                          height: 45,
                          width: 45,
                          fit: BoxFit.cover,
                        ),
                        loadingBuilder:
                            (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return SizedBox(
                            height: 45,
                            width: 45,
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
                    const SizedBox(width: 15),
                    Text(receiver.name ?? '',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.black)),
                  ],
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black.withOpacity(0.9)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                centerTitle: true,
                backgroundColor: Colors.white,
                elevation: 0.0,
              ),
              body: Column(
                children: [
                  const SizedBox(height: 20),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.separated(
                        itemCount: cubit.messages.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          var message = cubit.messages[index];
                          if (AuthService.getCurrentUserID() == message.senderId) {
                            return buildMyMessage(message.text ?? "", context);
                          } else {
                            return buildMessage(message.text ?? "");
                          }
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: MyTextField(
                      hint: "الرسالة...",
                      controller: controller,
                      leading: IconButton(
                        icon: Transform.rotate(
                          angle: math.pi,
                          child: const Icon(Icons.send),
                        ),
                        onPressed: () {
                          cubit.sendMessage(
                            MessageModel(
                              text: controller.text,
                              dateTime: Timestamp.fromDate(DateTime.now()),
                              receiverId: receiver.id,
                              senderId: AuthService.getCurrentUserID(),
                            ),
                          );
                          controller.clear();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMessage(String msg) => Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
      child: Text(msg),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: const BorderRadiusDirectional.only(
            topStart: Radius.circular(15.0),
            topEnd: Radius.circular(15.0),
            bottomStart: Radius.circular(15.0),
          ),
      ),
    ),
  );

  Widget buildMyMessage(String msg, BuildContext ctx) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: Container(
      child: Text(msg, style: const TextStyle(color: Colors.white)),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
          color: Theme.of(ctx).primaryColor,
          borderRadius: const BorderRadiusDirectional.only(
            topStart: Radius.circular(15.0),
            topEnd: Radius.circular(15.0),
            bottomEnd: Radius.circular(15.0),
          ),
      ),
    ),
  );
}
