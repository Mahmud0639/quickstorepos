
/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InventoryController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var allProducts = <DocumentSnapshot>[].obs;
  var categories = <DocumentSnapshot>[].obs;
  var todaySales = <DocumentSnapshot>[].obs;

  var isLoading = true.obs;
  var searchQuery = "".obs;
  var selectedFilter = "All".obs;
  var pageTitle = "মালামাল ও স্টক".obs;

  // সামারি ভেরিয়েবল
  var totalItems = 0.obs;
  var lowStockCount = 0.obs;
  var outOfStockCount = 0.obs;
  var totalInventoryValue = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() {
    // প্রোডাক্টস লোড
    _firestore.collection('products').snapshots().listen((snapshot) {
      allProducts.assignAll(snapshot.docs);
      calculateSummary();
      isLoading(false);
    });

    // ক্যাটাগরি লোড
    _firestore.collection('categories').snapshots().listen((snapshot) {
      categories.assignAll(snapshot.docs);
    });

    // সেলস লোড
    String todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _firestore.collection('sales').where('date', isEqualTo: todayStr).snapshots().listen((snapshot) {
      todaySales.assignAll(snapshot.docs);
    });
  }

  void calculateSummary() {
    int low = 0;
    int out = 0;
    double value = 0.0;
    for (var doc in allProducts) {
      int stock = int.tryParse(doc['stock']?.toString() ?? '0') ?? 0;
      double price = double.tryParse(doc['price']?.toString() ?? '0.0') ?? 0.0;
      if (stock == 0) out++;
      if (stock > 0 && stock <= 5) low++;
      value += (stock * price);
    }
    totalItems.value = allProducts.length;
    lowStockCount.value = low;
    outOfStockCount.value = out;
    totalInventoryValue.value = value;
  }

  // --- এই ফাংশনটি এবার কাজ করবেই ---
  List<DocumentSnapshot> getFilteredProducts(String catName) {
    // এই ৩টি লাইন GetX কে বাধ্য করবে UI আপডেট করতে
    String query = searchQuery.value.toLowerCase();
    String filter = selectedFilter.value;

    // ১. প্রথমে এই ক্যাটাগরির প্রোডাক্ট আলাদা করা
    var results = allProducts.where((p) => p['category'] == catName).toList();

    // ২. তারপর নাম দিয়ে সার্চ
    if (query.isNotEmpty) {
      results = results.where((p) => p['name'].toString().toLowerCase().contains(query)).toList();
    }

    // ৩. সবশেষে স্টক ফিল্টার
    if (filter == "Low Stock") {
      results = results.where((p) {
        int s = int.tryParse(p['stock'].toString()) ?? 0;
        return s > 0 && s <= 5;
      }).toList();
    } else if (filter == "Out of Stock") {
      results = results.where((p) {
        int s = int.tryParse(p['stock'].toString()) ?? 0;
        return s == 0;
      }).toList();
    }

    return results;
  }

  String getCategoryValue(String catName) {
    double total = 0.0;
    var products = allProducts.where((p) => p['category'] == catName);
    for (var p in products) {
      int s = int.tryParse(p['stock'].toString()) ?? 0;
      double pr = double.tryParse(p['price'].toString()) ?? 0.0;
      total += (s * pr);
    }
    return amountFormat(total);
  }

  String getCategoryTodaySales(String catName) {
    double total = 0.0;
    for (var s in todaySales) {
      if (s['category'] == catName) {
        total += double.tryParse(s['totalPrice'].toString()) ?? 0.0;
      }
    }
    return amountFormat(total);
  }

  Future<void> updateStock(String docId, int newStock) async {
    await _firestore.collection('products').doc(docId).update({'stock': newStock});
  }

  String amountFormat(double amount) {
    final format = NumberFormat.currency(locale: 'en_IN', symbol: '৳', decimalDigits: 0);
    return format.format(amount);
  }
}



