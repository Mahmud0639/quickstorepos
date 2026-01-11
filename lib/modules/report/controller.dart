
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReportController extends GetxController {


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription? _salesSubscription;
  var chartData = <DateTime, double>{}.obs;


  var isLoading = false.obs;
  var selectedRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  ).obs;

  var netProfit = 0.0.obs;
  var totalSales = 0.0.obs;
  var soldItemsCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReportData();
  }

  void updateDateRange(DateTimeRange range) {
    selectedRange.value = range;
    fetchReportData();
  }

  void fetchReportData() {
    _salesSubscription?.cancel();

    isLoading(true);

    String startDateStr = DateFormat('yyyy-MM-dd').format(selectedRange.value.start);
    String endDateStr = DateFormat('yyyy-MM-dd').format(selectedRange.value.end);

    _salesSubscription = _firestore.collection('sales')
        .where('date', isGreaterThanOrEqualTo: startDateStr)
        .where('date', isLessThanOrEqualTo: endDateStr)
        .snapshots()
        .listen((snapshot) {

      calculateMetrics(snapshot.docs);
      isLoading(false);

    }, onError: (e) {
      isLoading(false);
      Get.snackbar("Error", "ডাটা আপডেট হতে সমস্যা হয়েছে");
    });
  }

  void calculateMetrics(List<DocumentSnapshot> salesDocs) {
    double tempProfit = 0.0;
    double tempSales = 0.0;
    int tempItems = 0;
    Map<DateTime, double> dateWiseSales = {};

    for (var doc in salesDocs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      double salePrice = (data['totalPrice'] ?? 0.0).toDouble();
      double costPrice = (data['totalPurchasePrice'] ?? 0.0).toDouble();
      int qty = int.tryParse(data['totalQuantity'].toString()) ?? 0;

      DateTime saleDate = DateFormat('yyyy-MM-dd').parse(data['date']);

      tempSales += salePrice;
      tempItems += qty;
      tempProfit += (salePrice - costPrice);

      dateWiseSales[saleDate] = (dateWiseSales[saleDate] ?? 0) + salePrice;
    }

    totalSales.value = tempSales;
    netProfit.value = tempProfit;
    soldItemsCount.value = tempItems;

    var sortedMap = Map.fromEntries(
        dateWiseSales.entries.toList()..sort((a, b) => a.key.compareTo(b.key))
    );
    chartData.value = sortedMap;
  }

  @override
  void onClose() {
    _salesSubscription?.cancel();
    super.onClose();
  }

  String get reportHeader {
    final start = selectedRange.value.start;
    final end = selectedRange.value.end;
    final today = DateTime.now();

    if (DateFormat('yyyy-MM-dd').format(start) == DateFormat('yyyy-MM-dd').format(end)) {
      if (start.day == today.day && start.month == today.month && start.year == today.year) {
        return "আজকের রিপোর্ট";
      }
      return DateFormat('dd MMMM, yyyy').format(start);
    }

    return "${DateFormat('dd MMM').format(start)} - ${DateFormat('dd MMM, yyyy').format(end)}";
  }
}