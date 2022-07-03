import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graduation_project/models/offer.dart';
import 'package:graduation_project/services/firestore_service.dart';
import '../cubit/states.dart';
import '../models/address.dart';
import '../models/category.dart';
import '../models/message.dart';
import '../models/real_state.dart';
import '../models/user.dart';
import 'package:image_picker/image_picker.dart';
import '../screens/add_real_state_page.dart';
import '../screens/home_page.dart';

class MyCubit extends Cubit<MyStates>{
  MyCubit() : super(MyInitState());

  static MyCubit get(BuildContext context) => BlocProvider.of(context);

  MyUser currentUser = MyUser();
  //main page
  int selectedIndex = 0;
  int selectedCategoryIndex = 0;
  Widget home = HomePage();
  bool isHome = true;
  List<Category> categories = [];
  List<RealState> realStates = [];
  List<RealState> favorites = [];
  List<RealState> hasOffers = [];
  List<RealState> searchRealStates = [];

  //add real state
  List<XFile> images = [];
  Widget addRealStateCurrentPage = FirstPage();
  RealState realState = RealState();
  Address realStateAddress = Address();
  bool useCurrentLocation = false;
  Set<Marker> addRealStateMarkers = <Marker>{};
  //map
  List<Marker> markers = [];
  //chat
  List<MessageModel> messages = [];
  List<MessageModel> recentMessages = [];

  //offers
  int offersIndex = 0;
  List<Offer> offersToMe = [];
  List<Offer> offersFromMe = [];
  Map<String , int> offersNumber = {};

  void setTitle(String title){
    realState.name = title;
  }

  void updateUserImage(String image){
    currentUser.image = image;
    emit(MyChangeState());
  }

  void changeAddRealStatePage(Widget page){
    addRealStateCurrentPage = page;
    emit(MyChangeState());
  }

  void selectImages(List<XFile> img){
    images.addAll(img);
    emit(MyChangeState());
  }

  void setSearch(List<RealState> filtered){
    searchRealStates = filtered;
    emit(MyChangeState());
  }

  void changeHomePage(Widget page){
    home = page;
    isHome = !isHome;
    emit(MyChangeState());
  }

  void changeSelectedPage(int index){
    selectedIndex = index;
    emit(MyChangeState());
  }

  void changeSelectedCategory(int index){
    selectedCategoryIndex = index;
    emit(MyChangeState());
  }

  void changeOfferIndex(int index){
    offersIndex = index;
    emit(MyChangeState());
  }

  void loadCategories(List<Category> list){
    categories = list;
  }

  void loadRealStates(List<RealState> list){
    realStates = list;
  }

  void loadOffersToMe(List<Offer> list){
    offersToMe = list;
  }

  void loadOffersFromMe(List<Offer> list){
    offersFromMe = list;
  }

  void setHasKitchen(bool? value){
    realState.hasKitchen = value;
    emit(MyChangeState());
  }

  void updateRealStates(RealState r){
    realStates.add(r);
    emit(MyChangeState());
  }

  void addMarker(Marker marker){
    addRealStateMarkers = {marker};
    emit(MyChangeState());
  }

  void dontHaveOffer(int index){
    hasOffers.removeAt(index);
    emit(MyChangeState());
  }


  void setUseCurrentLocation(bool value){
    useCurrentLocation = value;
    emit(MyChangeState());
  }

  void sendMessage(MessageModel message)async{
    var result = await FirestoreServices.sendMessage(message);
    if(result){
      emit(SendMessageSuccessState());
    }else{
      emit(SendMessageErrorState());
    }
  }

  void getMessages(String receiver){
    FirestoreServices.getMessages(receiver)
        .listen((event) {
          messages = event.docs.map((e) => MessageModel.fromMap(e.data())).toList();

          emit(GetMessageSuccessState());

    });
  }

}