import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
                        "الإعدادات",
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
          padding: const EdgeInsets.only(bottom: 30),
          children: [
            ListTile(
              title: Text("الدعم الفني", style: Theme.of(context).textTheme.bodyLarge),
              leading: const Icon(Icons.support, color: Colors.black),
              onTap: (){
                Navigator.pushNamed(context, "support");
              },
            ),
            ListTile(
              title: Text("سياسة الخصوصية", style: Theme.of(context).textTheme.bodyLarge),
              leading: const Icon(Icons.privacy_tip_outlined, color: Colors.black),
              onTap: (){},
            ),
            ListTile(
              title: Text("شروط الإستخدام", style: Theme.of(context).textTheme.bodyLarge),
              leading: const Icon(Icons.security, color: Colors.black),
              onTap: (){},
            ),
            ListTile(
              title: Text("قم بتقييم التطبيق", style: Theme.of(context).textTheme.bodyLarge),
              leading: const Icon(Icons.star_rate, color: Colors.black),
              onTap: (){},
            ),
            ListTile(
              title: Text("قم بمشاركة التطبيق", style: Theme.of(context).textTheme.bodyLarge),
              leading: const Icon(Icons.share, color: Colors.black),
              onTap: (){},
            ),
            ListTile(
              title: Text("من نحن", style: Theme.of(context).textTheme.bodyLarge),
              leading: const Icon(Icons.share, color: Colors.black),
              onTap: (){},
            ),
          ],
        ),
      ),
    );
  }
}
