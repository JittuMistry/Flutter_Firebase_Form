import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:form/utils/binding_utils.dart';
import 'package:form/utils/keyboard_utils.dart';
import 'package:form/utils/routes_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => KeyBoardUtil().closeKeyboard(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: false, fontFamily: 'PoppinsRegular'),
        initialRoute: Routes.allCardsScreen,
        initialBinding: CardsBinding(),
        getPages: getPages,
      ),
    );
  }
}
