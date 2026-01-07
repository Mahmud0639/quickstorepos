import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_store_pos/modules/sales/sales_history/controller.dart';
import 'package:quick_store_pos/pdf_service/pdf_service.dart';

class InvoiceListItem extends GetView<SalesHistoryController> {
  final DocumentSnapshot doc;

  const InvoiceListItem({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    var data = doc.data() as Map<String, dynamic>;
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
      child: ListTile(
        onTap: () => _showDetails(context, data),
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade50,
          child: Icon(Icons.done_all, color: Colors.green, size: 20.sp),
        ),
        title: Text(
          "ID: ${data['saleId'].toString().substring(0, 8).toUpperCase()}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("সময়: ${data['date']} | ${data['totalQuantity']} টি পণ্য"),
        trailing:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("মোট টাকা", style: TextStyle(fontSize: 10.sp,color: Colors.grey),),
            Text("৳${data['totalPrice']}", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueAccent,fontSize: 16.sp),),
           /* PopupMenuButton<String>(itemBuilder: (context)=>[
              const PopupMenuItem(value: "print",child: ListTile(leading: Icon(Icons.print,color: Colors.blue,),title: Text("প্রিন্ট ও শেয়ার"),contentPadding: EdgeInsets.zero,)),
              const PopupMenuItem(value: "delete",child: ListTile(leading: Icon(Icons.delete_outline,color: Colors.red,),title: Text("ডিলিট করুন"),contentPadding: EdgeInsets.zero,))
            ],padding: EdgeInsets.zero,icon: Icon(Icons.more_vert,size: 20.sp,color: Colors.grey,),
            onSelected: (value){
              if(value=='delete'){
                _confirmDelete(context, doc);
              }else if(value == 'print'){
                
              }
            },)*/
          ],
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, Map<String, dynamic> data) {
    List items = data['items'] as List;
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40),

                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),

                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.more_vert, size: 24.sp, color: Colors.grey),
                  onSelected: (value) {
                    if (value == 'delete') {
                      _confirmDelete(context, doc);
                    }else if(value == 'print'){
                      _showPrintOptions(context, data, false);
                        //PdfService.generateInvoice(data: data, isShare: false);
                    }else if(value == 'share'){
                      _showPrintOptions(context, data, true);
                        //PdfService.generateInvoice(data: data, isShare: true);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: "print",
                      child: ListTile(
                        leading: Icon(Icons.print, color: Colors.blue),
                        title: Text("প্রিন্ট করুন"),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const PopupMenuItem(
                      value: "share",
                      child: ListTile(
                        leading: Icon(Icons.share, color: Colors.green),
                        title: Text("মেমো শেয়ার করুন"),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const PopupMenuItem(
                      value: "delete",
                      child: ListTile(
                        leading: Icon(Icons.delete_outline, color: Colors.red),
                        title: Text("ডিলিট করুন"),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 10.h),
            Text("মেমোর বিস্তারিত আইটেম", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            const Divider(),

            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  var item = items[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text("${item['name']}"),
                    subtitle: Text("${item['quantity']} পিস x ${item['price']} ৳"),
                    trailing: Text("৳${item['quantity'] * item['price']}", style: const TextStyle(fontWeight: FontWeight.w600)),
                  );
                },
              ),
            ),

            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("সর্বমোট পরিশোধিত:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                Text("৳${data['totalPrice']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp, color: Colors.green)),
              ],
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _confirmDelete(BuildContext context, DocumentSnapshot doc){
    Get.defaultDialog(
      title: "সতর্কতা!",
      titleStyle: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
      middleText: "আপনি কি নিশ্চিতভাবে এই মেমোটি ডিলিট করতে চান? ডিলিট করলে এটি আর ফিরে পাবেন না।",
      textConfirm: "হ্যাঁ, ডিলিট",
      textCancel: "বাতিল",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: (){
        Get.back();
        if(Get.isBottomSheetOpen ?? false) Get.back();
        controller.deleteInvoice(doc);
      }
    );
  }

  void _showPrintOptions(BuildContext context, Map<String, dynamic> data, bool isShare) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("প্রিন্ট ফরমেট বেছে নিন"),
        content: const Text("আপনি কি বড় কাগজের (A4) মেমো চান নাকি ছোট রিসিট (POS)?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              PdfService.generateInvoice(
                  data: data,
                  isShare: isShare,
                  isPosPrinter: false // A4 এর জন্য
              );
            },
            child: const Text("A4 (বড় মেমো)"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              PdfService.generateInvoice(
                  data: data,
                  isShare: isShare,
                  isPosPrinter: true
              );
            },
            child: const Text("POS (ছোট রিসিট)"),
          ),
        ],
      ),
    );
  }
}
