import 'package:get/get.dart';

class HomeController extends GetxController{
  bool get isWindows => GetPlatform.isWindows;
  bool get isAndroid => GetPlatform.isAndroid;

  void gotoBilling() => Get.toNamed('/billing');
  void gotoAddProduct() => Get.toNamed('/add-product');
  void gotoReports() => Get.toNamed('/reports');
}