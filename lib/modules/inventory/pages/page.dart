import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_store_pos/modules/inventory/controller.dart';
import 'package:quick_store_pos/routes/app_routes.dart';

class InventoryPage extends GetView<InventoryController> {
  const InventoryPage({super.key});
  @override
  Widget build(BuildContext context) {

    final TextEditingController searchController = TextEditingController();


    return PopScope(
      onPopInvokedWithResult: (didPop,result){
        if(didPop){
          controller.searchQuery.value = "";
          controller.selectedFilter.value = "All";
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          // ১. টাইটেলকে Obx দিয়ে ঘিরুন যাতে এটি আপডেট হয়
          title: Obx(() => Text(
            controller.pageTitle.value,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          )),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        // সরাসরি Column দিন, বাইরে কোনো Obx দেওয়ার দরকার নেই
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5.r)],
                      ),
                      child: Obx(()=>TextField(
                        controller: searchController,
                        onChanged: (value) => controller.searchQuery.value = value,
                        decoration: InputDecoration(
                          hintText: "পণ্য খুঁজুন...",
                          prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
                          suffixIcon: controller.searchQuery.value.isEmpty ? null : IconButton(onPressed: (){
                            controller.searchQuery.value = "";
                            searchController.clear();
                          }, icon: const Icon(CupertinoIcons.clear_circled_solid,color: Colors.black,)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 15.h),
                        ),
                      ),)
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: PopupMenuButton<String>(
                      icon: const Icon(Icons.filter_list, color: Colors.white),
                      onSelected: (value) {
                        controller.selectedFilter.value = value;
                        // টাইটেল আপডেট করার লজিক
                        if (value == "All") controller.pageTitle.value = "সব মালামাল";
                        if (value == "Low Stock") controller.pageTitle.value = "লো স্টক";
                        if (value == "Out of Stock") controller.pageTitle.value = "স্টক নেই";
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: "All", child: Text("সব মালামাল")),
                        const PopupMenuItem(value: "Low Stock", child: Text("কম স্টক (<=5)")),
                        const PopupMenuItem(value: "Out of Stock", child: Text("স্টক নেই (0)"))
                      ],
                    ),
                  )
                ],
              ),
            ),

            // ২. শুধুমাত্র লিস্ট এরিয়াকে Obx দিয়ে ঘিরুন
            // Expanded(
            //   child: Obx(() {
            //     if (controller.isLoading.value) {
            //       return const Center(child: CircularProgressIndicator());
            //     }
            //
            //     return ListView.builder(
            //       itemCount: controller.categories.length,
            //       itemBuilder: (context, index) {
            //         var category = controller.categories[index];
            //         String catName = category['name'];
            //
            //         // ৩. এখানে ফিল্টার কল হবে যা রিয়েল-টাইম আপডেট করবে
            //         var filteredProducts = controller.getFilteredProducts(catName);
            //
            //         if (filteredProducts.isEmpty) {
            //           return const SizedBox.shrink();
            //         }
            //
            //         return Card(
            //           margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            //           elevation: 2,
            //           child: ExpansionTile(
            //             // Key দেওয়ার কারণে সার্চ করার সাথে সাথে কার্ড রিফ্রেশ হবে
            //             key: ValueKey("${controller.selectedFilter.value}_${controller.searchQuery.value}_$catName"),
            //            // initiallyExpanded: controller.searchQuery.value.isNotEmpty,
            //             shape: const Border(),
            //             leading: CircleAvatar(
            //               backgroundColor: Colors.deepPurple.withValues(alpha: 0.1),
            //               child: const Icon(Icons.category, color: Colors.deepPurple),
            //             ),
            //             title: Text(catName, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            //             subtitle: Text("আইটেম: ${filteredProducts.length} টি"),
            //             children: [
            //               // আপনার সেই সামারি ট্যাগ এবং প্রোডাক্ট লিস্ট কোড এখানে থাকবে...
            //               Padding(
            //                 padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            //                 child: Row(
            //                   children: [
            //                     _buildSummaryTag("মোট মূল্য", controller.getCategoryValue(catName), Colors.blue),
            //                     SizedBox(width: 10.w),
            //                     _buildSummaryTag("আজকের সেল", controller.getCategoryTodaySales(catName), Colors.green),
            //                   ],
            //                 ),
            //               ),
            //               const Divider(),
            //               ListView.builder(
            //                 shrinkWrap: true,
            //                 physics: const NeverScrollableScrollPhysics(),
            //                 itemCount: filteredProducts.length,
            //                 itemBuilder: (context, pIndex) {
            //                   var product = filteredProducts[pIndex];
            //                   return ListTile(
            //                     title: Text(product['name']),
            //                     subtitle: Text("দাম: ${controller.amountFormat(double.tryParse(product['price'].toString()) ?? 0)}"),
            //                     trailing: Row(
            //                       mainAxisSize: MainAxisSize.min,
            //                       children: [
            //                         Text("${product['stock']}",
            //                             style: TextStyle(
            //                                 fontWeight: FontWeight.bold,
            //                                 color: (int.tryParse(product['stock'].toString()) ?? 0) < 5 ? Colors.red : Colors.black)),
            //                         IconButton(
            //                             onPressed: () => _showPasswordDialog(context, controller, product),
            //                             icon: const Icon(Icons.lock_outline, size: 20, color: Colors.orange))
            //                       ],
            //                     ),
            //                   );
            //                 },
            //               )
            //             ],
            //           ),
            //         );
            //       },
            //     );
            //   }),
            // )


            Expanded(
              child: Obx(() {
                // গেট-এক্সকে জানান দিন যে আমরা এই ভেরিয়েবলগুলোর পরিবর্তনের অপেক্ষায় আছি

                int trigger = controller.allProducts.length;

                final query = controller.searchQuery.value.toLowerCase();
                final filter = controller.selectedFilter.value;
                final allProducts = controller.allProducts;

                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  key: ValueKey("${filter}_${query}_${controller.allProducts.length}"),
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    var category = controller.categories[index];
                    String catName = category['name'];

                    // --- সরাসরি এখানেই ফিল্টার করুন (ফাংশন ছাড়াই) ---
                    var filteredProducts = allProducts.where((p) {
                      bool matchesCategory = p['category'] == catName;
                      bool matchesSearch = p['name'].toString().toLowerCase().contains(query);

                      bool matchesFilter = true;
                      if (filter == "Low Stock") {
                        int s = int.tryParse(p['stock'].toString()) ?? 0;
                        matchesFilter = s > 0 && s <= 5;
                      } else if (filter == "Out of Stock") {
                        int s = int.tryParse(p['stock'].toString()) ?? 0;
                        matchesFilter = s == 0;
                      }

                      return matchesCategory && matchesSearch && matchesFilter;
                    }).toList();

                    if (filteredProducts.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Card(

                      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      elevation: 2,
                      child: ExpansionTile(
                        key: ValueKey("${controller.selectedFilter.value}_${controller.searchQuery.value}_$catName"),
                        initiallyExpanded: controller.searchQuery.value.isNotEmpty,
                        shape: const Border(),
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepPurple.withValues(alpha: 0.1),
                          child: const Icon(Icons.category, color: Colors.deepPurple,),
                        ),

                        title: Text(catName,
                          style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.bold),),subtitle: Text("আইটেম: ${filteredProducts.length} টি"),
                        children: [
                          Padding(padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),child: Row(
                            children: [
                              _buildSummaryTag("মোট মূল্য", controller.getCategoryValue(catName),Colors.blue),
                              SizedBox(width: 10.w,),
                              _buildSummaryTag("আজকের সেল", controller.getCategoryTodaySales(catName),Colors.green),
                            ],
                          ),
                          ),
                          const Divider(),

                          //product list inside expansion tile
                          ListView.builder(shrinkWrap: true,physics: const NeverScrollableScrollPhysics(),
                              itemCount: filteredProducts.length,itemBuilder: (context, pIndex){
                                var product = filteredProducts[pIndex];
                                return ListTile(
                                  title: Text(product['name']),
                                  subtitle: Text("দাম: ${controller.amountFormat(double.tryParse(product['price'].toString()) ?? 0)}"),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("${product['stock']}",
                                        style: TextStyle(fontWeight: FontWeight.bold,
                                            color: (int.tryParse(product['stock'].toString()) ?? 0) < 5 ? Colors.red: Colors.black),
                                      ),
                                      IconButton(onPressed: ()=> _showPasswordDialog(context, controller, product),
                                          icon: const Icon(Icons.lock_outline,size: 20,color: Colors.orange,))
                                    ],
                                  ),
                                );
                              })
                        ],

                      ),

                    );
                    // return Card(
                    //   // কি (Key) হিসেবে সার্চ কুয়েরি দিন যাতে সাথে সাথে রিফ্রেশ হয়
                    //   key: ValueKey("${query}_${filter}_$catName"),
                    //   margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                    //   child: ExpansionTile(
                    //     initiallyExpanded: query.isNotEmpty || filter != "All",
                    //     title: Text(catName, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                    //     subtitle: Text("আইটেম: ${filteredProducts.length} টি"),
                    //     children: [
                    //       // আপনার আগের ডিজাইনগুলো (SummaryTag, Divider, ListTile) এখানে থাকবে
                    //       // ...
                    //     ],
                    //   ),
                    // );
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }

