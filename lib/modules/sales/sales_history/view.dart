import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_store_pos/modules/sales/sales_history/controller.dart';
import 'package:quick_store_pos/modules/sales/sales_history/widgets/invoice_list_item.dart';
import 'package:quick_store_pos/modules/sales/sales_history/widgets/sales_summary_header.dart';

class SalesHistoryView extends GetView<SalesHistoryController> {
  const SalesHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("বিক্রয় ইতিহাস (Sales History)"),
        actions: [
          IconButton(
            onPressed: () => _showDateRangePicker(context),
            icon: const Icon(Icons.calendar_month),
          ),
        ],
      ),

      body: Column(
        children: [
          //quick filter chips
          _buildQuickFilters(),
          Padding(padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
          child: TextField(
            onChanged: (value){
              controller.searchInvoice(value);
            },
            decoration: InputDecoration(
              hintText: "মেমো আইডি দিয়ে খুঁজুন...",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
              contentPadding: EdgeInsets.symmetric(vertical: 0)
            ),
          ),
          ),
          //summary card(total sell, invoice, profit)
          const SalesSummaryHeader(),
          const Divider(height: 1),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.filteredSalesList.isEmpty) {
                return const Center(
                  child: Text("এই সময়ে কোনো বিক্রয় পাওয়া যায়নি!"),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: controller.filteredSalesList.length,
                itemBuilder: (context, index) {
                  return InvoiceListItem(doc: controller.filteredSalesList[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFilters() {
    return Container(
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _filterChip("আজ (Today)", () {
            controller.updateDateRange(DateTime.now(), DateTime.now());
          }),
          _filterChip("গতকাল (Yesterday)", () {
            DateTime yesterday = DateTime.now().subtract(
              const Duration(days: 1),
            );
            controller.updateDateRange(yesterday, yesterday);
          }),
          _filterChip("শেষ ৭ দিন (7 Days)", () {
            DateTime weekAgo = DateTime.now().subtract(const Duration(days: 7));
            controller.updateDateRange(weekAgo, DateTime.now());
          }),
          _filterChip("এই মাস (This Month)", () {
            DateTime firstDay = DateTime(
              DateTime.now().year,
              DateTime.now().month,
              1,
            );
            controller.updateDateRange(firstDay, DateTime.now());
          }),
        ],
      ),
    );
  }

  Widget _filterChip(String label, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: ActionChip(
        label: Text(label),
        onPressed: onTap,
        backgroundColor: Colors.blue.shade50,
        labelStyle: TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2026),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: controller.startDate.value,
        end: controller.endDate.value,
      ),
    );
    if(picked != null){
      controller.updateDateRange(picked.start, picked.end);
    }
  }
}
