import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/screens/add_real_state_page.dart';
import 'package:graduation_project/screens/chats_page.dart';
import 'package:graduation_project/screens/image_preview.dart';
import 'package:graduation_project/screens/search_page.dart';
import 'package:graduation_project/services/notification_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '/screens/details_page.dart';
import '/screens/edit_profile.dart';
import '/screens/favorite_page.dart';
import '/screens/messages_page.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';
import 'utils/constants/bloc_observer.dart';
import 'utils/constants/constants.dart';
import '/screens/login_page.dart';
import '/screens/main_page.dart';
import '/screens/signup_page.dart';
import '/screens/splash_page.dart';
import '/screens/onboarding_page.dart';
import 'screens/settings_page.dart';
import 'screens/support_page.dart';

void main() async {
  BlocOverrides.runZoned(() {},
    blocObserver: MyBlocObserver(),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.initPlatformState();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => MyCubit(),
      child: BlocConsumer<MyCubit, MyStates>(
        listener: (context, state) {},
        builder: (context, state) {
          MyCubit cubit = MyCubit.get(context);
          OneSignal.shared.setNotificationOpenedHandler((result) {
            var data = result.notification.additionalData?['notification_id'].toString();
            if(data == Constants.offerId) {
              cubit.changeSelectedPage(3);
            }else if(data == Constants.messageId) {
              navigatorKey.currentState?.pushNamed("chat");
            }
          });
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            scaffoldMessengerKey: Constants.snackBarKey,
            navigatorKey: navigatorKey,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ar', ''),
            ],
            locale: const Locale('ar', ''),
            theme: ThemeData(
              primaryColor: const Color(0xFF00B4FF),
              accentColor: const Color(0xFF00C944),
              canvasColor: const Color(0xfff7f7f7),
              textTheme: GoogleFonts.tajawalTextTheme(
                const TextTheme(
                  bodyMedium: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  bodyLarge: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                  bodySmall: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                  titleSmall: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  displayMedium: TextStyle(
                    color: Color(0xFF00C944),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  displayLarge: TextStyle(
                    color: Color(0xFF00C944),
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                  labelSmall: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                  labelMedium: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  labelLarge: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  headlineSmall: TextStyle(
                    color: Colors.black87,
                    fontSize: 28,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            initialRoute: 'splash',
            routes: {
              'onboarding': (context) => const OnBoardingPage(),
              'login': (context) => LoginPage(),
              'signup': (context) => SignUpPage(),
              'splash': (context) => const SplashPage(),
              'main': (context) => MainPage(),
              'map': (context) => MainPage(),
              'add': (context) => AddRealState(),
              'details': (context) => const DetailsPage(),
              'messages': (context) => const MessagesPage(),
              'chat': (context) => ChatsPage(),
              'edit': (context) => EditProfile(),
              'favorite': (context) => const FavoritePage(),
              'settings': (context) => const SettingsPage(),
              'support': (context) => const SupportPage(),
              'search': (context) => const SearchPage(),
              'preview': (context) => const ImagePreview(),
            },
          );
        },
      ),
    );
  }
}
