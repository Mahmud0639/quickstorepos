import 'package:get/get.dart';
import 'package:quick_store_pos/modules/report/controller.dart';

class ReportBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<ReportController>(()=>ReportController());
  }
}