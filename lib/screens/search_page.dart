import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyCubit, MyStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        MyCubit cubit = MyCubit.get(ctx);
        var realStates = cubit.searchRealStates;
        return Scaffold(
          appBar: AppBar(
            title: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              onChanged: (value){
                filter(value, cubit);
              },
              decoration: const InputDecoration(
                hintText: "بحث",
                hintStyle: TextStyle(color: Colors.white),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 0.5,
                  ),
                ),
              ),
            ),
          ),
          body: ListView.builder(
            itemCount: realStates.length,
            itemBuilder: (context, index) {
              var real = realStates[index];
              return ListTile(
                title: Text(real.name??"", style: Theme.of(context).textTheme.bodyLarge),
                subtitle: Text(real.address.toString(), style: Theme.of(context).textTheme.bodySmall),
                leading: _buildImage(real.images?[0]??""),
                onTap: (){
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "details", arguments: realStates[index]);
                },
              );
            },
          ),
        );
      },
    );
  }

  void filter(String query, MyCubit cubit){
    final filtered = cubit.realStates.where((real){

      var title = real.name??"";
      var type = real.type??"";
      var details = real.details??"";
      var address = real.address.toString();

      return title.contains(query) ||
          type.contains(query) ||
          details.contains(query) ||
          address.contains(query);
    }).toList();

    cubit.setSearch(filtered);
  }

  Widget _buildImage(String img){
    return Image.network(
      img,
      width: 50,
      fit: BoxFit.cover,
      errorBuilder: (a, b, c){
        return Container(
          color: Colors.blue[200],
        );
      },
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return SizedBox(
          width: 50,
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
    );
  }
}
