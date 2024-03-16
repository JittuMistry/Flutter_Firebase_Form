import 'package:get/get.dart';
import 'package:form/screens/all_card_screen.dart';
import 'package:form/utils/binding_utils.dart';

class Routes {
  static const String allCardsScreen = '/allCardsScreen';
}

final getPages = [
  GetPage(
    name: Routes.allCardsScreen,
    page: () => const AllCardsScreen(),
    binding: CardsBinding(),
    transition: Transition.fade,
  ),
];
