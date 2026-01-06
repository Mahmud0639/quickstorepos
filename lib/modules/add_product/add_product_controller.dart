import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductController extends GetxController {
  //Text editing controllers
  final nameController = TextEditingController();
  final barCodeController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final purchasePriceController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;
  var categories = <String>[].obs;
  var selectedCategory = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  //category fetching
  void fetchCategories() async{
    //
    // final snapshot = await _firestore.collection('categories').orderBy('name').get();
    //
    // if(snapshot.docs.isNotEmpty){
    //   categories.value = snapshot.docs
    //       .map((doc) => doc['name'].toString())
    //       .toList();
    //   if (selectedCategory.value.isEmpty) {
    //     selectedCategory.value = categories[0];
    //   }
    // }

    _firestore.collection('categories').orderBy('name').snapshots().listen((
       snapshot,
     ) {
       categories.value = snapshot.docs
           .map((doc) => doc['name'].toString())
           .toList();
       if (categories.isNotEmpty && selectedCategory.value.isEmpty) {
         selectedCategory.value = categories[0];
       }
     });
  }

  //new category adding
  Future<void> addNewCategory(String categoryName) async {
    String name = categoryName.trim();
    if (name.isEmpty) return;

    if (categories.contains(name)) {
      Get.snackbar("সতর্কতা", "এই ক্যাটাগরি আগেই যোগ করা হয়েছে!");
      return;
    }

    try {
      await _firestore.collection('categories').doc(name).set({
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
      });

      selectedCategory.value = name;
      Get.snackbar(
        "সফল",
        "নতুন ক্যাটেগরি '$name' যোগ করা হয়েছে",
        backgroundColor: Colors.blueGrey,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "এরর",
        "দয়া করে আবার চেষ্টা করুন। ক্যাটেগরি যোগ করা হয়নি: $e",
      );
    }
  }

  Future<void> saveProduct() async {
    if (nameController.text.isEmpty ||
        barCodeController.text.isEmpty ||
        priceController.text.isEmpty ||
        purchasePriceController.text.isEmpty ||
        stockController.text.isEmpty ||
        selectedCategory.isEmpty) {
      Get.snackbar(
        "ভ্যালিডেশন এরর",
        "সবগুলো ঘর পূরণ করুন।",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    String barcode = barCodeController.text.trim();
    try {
      await _firestore.runTransaction((transaction) async {
        final querySnapshot = await _firestore
            .collection('products')
            .where('barcode', isEqualTo: barcode)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          throw "এই বারকোডটি ($barcode) আগেই অন্য প্রোডাক্টে ব্যবহার করা হয়েছে!";
        }
        DocumentReference newProductRef = _firestore
            .collection('products')
            .doc();
        transaction.set(newProductRef, {
          'name': nameController.text.trim(),
          'barcode': barcode,
          'category': selectedCategory.value,
          'price': double.tryParse(priceController.text) ?? 0.0,
          'purchasePrice' : double.tryParse(purchasePriceController.text) ?? 0.0,
          'stock': int.tryParse(stockController.text) ?? 0,
          'searchName': nameController.text.trim().toLowerCase(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      });

      _clearFields();
      Get.back();
      Get.snackbar(
        "Success",
        "Product has been saved.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _clearFields() {
    nameController.clear();
    barCodeController.clear();
    priceController.clear();
    stockController.clear();
    purchasePriceController.clear();
  }

  @override
  void onClose() {
    nameController.dispose();
    barCodeController.dispose();
    priceController.dispose();
    stockController.dispose();
    purchasePriceController.dispose();
    super.onClose();
  }
}
