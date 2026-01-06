import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_store_pos/modules/edit_product/controller.dart';

class EditProductView extends GetView<EditProductController> {
  const EditProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text("পণ্য এডিট করুন", style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(maxWidth: 500.w),
            padding: EdgeInsets.all(24.r),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(30.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ]
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader("পণ্যের সাধারণ তথ্য"),
                      SizedBox(height: 20.h,),
                      _buildAnimatedTextField(controller.nameController,"প্রোডাক্টের নাম",Icons.edit_note),
                      SizedBox(
                        height: 25.h,
                      ),
                      _buildHeader("মূল্য ও ইনভেন্টরি"),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          Expanded(child: _buildAnimatedTextField(
                            controller.purchasePriceController,"কেনা দাম",
                            Icons.shopping_cart_outlined,
                            isDouble: true
                          )),
                          SizedBox(width: 15.w
                              ,),
                          Expanded(child: _buildAnimatedTextField(controller.priceController, "বিক্রয় মূল্য", Icons.sell_outlined,isDouble: true)),
                        ],
                      ),
                      
                      SizedBox(
                        height: 20.h,
                      ),
                      _buildAnimatedTextField(controller.stockController, "বর্তমান স্টক", Icons.inventory_2_outlined,isNumber: true),
                      SizedBox(height: 40.h,),
                      
                      MouseRegion(
                        onEnter: (_) => controller.isHovered.value = true,
                        onExit: (_) => controller.isHovered.value = false,
                        child: Obx(()=>AnimatedContainer(duration: const Duration(milliseconds: 200),
                        width: double.infinity,
                        height: 55.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              gradient: controller.isHovered.value ? const LinearGradient(colors: [Color((0xFF6366F1)),Color(0xFF4F46E5)]):  const LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF4338CA)]),
                              boxShadow: controller.isHovered.value ? [BoxShadow(color: Colors.indigo.withValues(alpha: 0.4),blurRadius: 15,offset: const Offset(0, 8))] : [],
                            ),
                        child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r))),onPressed: ()=> controller.updateData(), child: Text("তথ্য আপডেট করুন", style: TextStyle(fontSize: 16.sp,color: Colors.white,fontWeight: FontWeight.bold),)),)),
                      )
                      
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildHeader(String title){
    return Text(title, style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w600,color: Colors.indigo),);
  }

  Widget _buildAnimatedTextField(TextEditingController textController, String label, IconData icon, {bool isNumber = false, bool isDouble = false}){
      return TextFormField(
        controller: textController,
        keyboardType: (isNumber || isDouble)? TextInputType.number: TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 22.sp,),
            filled: true, 
          fillColor:  Colors.green[50],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r),borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r),borderSide: BorderSide(color: Colors.grey[200]!)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r),borderSide:const  BorderSide(color: Colors.indigo, width: 2)),
          labelStyle: TextStyle(fontSize: 13.sp)
        ),
      );
  }

}
