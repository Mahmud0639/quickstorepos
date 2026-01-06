import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quick_store_pos/modules/sales/controller.dart';
import 'package:quick_store_pos/routes/app_routes.dart';

class SalesView extends GetView<SalesController> {
  const SalesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: _buildAppBar(),
      body: Column(
          children: [
          _buildTopSearchSection(),
      Expanded(child: LayoutBuilder(builder: (context, constraints) {
        //if it is windows or tab
        if (constraints.maxWidth > 900) {
          return Row(
            children: [
              Expanded(flex: 6, child: _buildProductListSection()),
              Expanded(flex: 4, child: _buildCartSection())
            ],
          );
        } else {
          //if it is mobile screen
          return _buildCartSection();
        }
      })),
      _buildBottomCheckoutBar()
      ],
    ),);
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("POS Terminal", style: TextStyle(color: Colors.black,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold),),
          Text(DateFormat('EEEE, dd MMMM').format(DateTime.now()),
            style: TextStyle(color: Colors.grey, fontSize: 12.sp),)
        ],
      ),
      actions: [
        IconButton(onPressed: () => Get.toNamed(AppRoutes.SALES_HISTORY),
            icon: const Icon(Icons.history, color: Colors.deepPurple,)),
        SizedBox(width: 10.w,),
      ],
    );
  }

  //smart search and scanner box design
  Widget _buildTopSearchSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF1F4F9),
          borderRadius: BorderRadius.circular(15.r),
        ),

        child: TextField(
          controller: controller.barcodeController,
          focusNode: controller.barcodeFocusNode,
          onSubmitted: (value) => controller.onBarcodeScanned(value),
          decoration: InputDecoration(
              hintText: "স্ক্যান করুন বা পণ্যের নাম লিখুন...",
              prefixIcon: const Icon(
                Icons.qr_code_scanner, color: Colors.deepPurple,),
              suffixIcon: Container(
                margin: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(10.r)
                ),
                child: const Icon(Icons.search, color: Colors.white,),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 15.h)
          ),
        ),

      ),
    );
  }

//where all the cart items will be stayed
  Widget _buildCartSection() {
    return Obx(() =>
    controller.cartItems.isEmpty ? _buildEmptyState() :
    ListView.builder(padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: controller.cartItems.length, itemBuilder: (context, index) {
          var item = controller.cartItems[index];
          return _buildCartCard(item, index);
        }));
  }

