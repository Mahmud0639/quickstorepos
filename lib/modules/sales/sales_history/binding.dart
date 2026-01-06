import 'package:get/get.dart';
import 'package:quick_store_pos/modules/sales/sales_history/controller.dart';

class SalesHistoryBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<SalesHistoryController>(()=>SalesHistoryController(),fenix: true);
  }
}