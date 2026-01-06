import 'package:get/get.dart';
import 'package:quick_store_pos/modules/inventory/index.dart';

class InventoryBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<InventoryController>(()=>InventoryController(), fenix: true);
  }
}