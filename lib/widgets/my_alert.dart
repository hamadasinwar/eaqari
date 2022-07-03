import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MyAlert extends StatelessWidget {
  const MyAlert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: LottieBuilder.asset("assets/anim/success.json", repeat: false, height: 150, fit: BoxFit.cover,)),
      content: Text("تم إرسال طلب لصاحب العقار", textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelLarge,),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      actionsAlignment: MainAxisAlignment.center,
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.only(bottom: 25),
      actionsPadding: const EdgeInsets.only(bottom: 10),
      actions: [
        ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.resolveWith(
                    (states) => RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            fixedSize: MaterialStateProperty.resolveWith(
              (states) => const Size(150, 48),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("موافق"),
        )
      ],
    );
  }
}
