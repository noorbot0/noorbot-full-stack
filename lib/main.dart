import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:noorbot_app/firebase_options.dart';
import 'package:noorbot_app/src/features/core/screens/chat/chat_provider.dart';
import 'package:noorbot_app/src/repository/authentication_repository/authentication_repository.dart';
import 'package:noorbot_app/src/utils/app_bindings.dart';
import 'package:noorbot_app/src/utils/theme/theme.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  /// Show Splash Screen till data loads & when loaded call FlutterNativeSplash.remove();
  /// In this case I'm removing it inside AuthenticationRepository() -> onReady() method.
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  /// Authentication Repository so that It can check which screen to show.
  await Firebase.initializeApp(
          //name: "noorbot_app",
          options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(AuthenticationRepository()));
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // FirebaseDatabase database = FirebaseDatabase.instance;
  // storeDataDemo(database);
  runApp(App(prefs: prefs));
}

class App extends StatelessWidget {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  App({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ChatProvider>(
          create: (_) => ChatProvider(
            prefs: prefs,
            firebaseFirestore: firebaseFirestore,
            firebaseStorage: firebaseStorage,
          ),
        ),
      ],
      child: GetMaterialApp(
        initialBinding: AppBinding(),
        themeMode: ThemeMode.system,
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.leftToRightWithFade,
        transitionDuration: const Duration(milliseconds: 500),
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
    );
  }
}