*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InventoryController extends GetxController{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var allProducts = <DocumentSnapshot>[].obs;
  var isLoading = true.obs;

  var pageTitle = "মালামাল ও স্টক".obs;

  var selectedFilter = "All".obs;

  var totalItems = 0.obs;
  var lowStockCount = 0.obs;
  var outOfStockCount = 0.obs;
  var totalInventoryValue = 0.0.obs;
  var searchQuery = "".obs;

  var todaySales = <DocumentSnapshot>[].obs;
  var categories = <DocumentSnapshot>[].obs;
  var categorizedProducts = <String,List<DocumentSnapshot>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    resetFilters();
    fetchProducts();
  }


  void resetFilters(){
    searchQuery.value = "";
    selectedFilter.value = "All";
    pageTitle.value = "মালামাল ও স্টক";
  }

  void fetchProducts(){
    _firestore.collection('products').snapshots().listen((snapshot){
      allProducts.assignAll(snapshot.docs);
      calculateSummary();
      allProducts.refresh();
      categorizedProducts.refresh();
      isLoading(false);
    });

    _firestore.collection('categories').snapshots().listen((snapshot){
      categories.assignAll(snapshot.docs);
    });

    String todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _firestore.collection('sales')
    .where('date', isEqualTo: todayStr)
    .snapshots().listen((snapshot){
      todaySales.assignAll(snapshot.docs);
    });
  }

  //category total value
  String getCategoryValue(String categoryName){
    var products = categorizedProducts[categoryName] ?? [];
    double total = 0.0;
    for(var p in products){
      int stock = int.tryParse(p['stock'].toString()) ?? 0;
      double price = double.tryParse(p['price'].toString()) ?? 0.0;
      total += (stock * price);
    }
    return amountFormat(total);
  }

  //today category sales
  String getCategoryTodaySales(String categoryName){
    double total = 0.0;
    for(var sale in todaySales){
      final data = sale.data() as Map<String, dynamic>;
      if(data.containsKey('items')){
        List items = data['items'] as List;
        for(var item in items){
          if(item['category'] == categoryName){
            double qty = double.tryParse(item['quantity'].toString()) ?? 0;
            double price = double.tryParse(item['price'].toString()) ?? 0;
            total += (qty * price);
          }
        }
      }
    }
    return amountFormat(total);
  }

  //update product here
  Future<void> updateProduct(String docId, String name, double price, double purchasePrice, int stock) async{
    try{
      await _firestore.runTransaction((transaction)async{
        DocumentReference productRef = _firestore.collection('products').doc(docId);
        DocumentSnapshot snapshot = await transaction.get(productRef);

        if(!snapshot.exists){
          throw "প্রোডাক্টটি খুঁজে পাওয়া যায়নি!";
        }

        transaction.update(productRef, {
          'name': name,
          'price': price,
          'purchasePrice': purchasePrice,
          'stock': stock,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });


      calculateSummary();
      allProducts.refresh();
      categorizedProducts.refresh();

      Get.snackbar("সফল হয়েছে!",
        "পণ্যের তথ্য ডাটাবেসে নির্ভুলভাবে আপডেট করা হলো",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,);
    }catch(e){
      Get.snackbar("আপডেট ব্যর্থ",
        "ত্রুটি: $e",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      duration: const Duration(seconds: 5));
    }
  }

  Future<void> updateStock(String docId, int newStock) async {
    try {
      // ১. ডাটাবেসে আপডেট পাঠান
      await _firestore.collection('products').doc(docId).update({
        'stock': newStock
      });

      // ২. লোকাল ডাটা আপডেট করার সবচেয়ে শক্তিশালী উপায়
      // আমরা পুরো লিস্টটাকে একবার ম্যাপ করে নতুন মান বসিয়ে দেব
      allProducts.value = allProducts.map((doc) {
        if (doc.id == docId) {
          // ফায়ারবেস থেকে নতুন ডাটা না আসা পর্যন্ত লোকালভাবে সাময়িকভাবে আপডেট দেখাবে
          // calculateSummary কল করলে এটি categorizedProducts এও চলে যাবে
          return doc;
        }
        return doc;
      }).toList();

      // ৩. এখন ম্যাপ এবং সামারি নতুন করে জেনারেট করুন
      // যেহেতু ফায়ারবেস snapshots().listen করছে, তাই ১-২ সেকেন্ড পর আসল ডাটা চলে আসবে
      // কিন্তু তৎক্ষণাৎ ইউজারকে দেখানোর জন্য আমরা fetchData বা calculateSummary আবার কল করবো
      calculateSummary();

      // ৪. সবশেষে রিফ্রেশ ট্রিগার করুন
      allProducts.refresh();
      categorizedProducts.refresh();

      Get.snackbar("সফল", "স্টক আপডেট হয়েছে",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);

    } catch (e) {
      Get.snackbar("ভুল", "আপডেট করা যায়নি");
    }
  }


  void calculateSummary(){
    int low = 0;
    int out = 0;
    double value = 0.0;

    var tempMap = <String,List<DocumentSnapshot>>{};
    for(var doc in allProducts){
      final data = doc.data() as Map<String, dynamic>;
      int stock = int.tryParse(data['stock']?.toString() ?? '0') ?? 0;
      double pPrice = 0.0;
      if(data.containsKey('purchasePrice') && data['purchasePrice'] != null){
        pPrice = double.tryParse(data['purchasePrice'].toString()) ?? 0.0;
      }
    //  double purchasePrice = double.tryParse(doc['purchasePrice']?.toString() ?? '0.0') ?? 0.0;

      if(stock == 0) out++;
      if(stock > 0 && stock <= 5) low++;
      value += (stock * pPrice);

      String cat = doc['category'] ?? 'Uncategorized';
      if(!tempMap.containsKey(cat)){
        tempMap[cat] = [];
      }
      tempMap[cat]!.add(doc);
    }

    totalItems.value = allProducts.length;
    lowStockCount.value = low;
    outOfStockCount.value = out;
    totalInventoryValue.value = value;
    categorizedProducts.value = tempMap;

    isLoading.value = false;

  }


  // --- আপনার কন্ট্রোলারের এই ফাংশনটি এভাবে আপডেট করুন ---
  List<DocumentSnapshot> getFilteredProducts(String catName) {
    // ১. প্রথমেই নিশ্চিত করুন আমরা Reactive ভেরিয়েবলগুলো রিড করছি
    // এটি না করলে UI বুঝবে না যে সার্চবক্সে টাইপ করলে লিস্ট আপডেট করতে হবে
    String query = searchQuery.value.toLowerCase();
    String filter = selectedFilter.value;

    // ২. ওই ক্যাটাগরির প্রোডাক্টগুলো নিন
    var productsInCategory = categorizedProducts[catName] ?? [];

    // ৩. সার্চ লজিক অ্যাপ্লাই করুন
    var results = productsInCategory.where((product) {
      String productName = product['name'].toString().toLowerCase();
      return productName.contains(query);
    }).toList();

    // ৪. এবার স্টক ফিল্টার অ্যাপ্লাই করুন
    if (filter == "Low Stock") {
      return results.where((p) {
        int s = int.tryParse(p['stock'].toString()) ?? 0;
        return s > 0 && s <= 5;
      }).toList();
    } else if (filter == "Out of Stock") {
      return results.where((p) {
        int s = int.tryParse(p['stock'].toString()) ?? 0;
        return s == 0;
      }).toList();
    }

    return results;
  }


  String amountFormat(double amount){
      if(amount >=10000000){
        return "৳${(amount / 10000000).toStringAsFixed(2)} Cr";
      }else if(amount >= 100000){
        return "৳${(amount / 100000).toStringAsFixed(2)} Lakh";
      }else{
        final format = NumberFormat.currency(locale: 'en_IN',symbol: '৳',decimalDigits: 0);
        return format.format(amount);
      }
  }


  @override
  void onClose() {
    searchQuery.value = "";
    selectedFilter.value = "All";
    pageTitle.value = "মালামাল ও স্টক";
    super.onClose();

  }






}
