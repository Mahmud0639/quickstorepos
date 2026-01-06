import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class InvoiceListItem extends StatelessWidget {
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
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("মোট টাকা", style: TextStyle(fontSize: 10.sp,color: Colors.grey),),
            Text("৳${data['totalPrice']}", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueAccent,fontSize: 16.sp),)
          ],
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, Map<String, dynamic> data){
    List items = data['items'] as List;
    Get.bottomSheet(Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10.r)
              ),
            ),
          ),
          SizedBox(height: 15.h,),
          Text("মেমোর বিস্তারিত আইটেম", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),),
          const Divider(),
          Flexible(child: ListView.builder(shrinkWrap: true,itemCount: items.length,itemBuilder: (context,index){
            var item = items[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text("${item['name']}"),
              subtitle: Text("${item['quantity']} পিস x ${item['price']} ৳"),
              trailing: Text("৳${item['quantity'] * item['price']}",style: TextStyle(fontWeight: FontWeight.w600),),
              
            );
          })),
          const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("সর্বমোট পরিশোধিত:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.sp),),
            Text("৳${data['totalPrice']}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.sp,color: Colors.green),)
          ],
    ),
          SizedBox(height: 10.h,)
        ],
      ),
    ),
        isScrollControlled: true,
    );
  }
}
