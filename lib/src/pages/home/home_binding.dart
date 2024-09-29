import 'package:get/get.dart';
import 'package:tractian/src/pages/home/home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
        () => HomeController(companyService: Get.find()));
  }
}
