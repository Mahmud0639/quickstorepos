import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_store_pos/modules/home/home_controller.dart';
import 'package:quick_store_pos/routes/app_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quick Store POS Dashboard"),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //billing-scan
            if(controller.isWindows)
              _buildMenuButton(icon: Icons.qr_code_scanner, label: "Scan & Bill(POS)",color: Colors.blue,onTap: ()=> Get.toNamed(AppRoutes.BILLING)),
             SizedBox(height: 20.h,),
            _buildMenuButton(icon: Icons.add_box, label: "Add New Product", color: Colors.green, onTap: ()=>Get.toNamed(AppRoutes.ADD_PRODUCT)),
             SizedBox(height: 20.h,),
            _buildMenuButton(icon: Icons.inventory, label: "Inventory Stock", color: Colors.orange, onTap: ()=>Get.toNamed(AppRoutes.INVENTORY)),
            SizedBox(height: 20.h,),
            _buildMenuButton(icon: Icons.sell, label: "Sell Product", color: Colors.red, onTap: ()=>Get.toNamed(AppRoutes.SALES_PAGE)),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMenuButton(
  {required IconData icon,
  required String label,
  required Color color,
  required VoidCallback onTap,}
      ){
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 300.w,
          padding:  EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12.w),
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.3),blurRadius: 8, offset: const Offset(0, 4))
            ]
          ),
          child: Row(
            children: [
              Icon(icon,color: Colors.white,size: 30.w,),
              SizedBox(width: 20.w,),
              Text(label,style:  TextStyle(color: Colors.white, fontSize: 18.sp,fontWeight: FontWeight.bold),)
            ],
          ),
        ),
      ),
    );
  }
}
