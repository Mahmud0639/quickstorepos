import 'package:get/get.dart';
import 'package:quick_store_pos/modules/add_product/add_product_controller.dart';

class AddProductBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<AddProductController>(()=>AddProductController());
  }
}