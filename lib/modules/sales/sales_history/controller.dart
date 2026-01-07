
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SalesHistoryController extends GetxController{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var salesList = <DocumentSnapshot>[].obs;

  var isLoading = true.obs;

  var startDate = DateTime.now().obs;
  var endDate = DateTime.now().obs;

  var totalSalesAmount = 0.0.obs;
  var totalProfitAmount = 0.0.obs;
  var totalInvoices = 0.obs;
  var filteredSalesList = <DocumentSnapshot>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchSalesHistory();
  }

  void fetchSalesHistory(){
    isLoading(true);
    String startStr = DateFormat('yyyy-MM-dd').format(startDate.value);
    String endStr = DateFormat('yyyy-MM-dd').format(endDate.value);

    _firestore.collection('sales')
    .where('date',isGreaterThanOrEqualTo: startStr )
    .where('date',isLessThanOrEqualTo: endStr)
    .orderBy('date',descending: true)
    .snapshots()
    .listen((snapshot){
      salesList.assignAll(snapshot.docs);
      filteredSalesList.assignAll(snapshot.docs);
      calculateSummary();
      isLoading(false);
    },onError: (e){
      isLoading(false);
      Get.snackbar("Error", "ডাটা লোড করতে সমস্যা হয়েছে: $e");
    });
  }

  void calculateSummary(){
    double totalValue = 0.0;
    double totalCost = 0.0;

    for(var doc in filteredSalesList){
      var data = doc.data() as Map<String,dynamic>;
      totalValue += double.tryParse(data['totalPrice']?.toString() ?? '0.0') ?? 0.0;
      totalCost += double.tryParse(data['totalPurchasePrice']?.toString() ?? '0.0') ?? 0.0;
    }
    totalSalesAmount.value = totalValue;
    totalProfitAmount.value = totalValue - totalCost;
    totalInvoices.value = filteredSalesList.length;
  }

  void updateDateRange(DateTime start, DateTime end){
    startDate.value = start;
    endDate.value = end;
    fetchSalesHistory();
  }

  String formatAmount(double amount){
    final format = NumberFormat.currency(locale: 'en_IN', symbol: '৳',decimalDigits: 0);
    return format.format(amount);
  }
  
  void searchInvoice(String query){
    if(query.isEmpty){
      filteredSalesList.assignAll(salesList);
    }else{
      filteredSalesList.assignAll(salesList.where((doc){
        var data = doc.data() as Map<String, dynamic>;
        return data['saleId'].toString().toLowerCase().contains(query.toLowerCase());
      }).toList());
    }

    calculateSummary();
  }
  
  void deleteInvoice(DocumentSnapshot doc)async{
    try{
      isLoading(true);
      var data = doc.data() as Map<String,dynamic>;
      List items = data['items'] ?? [];

      WriteBatch batch = _firestore.batch();

      for(var item in items){
        String productId = item['id'];
        int quantitySold = int.tryParse(item['quantity']?.toString() ?? '0') ?? 0;

        DocumentReference productRef = _firestore.collection('products').doc(productId);

        batch.update(productRef, {
          'stock':FieldValue.increment(quantitySold)
        });
      }
      
      batch.delete(doc.reference);
      await batch.commit();
      
      Get.back();
      Get.snackbar("সফল", "মেমোটি ডিলিট এবং স্টক আপডেট করা হয়েছে।",backgroundColor: Colors.white);

    }catch(e){
      Get.snackbar("Error", "ডিলিট করতে সমস্যা হয়েছে: $e");
    }finally{
      isLoading(false);
    }
  }

}