import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/models/message.dart';
import 'package:graduation_project/models/user.dart';
import 'package:graduation_project/services/auth_service.dart';
import 'package:graduation_project/widgets/my_text_field.dart';
import 'dart:math' as math;

import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../utils/constants/constants.dart';

class ChatPage extends StatelessWidget {
  ChatPage({Key? key}) : super(key: key);

  final chatController = TextEditingController();

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
              body: ConditionalBuilder(
                //condition: cubit.messages.isNotEmpty,
                condition: true,
                builder: (BuildContext context) {
                  return Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            itemCount: cubit.messages.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              var message = cubit.messages[index];
                              if (AuthService.getCurrentUserID() == message.senderId) {
                                return buildMyMessage(message.text ?? "");
                              } else {
                                return buildMessage(message.text ?? "");
                              }
                            },
                          ),
                        ),
                        MyTextField(
                          hint: "الرسالة...",
                          controller: chatController,
                          leading: IconButton(
                            icon: Transform.rotate(
                              angle: math.pi,
                              child: const Icon(Icons.send),
                            ),
                            onPressed: () {
                              /*cubit.sendMessage(
                                MessageModel(
                                  text: chatController.text,
                                  dateTime: TimeS,
                                  receiverId: receiver.id,
                                  senderId: AuthService.getCurrentUserID(),
                                ),
                              );
                              chatController.clear();*/
                            },
                          ),
                        )
                      ],
                    ),
                  );
                },
                fallback: (_) => const Center(child: CircularProgressIndicator()),
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
              )),
        ),
      );

  Widget buildMyMessage(String msg) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          child: Text(msg, style: const TextStyle(color: Colors.white)),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: const BoxDecoration(
              color: Color(0xFF433E5C),
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(15.0),
                topEnd: Radius.circular(15.0),
                bottomEnd: Radius.circular(15.0),
              )),
        ),
      );
}
