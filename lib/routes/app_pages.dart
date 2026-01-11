import 'package:get/get.dart';
import 'package:quick_store_pos/modules/add_product/index.dart';
import 'package:quick_store_pos/modules/billing/index.dart';
import 'package:quick_store_pos/modules/edit_product/index.dart';
import 'package:quick_store_pos/modules/home/index.dart';
import 'package:quick_store_pos/modules/inventory/index.dart';
import 'package:quick_store_pos/modules/inventory/pages/page.dart';
import 'package:quick_store_pos/modules/report/binding.dart';
import 'package:quick_store_pos/modules/report/view.dart';
import 'package:quick_store_pos/modules/sales/index.dart';
import 'package:quick_store_pos/modules/sales/sales_history/index.dart';
import 'package:quick_store_pos/navigation/bottom_nav/binding.dart';
import 'package:quick_store_pos/navigation/bottom_nav/view.dart';
import 'package:quick_store_pos/routes/app_routes.dart';

class AppPages{
  static const INITIAL = AppRoutes.MAIN_NAV;

  static List<GetPage> routes = [
    GetPage(name: AppRoutes.MAIN_NAV, page: ()=> const MainNavigationView(),binding: MainNavigationBinding()),
    GetPage(name: AppRoutes.REPORT, page: ()=>const ReportView(),binding: ReportBinding()),
    GetPage(name: AppRoutes.HOME, page: ()=> const HomeView(),binding: HomeBinding()),
    GetPage(name: AppRoutes.ADD_PRODUCT, page: ()=> const AddProductView(),binding: AddProductBinding()),
    GetPage(name: AppRoutes.BILLING, page: ()=> const BillingView(),binding: BillingBinding()),
    GetPage(name: AppRoutes.INVENTORY, page: ()=> const InventoryView(),binding: InventoryBinding(),
    transition: Transition.rightToLeftWithFade,transitionDuration: Duration(milliseconds: 500)),
    GetPage(name: AppRoutes.INVENTORY_PAGE, page: ()=> const InventoryPage(),
        binding: InventoryBinding(),transition: Transition.cupertino,
        transitionDuration: Duration(milliseconds: 1000)),
    GetPage(name: AppRoutes.INVENTORY_EDIT, page: ()=>EditProductView(),binding: EditProductBinding(),
    transition: Transition.cupertino,transitionDuration: Duration(milliseconds: 200)),
    GetPage(name: AppRoutes.SALES_PAGE, page: ()=> SalesView(),binding: SalesBinding(),transition: Transition.circularReveal,
        transitionDuration: Duration(milliseconds: 200)),
    GetPage(name: AppRoutes.SALES_HISTORY, page: ()=>SalesHistoryView(),binding: SalesHistoryBinding(),transition: Transition.fadeIn,transitionDuration: Duration(milliseconds: 200))

  ];
}