//item card design
  Widget _buildCartCard(Map<String, dynamic> item, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.r),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 5)
            )
          ]
      ),
      child: Row(
        children: [
          Container(
            height: 50.r,
            width: 50.r,
            decoration: BoxDecoration(
                color: Colors.deepPurple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r)
            ),
            child: const Icon(Icons.inventory_2, color: Colors.deepPurple,),
          ),
          SizedBox(width: 12.w,),
          //products name and price
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item['name'], style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15.sp),),
              Text("৳${item['price']}",
                style: TextStyle(color: Colors.grey, fontSize: 13.sp),)
            ],
          )
          ),
          //plus-minus controller
          Row(
            children: [
              _qtyButton(
                  Icons.remove, () => controller.decrementQuantity(index),
                  Colors.red.withValues(alpha: 0.1), Colors.red),
              Padding(padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Text("${item['quantity']}", style: TextStyle(
                    fontSize: 16.sp, fontWeight: FontWeight.bold),),),
              _qtyButton(Icons.add, () =>
                  controller.incrementQuantity(index, item['maxStock']),
                  Colors.green.withValues(alpha: 0.1), Colors.green),
            ],
          )
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap, Color bg,
      Color iconColor) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
            color: bg, borderRadius: BorderRadius.circular(8.r)),
        child: Icon(icon, size: 18.sp, color: iconColor),
      ),
    );
  }


  Widget _buildBottomCheckoutBar() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r), topRight: Radius.circular(30.r)),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 20, spreadRadius: 5
            )
          ]
      ),
      child: SafeArea(child: Row(
        children: [
          Expanded(child: Column(mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("মোট পরিশোধযোগ্য",
                style: TextStyle(color: Colors.grey, fontSize: 12.sp),),
              Obx(() =>
                  Text("৳${controller.totalAmount.toStringAsFixed(0)}",
                    style: TextStyle(fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),)),
            ],)),

          //confirm sale
          ElevatedButton(onPressed: () => _showConfirmationDialog(),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(
                      horizontal: 30.w, vertical: 15.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r)),
                  elevation: 5),
              child: Row(
                children: [
                  Text("বিক্রি করুন",style: TextStyle(fontSize: 16.sp,color: Colors.white),),
                  SizedBox(width: 8.w,),
                  const Icon(Icons.arrow_forward_ios,size: 16,color: Colors.white,)
                ],
              ))
        ],
      )),
    );
  }
  
  Widget _buildEmptyState(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_basket_outlined,size: 80.sp,color: Colors.grey[300],),
          SizedBox(height: 10.h,),
          Text("কোনো পণ্য যোগ করা হয়নি", style: TextStyle(color: Colors.grey, fontSize: 16.sp))
        ],
      ),
    );
  }

  void _showConfirmationDialog(){
    Get.defaultDialog(
      title: "বিক্রয় নিশ্চিত করুন",
      titleStyle: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.bold),
      content: Column(
        children: [
          Text("আপনি কি এই ${controller.totalItemsCount}টি পণ্য বিক্রি করতে চান?"),
          SizedBox(height: 10.h,),
          Text("মোট বিল: ৳${controller.totalAmount.toStringAsFixed(0)}",style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold,color: Colors.deepPurple),),
          
        ],
      ),
      cancel: OutlinedButton(onPressed: ()=>Get.back(), child: const Text("না, ফিরে যান")),
      confirm: ElevatedButton(
        onPressed: () => controller.confirmSale(),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        child: const Text("হ্যাঁ, নিশ্চিত", style: TextStyle(color: Colors.white)),
      ),
    );
  }
  
  Widget  _buildProductListSection(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey.shade200,width: 1))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Text("পণ্য তালিকা",style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.bold, color: Colors.blueGrey),),),
          Expanded(child: StreamBuilder(stream: FirebaseFirestore.instance.collection('products').snapshots(),
              builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(),);
            }
            if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
              return const Center(child: Text("ইনভেন্টরিতে কোনো পণ্য নেই"),);
            }
            var products = snapshot.data!.docs;
            
            return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,
                crossAxisSpacing: 10.w,mainAxisSpacing: 10.h,childAspectRatio: 0.85), 
                itemBuilder: (context,index){
                  var product = products[index];
                  var data = product.data() as Map<String,dynamic>;
                  int stock = int.tryParse(data['stock']?.toString() ?? '0') ?? 0;
                  
                  return InkWell(
                    onTap: ()=> controller.addToCart(product),
                    borderRadius: BorderRadius.circular(15.r),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(color: Colors.grey.shade100)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_2_outlined,size: 30.sp,color: Colors.deepPurple,),
                          SizedBox(height: 8.h,),
                          Text(data['name'] ?? 'No Name',textAlign: TextAlign.center,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13.sp),),
                          Text("৳${data['price']}",style: TextStyle(color: Colors.green,fontWeight: FontWeight.w600,fontSize: 12.sp),),
                          SizedBox(height: 5.h,),
                          //stock signal
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 2.h),
                            decoration: BoxDecoration(color: stock > 0 ? Colors.blue.withValues(alpha: 0.1): Colors.red.withValues(alpha: 0.1),borderRadius: BorderRadius.circular(10.r)),
                            child: Text("স্টক: $stock",style: TextStyle(fontSize: 10.sp,color: stock > 0 ? Colors.blue : Colors.red),),
                          )
                        ],
                      ),
                    ),
                  );
                });
            
          }))
        ],
      ),
    );
  }
}
