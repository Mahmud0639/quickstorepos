import 'package:get/get.dart';
import 'package:quick_store_pos/modules/home/home_controller.dart';

class HomeBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut<HomeController>(()=>HomeController());
  }
}