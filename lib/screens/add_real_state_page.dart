import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graduation_project/models/address.dart';
import 'package:graduation_project/models/category.dart';
import 'package:graduation_project/models/real_state.dart';
import 'package:graduation_project/screens/my_dropdown.dart';
import 'package:graduation_project/services/auth_service.dart';
import 'package:graduation_project/services/firebase_storage.dart';
import 'package:graduation_project/services/firestore_service.dart';
import 'package:graduation_project/services/location_service.dart';
import 'package:graduation_project/utils/constants/constants.dart';
import 'package:graduation_project/widgets/my_radio_group.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart' as anim;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../widgets/my_text_field.dart';

class AddRealState extends StatelessWidget {
  AddRealState({Key? key}) : super(key: key);

  final PageController _controller = PageController();
  final List<Widget> pages = [
    FirstPage(),
    SecondPage(),
    ThirdPage(),
    ForthPage(),
    const FifthPage(),
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<MyCubit, MyStates>(
      listener: (context, state) {},
      builder: (context, state) {
        MyCubit cubit = MyCubit.get(context);
        return SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                SizedBox(
                  height: size.height,
                  child: PageView(
                    controller: _controller,
                    children: pages,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (int index) {
                      print(index);

                      cubit.changeAddRealStatePage(pages[index]);
                    },
                  ),
                ),
                Positioned(
                  bottom: 85,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SmoothPageIndicator(
                      controller: _controller,
                      count: pages.length,
                      effect: ExpandingDotsEffect(
                        dotColor: Colors.grey,
                        expansionFactor: 2,
                        dotWidth: 10,
                        dotHeight: 10,
                        spacing: 5,
                        activeDotColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.resolveWith(
                            (states) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                          fixedSize: MaterialStateProperty.resolveWith((states) => Size(size.width, 50))),
                      onPressed: () async {
                        switch(_controller.page?.toInt()){
                          case 0:{
                            if(cubit.realState.images?.isNotEmpty??false){
                              _nextPage();
                            }else{
                              showSnackBar(context, "الرجاء اختيار صورة واحدة على الاقل");
                            }
                            break;
                          }
                          case 1:{
                            if(cubit.realState.name?.isEmpty??false || cubit.realState.name == null){
                              showSnackBar(context, "الرجاء إدخال عنوان للعقار");
                            }else if(cubit.realState.category?.isEmpty??false || cubit.realState.category == null){
                              showSnackBar(context, "الرجاء اختيار التصنيف");
                            }else if(cubit.realState.price == null){
                              showSnackBar(context, "الرجاء اختيار السعر");
                            }else if(cubit.realState.address?.state == null){
                              showSnackBar(context, "الرجاء إدخال موقع");
                            }else{
                              _nextPage();
                            }
                            break;
                          }
                          case 2:{
                            if(cubit.realState.details == null || cubit.realState.details == null){
                              showSnackBar(context, "الرجاء إدخال تفاصيل");
                            }else if(cubit.realState.area == null){
                              showSnackBar(context, "الرجاء إدخال مساحة العقار");
                            }else{
                              _nextPage();
                            }
                            break;
                          }
                          case 3:{
                            if(cubit.realState.location == null){
                              showSnackBar(context, "الرجاء تحديد موقع العقار");
                            }else{
                              Constants.showLoaderDialog(context);
                              cubit.realState.userId = AuthService.getCurrentUserID();
                              var result = await FirestoreServices.addRealState(cubit.realState);
                              Navigator.pop(context);
                              if(result){
                                cubit.realStates.add(cubit.realState);
                                _nextPage();
                              }else{
                                showSnackBar(context, "حدث خطأ ما الرجاء المحاولة مرة اخرى");
                              }
                            }
                            break;
                          }
                          case 4:{
                            Navigator.pushReplacementNamed(context, "main");
                            cubit.realState = RealState();
                            _controller.jumpToPage(0);
                            break;
                          }
                        }
                        /*if (_controller.page == pages.length - 1) {
                          Navigator.pushReplacementNamed(context, "main");
                          _controller.jumpToPage(0);
                        } else if (_controller.page == pages.length-2){
                          Constants.showLoaderDialog(context);
                          cubit.realState.userId = AuthService.getCurrentUserID();
                          var result = await FirestoreServices.addRealState(cubit.realState);
                          if(result){
                            cubit.realState = RealState();
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.fastLinearToSlowEaseIn,
                            );
                          }
                          Navigator.pop(context);
                        } else {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.fastLinearToSlowEaseIn,
                          );
                        }*/
                      },
                      child: const Text("التالي"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  void _nextPage(){
    _controller.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }
  void showSnackBar(BuildContext context, String error){
    SnackBar snackBar = SnackBar(
      content: Text(error, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red)),
      duration: const Duration(seconds: 5),
    );
    Constants.snackBarKey.currentState?.showSnackBar(snackBar);
  }
}

class FirstPage extends StatelessWidget {
  FirstPage({Key? key}) : super(key: key);

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<MyCubit, MyStates>(
      listener: (context, state) {},
      builder: (context, state) {
        MyCubit cubit = MyCubit.get(context);
        return Column(
          children: [
            const Divider(height: 0),
            Container(
              height: 50,
              alignment: Alignment.center,
              child: Text("إضافة عقار جديد", style: Theme.of(context).textTheme.bodyLarge),
            ),
            const Divider(height: 0),
            const SizedBox(height: 15),
            SizedBox(
              width: size.width - 30,
              child: Text("تعليمات:", style: Theme.of(context).textTheme.bodyMedium),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: size.width - 30,
              child:
                  Text("- ألتقاط صور واضحة بدون فلاتر للصور.", style: Theme.of(context).textTheme.bodyLarge),
            ),
            SizedBox(
              width: size.width - 30,
              child: Text("- تصوير الشقة السكنية من كافة الزوايا وعدم تكرار الصورة للمكان الواحد.",
                  style: Theme.of(context).textTheme.bodyLarge),
            ),
            Visibility(
              visible: cubit.images.isNotEmpty,
              child: Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: 5,
                  ),
                  itemCount: cubit.images.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Image.file(File(cubit.images[index].path), fit: BoxFit.cover);
                  },
                ),
              ),
            ),
            Visibility(
              visible: cubit.images.isEmpty,
              child: Expanded(
                child: IconButton(
                  iconSize: 125,
                  splashRadius: 60,
                  onPressed: () {
                    cubit.images = [];
                    pickImages(context);
                  },
                  icon: Image.asset("assets/icons/add.png"),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void pickImages(BuildContext ctx) async {
    List<XFile>? selectedImages = await _picker.pickMultiImage();
    Constants.showLoaderDialog(ctx);
    if (selectedImages?.isNotEmpty ?? false) {
      var images = await StorageService.uploadFiles(selectedImages??[]);
      MyCubit.get(ctx).selectImages(selectedImages ?? []);
      MyCubit.get(ctx).realState.images = images;
      Navigator.pop(ctx);
    }
  }
}

class SecondPage extends StatelessWidget {
  SecondPage({Key? key}) : super(key: key);

  final TextEditingController titleController = TextEditingController();

  Address address = Address();

  final type = const [
    "نوع العقار",
    "بيع",
    "إيجار",
  ];
  final city = const [
    "المدينة",
    "بني سهيلا",
    "بيت حانون",
    "بيت لاهيا",
    "دير البلح",
    "غزة",
    "جباليا",
    "خان يونس",
    "رفح",
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<MyCubit, MyStates>(
      listener: (context, state) {},
      builder: (context, state) {
        List<Category> categories = [Category(id: "0", name: "التصنيف")];
        MyCubit cubit = MyCubit.get(context);
        categories.addAll(cubit.categories);
        return SingleChildScrollView(
          child: Column(
            children: [
              const Divider(height: 0),
              Container(
                height: 50,
                alignment: Alignment.center,
                child: Text("تفاصيل العقار", style: Theme.of(context).textTheme.bodyLarge),
              ),
              const Divider(height: 0),
              const SizedBox(height: 15),
              SizedBox(
                width: size.width - 36,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("أدخل تفاصيل العقار لإتمام عملية الإضافة:",
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 20),
                    MyTextField(
                      hint: "عنوان العقار",
                      controller: TextEditingController(),
                      onChanged: (String value) {
                        cubit.realState.name = value;
                      },
                    ),
                    const SizedBox(height: 15),
                    MyDropDown(
                      list: categories.map((c) => c.name ?? '').toList(),
                      onChanged: (String value) {
                        var category = categories.where((c) => c.name == value).toList()[0];
                        cubit.realState.category = category.id;
                      },
                    ),
                    const SizedBox(height: 15),
                    MyTextField(
                      hint: "المبلغ شهرياً NIS",
                      controller: TextEditingController(),
                      onChanged: (String value) {
                        cubit.realState.price = int.tryParse(value);
                      },
                    ),
                    const SizedBox(height: 15),
                    MyDropDown(
                      list: type,
                      onChanged: (String value) {
                        cubit.realState.type = value;
                      },
                    ),
                    const SizedBox(height: 15),
                    MyDropDown(
                      list: city,
                      onChanged: (String value) {
                        address.state = value;
                        cubit.realState.address = address;
                      },
                    ),
                    const SizedBox(height: 15),
                    MyTextField(
                      hint: "الحي او الشارع",
                      controller: TextEditingController(),
                      onChanged: (String value) {
                        address.street = value;
                        cubit.realState.address = address;
                      },
                    ),
                    const SizedBox(height: 15),
                    MyTextField(
                      hint: "المنطقة",
                      controller: TextEditingController(),
                      onChanged: (String value) {
                        address.place = value;
                        cubit.realState.address = address;
                      },
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ThirdPage extends StatelessWidget {
  ThirdPage({Key? key}) : super(key: key);

  int roomsNum = 0;
  int livingRoomsNum = 0;
  int bathroomsNum = 0;
  var floorController = TextEditingController();
  var apartmentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<MyCubit, MyStates>(
      listener: (context, state) {},
      builder: (context, state) {
        MyCubit cubit = MyCubit.get(context);
        return SingleChildScrollView(
          child: Column(
            children: [
              const Divider(height: 0),
              Container(
                height: 50,
                alignment: Alignment.center,
                child: Text("تفاصيل العقار", style: Theme.of(context).textTheme.bodyLarge),
              ),
              const Divider(height: 0),
              Container(
                width: size.width,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    Text("عدد الغرف", style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 13),
                    MyRadioGroup(
                      onSelected: (value) {
                        cubit.realState.bedroomsNum = value;
                      },
                      items: const ['0', '1', '2', '3', '4', '5+'],
                    ),
                    const SizedBox(height: 15),
                    Text("عدد غرف المعيشة", style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 13),
                    MyRadioGroup(
                      onSelected: (value) {
                        cubit.realState.livingRoomsNum = value;
                      },
                      items: const ['0', '1', '2', '3', '4', '5+'],
                    ),
                    const SizedBox(height: 15),
                    Text("عدد دورات المياه", style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 13),
                    MyRadioGroup(
                      onSelected: (value) {
                        cubit.realState.bathroomsNum = value;
                      },
                      items: const ['0', '1', '2', '3', '4', '5+'],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: MyTextField(
                            hint: "رقم الطابق",
                            mini: true,
                            controller: floorController,
                            onChanged: (String value) {
                              cubit.realState.address?.floorNum = value;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: MyTextField(
                            hint: "رقم الشقة",
                            mini: true,
                            controller: apartmentController,
                            onChanged: (String value) {
                              cubit.realState.address?.apartmentNum = value;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    MyTextField(
                      hint: "تفاصيل وملاحظات عن العقار",
                      controller: TextEditingController(),
                      maxLines: 15,
                      onChanged: (String value) {
                        cubit.realState.details = value;
                      },
                    ),
                    const SizedBox(height: 15),
                    MyTextField(
                      hint: "مساحة العقار م²",
                      controller: TextEditingController(),
                      onChanged: (String value) {
                        cubit.realState.area = int.tryParse(value);
                      },
                    ),
                    const SizedBox(height: 15),
                    CheckboxListTile(
                      value: cubit.realState.hasKitchen??false,
                      onChanged: (value) => cubit.setHasKitchen(value),
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: Theme.of(context).primaryColor,
                      title: Text(
                        "التأكيد على وجود مطبخ",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    CheckboxListTile(
                      value: cubit.useCurrentLocation,
                      onChanged: (value) async{
                        cubit.setUseCurrentLocation(value??false);
                        if(cubit.useCurrentLocation){
                          var position = await LocationService.determinePosition();
                          LatLng location = LatLng(position.latitude, position.longitude);
                          cubit.realState.location = location;
                          var now = DateTime.now().millisecond.toString();
                          cubit.addMarker(Marker(markerId: MarkerId(now), position: location));
                        }
                      },
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: Theme.of(context).primaryColor,
                      title: Text(
                        "استخدام موقعك الحالي",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ForthPage extends StatelessWidget {
  ForthPage({Key? key}) : super(key: key);

  late GoogleMapController mapController;
  final LatLng _latLng = const LatLng(31.412516170323315, 34.354923395413955);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<MyCubit, MyStates>(
      listener: (context, state) {},
      builder: (context, state) {
        MyCubit cubit = MyCubit.get(context);
        return SizedBox(
            height: size.height,
            width: size.width,
            child: GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                target: _latLng,
                zoom: 10.5,
              ),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              compassEnabled: true,
              tiltGesturesEnabled: false,
              onTap: (latLng) {
                var now = DateTime.now().millisecond.toString();
                cubit.addMarker(Marker(markerId: MarkerId(now), position: latLng));
                cubit.realState.location = latLng;
                mapController.animateCamera(CameraUpdate.newLatLngZoom(latLng, 15.0));
              },
              markers: cubit.addRealStateMarkers,
            ),
        );
      },
    );
  }
}

class FifthPage extends StatefulWidget {
  const FifthPage({Key? key}) : super(key: key);

  @override
  State<FifthPage> createState() => _FifthPageState();
}

class _FifthPageState extends State<FifthPage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 1));

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 400), () => _controller.forward());
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("تم إدراج عقارك بنجاح", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 20)),
        const SizedBox(height: 10),
        anim.LottieBuilder.asset(
          "assets/anim/success.json",
          controller: _controller,
          repeat: false,
          height: 300,
          fit: BoxFit.cover,
        )
      ],
    );
  }
}