/*  ======================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title:  Text(controller.pageTitle.value,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,),),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black)
      ),
      body: Obx((){
        return Column(
          children: [
            Padding(padding: EdgeInsets.all(16.r),
              child: Row(
                children: [
                  Expanded(child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,blurRadius: 5.r
                          )
                        ]
                    ),
                    child: TextField(
                      //onChanged: (value)=>controller.searchQuery.value = value,
                      onChanged: (value){
                        controller.searchQuery.value = value;
                      },
                      decoration: InputDecoration(
                          hintText: "পণ্য খুঁজুন...",
                          prefixIcon: const Icon(Icons.search,color: Colors.deepPurple,),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 15.h)
                      ),
                    ),
                  )),
                  SizedBox(width: 10.w,),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: PopupMenuButton<String>(icon: const Icon(Icons.filter_list,color: Colors.white,),
                        onSelected: (value)=>controller.selectedFilter.value = value,
                        itemBuilder: (context)=>[
                          const PopupMenuItem(value: "All",child: Text("সব মালামাল")),
                          const PopupMenuItem(value: "Low Stock",child: Text("কম স্টক (<=5)")),
                          const PopupMenuItem(value: "Out of Stock",child: Text("স্টক নেই (0)"))
                        ]),
                  )
                ],
              ),
            ),
            Expanded(
              child: Obx((){

                if(controller.isLoading.value){
                  return const Center(child: CircularProgressIndicator(),);
                }

                return ListView.builder(itemCount: controller.categories.length,itemBuilder: (context,index){
                  var category = controller.categories[index];
                  String catName = category['name'];
                  var filteredProducts = controller.getFilteredProducts(catName);

                  if(filteredProducts.isEmpty){
                    return const SizedBox.shrink();
                  }
                  // if(filteredProducts.isEmpty && controller.searchQuery.isNotEmpty){
                  //   return const SizedBox.shrink();
                  // }

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    elevation: 2,
                    child: ExpansionTile(
                      key: ValueKey("${controller.selectedFilter.value}_${controller.searchQuery.value}_$catName"),
                      initiallyExpanded: controller.searchQuery.value.isNotEmpty,
                      shape: const Border(),
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple.withValues(alpha: 0.1),
                        child: const Icon(Icons.category, color: Colors.deepPurple,),
                      ),

                      title: Text(catName,
                        style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.bold),),subtitle: Text("আইটেম: ${filteredProducts.length} টি"),
                      children: [
                        Padding(padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),child: Row(
                          children: [
                            _buildSummaryTag("মোট মূল্য", controller.getCategoryValue(catName),Colors.blue),
                            SizedBox(width: 10.w,),
                            _buildSummaryTag("আজকের সেল", controller.getCategoryTodaySales(catName),Colors.green),
                          ],
                        ),
                        ),
                        const Divider(),

                        //product list inside expansion tile
                        ListView.builder(shrinkWrap: true,physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredProducts.length,itemBuilder: (context, pIndex){
                              var product = filteredProducts[pIndex];
                              return ListTile(
                                title: Text(product['name']),
                                subtitle: Text("দাম: ${controller.amountFormat(double.tryParse(product['price'].toString()) ?? 0)}"),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("${product['stock']}",
                                      style: TextStyle(fontWeight: FontWeight.bold,
                                          color: (int.tryParse(product['stock'].toString()) ?? 0) < 5 ? Colors.red: Colors.black),
                                    ),
                                    IconButton(onPressed: ()=> _showPasswordDialog(context, controller, product),
                                        icon: const Icon(Icons.lock_outline,size: 20,color: Colors.orange,))
                                  ],
                                ),
                              );
                            })
                      ],

                    ),

                  );
                }
                );
              }),

            )
          ],
        );
      })


      );

  }
  ========================================*/

  Widget _buildSummaryTag(String label, String value, Color color){
    return Expanded(child: Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,style: TextStyle(fontSize: 10.sp, color:color),),
          Text(value,style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold,color: color),)
        ],
      ),
    ));
  }

  void _showPasswordDialog(BuildContext context, InventoryController controller, var product){
      TextEditingController passController = TextEditingController();
      Get.defaultDialog(
        title: "সিকিউরিটি চেক",
        content: TextField(
          controller: passController,
          obscureText: true,
          decoration: const InputDecoration(hintText: "অ্যাডমিন পাসওয়ার্ড দিন",prefixIcon: Icon(Icons.lock)),
          onSubmitted: (value){
            if(value == "1234"){
              Get.back();
              Get.toNamed(AppRoutes.INVENTORY_EDIT, arguments: {'product': product,'docId': product.id});
            }else{
              Get.snackbar("ভুল পাসওয়ার্ড", "সঠিক পাসওয়ার্ড দিন", backgroundColor: Colors.red, colorText: Colors.white);
            }
          },
        ),
        
        confirm: SizedBox(
          width: double.infinity,
          child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),onPressed: (){
            if(passController.text == "1234"){
              Get.back();
              Get.toNamed(AppRoutes.INVENTORY_EDIT, arguments: {'product': product,'docId': product.id});
            }else{
              Get.snackbar("ভুল পাসওয়ার্ড", "সঠিক পাসওয়ার্ড দিন", backgroundColor: Colors.red, colorText: Colors.white);
            }
            
          }, child: const Text("ভেরিফাই", style: TextStyle(color: Colors.white)),
        )
          
      ));
  }

  void _showEditStockDialog(BuildContext context, InventoryController controller, var product){
    int currentStock = int.tryParse(product['stock'].toString()) ?? 0;
    Get.defaultDialog(
      title: product['name'],
      content: StatefulBuilder(builder: (context, setState){
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(onPressed: ()=> setState(()=>currentStock--) , icon: const Icon(Icons.remove_circle_outline)),
            Text("$currentStock",style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            IconButton(onPressed: ()=> setState(()=>currentStock++) , icon: const Icon(Icons.add_circle_outline))
          ],
        );
      }),
      confirm: ElevatedButton(onPressed: ()async{
        await controller.updateStock(product.id, currentStock);
        if(Get.isDialogOpen!){
          Get.until((route)=>!Get.isDialogOpen!);
        }
        //Get.back();
      }, child: const Text("আপডেট"))
    );
  }
}
