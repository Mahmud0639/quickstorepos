import 'package:get/get.dart';
import 'package:quick_store_pos/modules/sales/controller.dart';

class SalesBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<SalesController>(()=>SalesController());
  }
}