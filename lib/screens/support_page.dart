import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/widgets/my_text_field.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _messageController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<MyCubit, MyStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        MyCubit cubit = MyCubit.get(ctx);
        var user = cubit.currentUser;
        _nameController.text = user.name??"";
        _phoneController.text = user.phone??"";
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
                            "الدعم الفني",
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
            body: ListView(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
              children: [
                MyTextField(hint: "الاسم", controller: _nameController),
                const SizedBox(height: 40),
                MyTextField(hint: "رقم الموبايل", controller: _phoneController),
                const SizedBox(height: 40),
                MyTextField(hint: "الرسالة", controller: _messageController, maxLines: 10),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.resolveWith((states) => Size(size.width - 32, 50)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                  child: const Text("إرسال"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
