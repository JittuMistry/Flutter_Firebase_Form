import 'package:get/instance_manager.dart';
import 'package:form/controller/cards_controller.dart';

class CardsBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<CardsController>(CardsController());
  }
}
