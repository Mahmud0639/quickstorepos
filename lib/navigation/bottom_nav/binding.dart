import 'package:get/get.dart';
import 'package:quick_store_pos/modules/add_product/add_product_controller.dart';
import 'package:quick_store_pos/modules/add_product/add_product_view.dart';
import 'package:quick_store_pos/modules/home/home_controller.dart';
import 'package:quick_store_pos/modules/inventory/controller.dart';
import 'package:quick_store_pos/modules/report/controller.dart';
import 'package:quick_store_pos/modules/sales/controller.dart';
import 'package:quick_store_pos/modules/sales/sales_history/controller.dart';
import 'package:quick_store_pos/navigation/bottom_nav/controller.dart';

class MainNavigationBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<MainNavigationController>(()=>MainNavigationController(),fenix: true);
    // হোম কন্ট্রোলার এখানে অ্যাড করে দিন
    Get.lazyPut<HomeController>(() => HomeController(),fenix: true);

    // একইভাবে ইনভেন্টরি বা সেলস কন্ট্রোলারও এখানে রাখতে পারেন
    Get.lazyPut<InventoryController>(() => InventoryController(),fenix: true);
    Get.lazyPut<SalesController>(() => SalesController(),fenix: true);
    Get.lazyPut<AddProductController>(()=>AddProductController(),fenix: true);
    Get.lazyPut<SalesHistoryController>(()=>SalesHistoryController(),fenix: true);
    Get.lazyPut<ReportController>(()=>ReportController(),fenix: true);
  }
}