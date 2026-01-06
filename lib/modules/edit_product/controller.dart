import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:quick_store_pos/modules/inventory/controller.dart';

class EditProductController extends GetxController{

  final InventoryController inventoryController = Get.find();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController purchasePriceController;
  late TextEditingController stockController;

  late String docId;

  var isHovered = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    var product = Get.arguments['product'];
    docId = Get.arguments['docId'];
    var data = product.data() as Map<String,dynamic>;

    nameController = TextEditingController(
      text: data['name']?.toString() ?? "নাম নেই",
    );

    priceController = TextEditingController(
      text: (data['price'] ?? 0.0).toString(),
    );
  //  purchasePriceController = TextEditingController(text: product['purchasePrice']?.toString() ?? "0.0");
    stockController = TextEditingController(
      text: (data['stock'] ?? 0).toString(),
    );


    String pPrice = data.containsKey('purchasePrice') ? data['purchasePrice'].toString() : "0.0";
    purchasePriceController = TextEditingController(text: pPrice);

  }

  void updateData(){
    inventoryController.updateProduct(docId, nameController.text, double.tryParse(priceController.text)?? 0.0, double.tryParse(purchasePriceController.text)??0.0, int.tryParse(stockController.text) ?? 0);

    Get.back();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    nameController.dispose();
    priceController.dispose();
    purchasePriceController.dispose();
    stockController.dispose();
    super.onClose();
  }



}