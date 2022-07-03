import 'package:flutter/material.dart';

class ProfileItem extends StatelessWidget {
  const ProfileItem({Key? key, required this.title, required this.icon, required this.onTap}) : super(key: key);

  final String title;
  final IconData icon;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 0),
        SizedBox(
          child: ListTile(
            title: Text(title,style: Theme.of(context).textTheme.labelLarge),
            leading: Icon(icon, color: Theme.of(context).accentColor),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            tileColor: Colors.white,
            visualDensity: const VisualDensity(vertical: 2), // to expand
            onTap: (){
              onTap();
            },
          ),
        ),
      ],
    );
  }
}
