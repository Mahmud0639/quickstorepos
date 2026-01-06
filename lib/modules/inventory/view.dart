import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_store_pos/modules/inventory/controller.dart';
import 'package:quick_store_pos/routes/app_routes.dart';

class InventoryView extends GetView<InventoryController> {
  const InventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text("ইনভেন্টরি ড্যাশবোর্ড",style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold),),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

      body: Obx((){
        if(controller.isLoading.value) return const Center(child: CircularProgressIndicator());
        return Padding(padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("সারসংক্ষেপ",style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.bold),),
              SizedBox(height: 15.h,),
              Expanded(child: GridView.count(crossAxisCount: GetPlatform.isWindows ? 4:2,
                crossAxisSpacing: 15.w,
                mainAxisSpacing: 15.h,
              childAspectRatio: GetPlatform.isWindows ? 1.5:1.1,
              children: [
                _buildSummaryCard("মোট মালামাল", controller.totalItems.value.toString(), Icons.inventory_2, Colors.blue,(){
                    controller.selectedFilter.value = "All";
                    controller.pageTitle.value = "মোট মালামাল";
                    Get.toNamed(AppRoutes.INVENTORY_PAGE);
                }),
                _buildSummaryCard("লো স্টক", controller.lowStockCount.value.toString(), Icons.warning_amber_rounded, Colors.orange,(){
                  controller.selectedFilter.value = "Low Stock";
                  controller.pageTitle.value = "লো স্টক";
                  Get.toNamed(AppRoutes.INVENTORY_PAGE);
                }),
                _buildSummaryCard("স্টক নেই", controller.outOfStockCount.value.toString(), Icons.error_outline, Colors.red,(){
                  controller.selectedFilter.value = "Out of Stock";
                  controller.pageTitle.value = "স্টক নেই";
                  Get.toNamed(AppRoutes.INVENTORY_PAGE);
                }),
                _buildSummaryCard("মোট মূল্য", controller.amountFormat(controller.totalInventoryValue.value), Icons.account_balance_wallet, Colors.green,(){

                })
              ],),



              )
            ],
          ),

        );
      }),

    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color, VoidCallback onTap){
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(color: Colors.black12,blurRadius: 10, offset: Offset(0, 5)),
          ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.1),
              child: Icon(icon,color: color,size: 28.sp),
            ),
            SizedBox(height: 10.h,),
            Text(title,style: TextStyle(fontSize: 14.sp,color: Colors.grey[600]),),
            SizedBox(height: 5.h,),
            Text(value,style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.bold,color: color),)
          ],
        ),
      ),
    );
  }
}
