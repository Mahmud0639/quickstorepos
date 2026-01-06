import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_store_pos/modules/sales/sales_history/controller.dart';

class SalesSummaryHeader extends GetView<SalesHistoryController> {
  const SalesSummaryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(()=> Container(
      padding: EdgeInsets.all(15.r),
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.blue.shade100)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _summaryColumn("মেমো",controller.totalInvoices.value.toString(),Icons.receipt_long),
          _summaryColumn("মোট বিক্রি",controller.formatAmount(controller.totalSalesAmount.value), Icons.account_balance_wallet),
          _summaryColumn("মোট লাভ",controller.formatAmount(controller.totalProfitAmount.value),Icons.trending_up)
        ],
      ),
    )
    );
  }
  
  Widget _summaryColumn(String title, String value, IconData icon){
    return Column(
      children: [
        Icon(icon,color: Colors.blueAccent,size: 20.sp,),
        SizedBox(height: 5.h,),
        Text(title,style: TextStyle(fontSize: 12.sp,color: Colors.grey),),
        Text(value,style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.bold,color: Colors.black87),)
      ],
    );
  }
}
