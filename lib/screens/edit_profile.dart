import 'package:flutter/material.dart';
import 'package:graduation_project/services/firestore_service.dart';
import 'package:graduation_project/utils/constants/constants.dart';
import 'package:graduation_project/widgets/my_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../services/firebase_storage.dart';

class EditProfile extends StatelessWidget {
  EditProfile({Key? key}) : super(key: key);

  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<MyCubit, MyStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        MyCubit cubit = MyCubit.get(ctx);
        if(_nameController.text.isEmpty){
          _nameController.text = cubit.currentUser.name ?? '';
        }
        if(_phoneController.text.isEmpty){
          _phoneController.text = cubit.currentUser.phone ?? '';
        }
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
                            "المعلومات الشخصية",
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
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  GestureDetector(
                    onTap: () => showModalBottomSheet(
                      context: ctx,
                      builder: (BuildContext ctx) {
                        return SizedBox(
                          height: size.height/5,
                          child: Column(
                            children: [
                              ListTile(
                                title: const Text("الكاميرا"),
                                leading: const Icon(Icons.image_rounded),
                                onTap: (){
                                  pickImages(context, ImageSource.camera, cubit);
                                },
                              ),
                              ListTile(
                                title: const Text("الاستوديو"),
                                leading: const Icon(Icons.camera_alt_rounded),
                                onTap: (){
                                  pickImages(context, ImageSource.gallery, cubit);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              cubit.currentUser.image ?? '',
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
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 30,
                            height: 30,
                            child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 18),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xffff2d55),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  MyTextField(hint: "الاسم", controller: _nameController),
                  const SizedBox(height: 20),
                  MyTextField(hint: "رقم الموبايل", controller: _phoneController, enabled: false),
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.only(bottom: size.height / 20, left: 16, right: 16),
              child: ElevatedButton(
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.resolveWith((states) => Size(size.width - 32, 50)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                child: const Text("حفظ التغييرات"),
                onPressed: () async {
                  cubit.currentUser.name = _nameController.text;
                  cubit.currentUser.phone = _phoneController.text;
                  await FirestoreServices.updateUser(cubit.currentUser);
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void pickImages(BuildContext ctx, ImageSource source, MyCubit cubit) async {
    XFile? selectedImage = await ImagePicker().pickImage(source: source,  maxHeight: 480, maxWidth: 640);
    Navigator.pop(ctx);
    Constants.showLoaderDialog(ctx);
    if (selectedImage != null) {
      var image = await StorageService.uploadFile(selectedImage);
      cubit.updateUserImage(image);
      Navigator.pop(ctx);
    }
  }
}
