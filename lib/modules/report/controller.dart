import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReportController extends GetxController{
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    var isLoading = true.obs;
    var selectedDate = DateTime.now().obs;

    var todayNetProfit = 0.0.obs;//ajker nit lav
    var totalInventoryValue = 0.0.obs;//mot inventory value(kena dame)
    var potentialProfit = 0.0.obs;//somvabbo mot lav
    var todaySoldItems = 0.obs;//bikrito items songkha

    @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchReportData();
  }

  //date change hole data refresh hobe
  void updateDate(DateTime date){
      selectedDate.value = date;
      fetchReportData();
  }

  Future<void> fetchReportData()async{
      try{
        isLoading(true);
        String dateStr = DateFormat('yyyy-MM-dd').format(selectedDate.value);
        //fetching today sold data for the net profit and sold items
        var salesSnapshot = await _firestore.collection('sales')
                                  .where('date',isEqualTo: dateStr)
                                  .get();

        //fetching all the products data
        var productSnapshot = await _firestore.collection('products').get();
        calculateMetrics(salesSnapshot.docs, productSnapshot.docs);


      }finally{
        isLoading(false);
      }
  }

  void calculateMetrics(List<DocumentSnapshot> sales, List<DocumentSnapshot> products){
      double netProfit = 0.0;
      int soldCount = 0;
      double inventoryVal = 0.0;
      double potential = 0.0;
      
      for(var doc in sales){
        double totalSale = double.tryParse(doc['totalPrice'].toString()) ?? 0.0;
        double totalCost = double.tryParse(doc['totalPurchasePrice'].toString()) ?? 0.0;
        int qty = int.tryParse(doc['totalQuantity'].toString()) ?? 1;

        netProfit += (totalSale - totalCost);
        soldCount += qty;
      }
  }


}