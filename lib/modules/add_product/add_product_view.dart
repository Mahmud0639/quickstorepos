import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_store_pos/modules/add_product/add_product_controller.dart';

class AddProductView extends GetView<AddProductController> {
  const AddProductView({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: const Text("নতুন প্রোডাক্ট যোগ করুন"),centerTitle: true,),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Container(
              constraints: BoxConstraints(maxWidth: 600.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ক্যাটাগরি নির্বাচন করুন",style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold),),
                  SizedBox(height: 8.h,),
                  Row(
                    children: [
                      Expanded(child: Obx((){

                        return DropdownSearch<String>(
                          items: (filter, infiniteScrollProps)=>controller.categories,
                          selectedItem: controller.selectedCategory.value,
                          onChanged: (value)=> controller.selectedCategory.value = value ?? "",
                          decoratorProps: const DropDownDecoratorProps(
                              decoration: InputDecoration(
                                  hintText: "ক্যাটাগরি খুঁজুন...",
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12,vertical: 10)
                              )
                          ),
                          popupProps: PopupProps.menu(
                              showSearchBox: true,
                              searchFieldProps: TextFieldProps(
                                decoration: InputDecoration(hintText: "সার্চ করুন..."),
                              )
                          ),
                        );
                      })),
                      SizedBox(width: 10.w,),
                      IconButton.filled(onPressed: ()=>_showAddCategoryDialog(context, controller), icon: const Icon(Icons.add),tooltip: "নতুন ক্যাটাগরি যোগ করুন",)
                    ],
                  ),
                  SizedBox(height: 20.h,),
                  _buildTextField(
                    controller: controller.nameController,
                    label: "প্রোডাক্টের নাম",
                    icon: Icons.shopping_bag_outlined,
                  ),
                  SizedBox(height: 15.h,),
                  _buildTextField(
                    controller: controller.barCodeController,
                    label: "বারকোড (স্ক্যান করুন বা লিখুন)",
                    icon: Icons.qr_code_scanner,
                  ),
                  SizedBox(height: 15.h,),
                  
                  _buildTextField(controller: controller.purchasePriceController, label: "কেনা দাম (Purchase Price)", icon: Icons.account_balance_wallet_outlined,isDouble: true),
                  
                  SizedBox(height: 15.h,),

                  _buildTextField(
                    controller: controller.priceController,
                    label: "বিক্রয় মূল্য",
                    icon: Icons.sell_outlined,
                    isDouble: true
                  ),
                  SizedBox(height: 15.h,),
                  _buildTextField(
                    controller: controller.stockController,
                    label: "স্টক পরিমাণ (Quantity)",
                    icon: Icons.inventory_2_outlined,
                    isNumber: true
                  ),
                  SizedBox(height: 35.h,),
                  Obx(()=>SizedBox(
                    width: double.infinity,
                    height: 55.h,
                    child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))
                    ),
                        onPressed: controller.isLoading.value ? null : () => controller.saveProduct(),
                        child: controller.isLoading.value ? const CircularProgressIndicator(color: Colors.white,)
                            : Text("প্রোডাক্ট সেভ করুন",style: TextStyle(fontSize: 16.sp,color: Colors.white,fontWeight: FontWeight.bold),)),
                  ))
                ],
              ),
          ),

          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller,
  required String label,
  required IconData icon,
  bool isNumber = false,
    bool isDouble = false,

  }){
    return TextFormField(
      controller: controller,
      textInputAction: TextInputAction.next,
      keyboardType: (isNumber || isDouble) ? const TextInputType.numberWithOptions(decimal: true): TextInputType.text,
      inputFormatters: [
        if(isNumber && !isDouble) FilteringTextInputFormatter.digitsOnly,
        if(isDouble) FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),

      ],

      decoration: InputDecoration(
        labelText:  label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.05)
      ),
    );

  }

  void _showAddCategoryDialog(BuildContext context, AddProductController controller){
      final categoryNameController = TextEditingController();
      Get.defaultDialog(
        title: "নতুন ক্যাটাগরি",
        content: Padding(padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: categoryNameController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "যেমনঃ টায়ার, টিউব, ব্যাটারি",
            border: OutlineInputBorder()
          ),
        ),
        ),
        textConfirm: "যোগ করুন",
        confirmTextColor: Colors.white,
        onConfirm: (){
          controller.addNewCategory(categoryNameController.text);
          Get.back();
        }
      );
  }

}
