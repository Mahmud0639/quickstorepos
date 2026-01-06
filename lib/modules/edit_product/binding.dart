import 'package:get/get.dart';
import 'package:quick_store_pos/modules/edit_product/controller.dart';

class EditProductBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<EditProductController>(()=>EditProductController());
  }
}