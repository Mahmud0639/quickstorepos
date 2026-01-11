import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quick_store_pos/modules/report/controller.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportView extends GetView<ReportController> {
  const ReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyHeaderDelegate(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() =>
                          Text(
                            controller.reportHeader,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[900],
                            ),
                          )),
                      IconButton(
                        onPressed: () async {
                          DateTimeRange? picked = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(2025),
                            lastDate: DateTime.now(),
                            initialDateRange: controller.selectedRange.value,
                            confirmText: "সিলেক্ট করুন",
                            saveText: "ডান",
                          );
                          if (picked != null) {
                            controller.updateDateRange(picked);
                          }
                        },
                        icon: Icon(Icons.calendar_month_rounded, color: Colors.blue, size: 28.sp),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [

                    _buildSummaryGrid(context),

                    SizedBox(height: 20.h), // কার্ড এবং লিস্টের মাঝে গ্যাপ

                    _buildSectionTitle("বিক্রয় বিশ্লেষণ (Sales Trend)"),
                    SizedBox(height: 10.h),
                    _buildLineChart(context),

                    SizedBox(height: 10.h),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  Widget _buildSummaryGrid(BuildContext context) {
    int crossAxisCount = MediaQuery.of(context).size.width > 600 ? 4 : 2;

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12.w,
        crossAxisSpacing: 12.w,
        crossAxisCount: crossAxisCount,
        childAspectRatio: MediaQuery.of(context).size.width > 600 ? 2.5 : 1.3,
        children: [
          _reportCard(
              "মোট বিক্রি",
              "৳ ${controller.totalSales.value.toStringAsFixed(0)}",
              Icons.account_balance_wallet,
              Colors.blue,
                  () => Get.toNamed('/sales-history')
          ),
          _reportCard(
              "নিট লাভ",
              "৳ ${controller.netProfit.value.toStringAsFixed(0)}",
              Icons.trending_up,
              Colors.green,
                  () => Get.toNamed('/profit-details')
          ),
          _reportCard(
              "বিক্রিত আইটেম",
              "${controller.soldItemsCount.value} পিস",
              Icons.shopping_basket,
              Colors.orange,
                  () => Get.toNamed('/sold-items')
          ),
          _reportCard(
              "বকেয়া/বাকি",
              "৳ 0",
              Icons.assignment_late,
              Colors.red,
                  () => Get.toNamed('/due-list')
          ),
        ],
      );
    });
  }

  Widget _reportCard(String title, String value, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15.r),
      child: Container(
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4))
          ],
          border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.1),
              radius: 18.r,
              child: Icon(icon, color: color, size: 20.sp),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[600])),
                SizedBox(height: 4.h),
                Text(value, style: TextStyle(fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.blueGrey[900]),
    );
  }


  Widget _buildLineChart(BuildContext context) {
    return Obx(() {
      if (controller.chartData.isEmpty) {
        return Container(
          height: 200.h,
          alignment: Alignment.center,
          child: Text("এই রেঞ্জে কোনো ডাটা নেই", style: TextStyle(fontSize: 14.sp)),
        );
      }

      bool isSingleDay = controller.chartData.length == 1;
      double chartHeight = MediaQuery.of(context).size.width > 600 ? 350.h : 220.h;

      return Container(
        height: chartHeight,
        padding: EdgeInsets.fromLTRB(15.w, 25.h, 25.w, 15.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
        ),
        child: isSingleDay
            ? _buildSingleDayBar(controller.chartData.values.first, controller.chartData.keys.first) // একদিনের জন্য বার
            : _buildActualLineChart(), // একাধিক দিনের জন্য লাইন
      );
    });
  }

  Widget _buildSingleDayBar(double value, DateTime date) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(DateFormat('dd MMMM').format(date), style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
        SizedBox(height: 10.h),
        Expanded(
          child: Center(
            child: Container(
              width: 60.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blue.withValues(alpha: 0.5)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Text("৳ ${value.toStringAsFixed(0)}", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildActualLineChart() {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < controller.chartData.length) {
                  DateTime date = controller.chartData.keys.elementAt(index);
                  return Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(DateFormat('dd MMM').format(date), style: TextStyle(fontSize: 9.sp)),
                  );
                }
                return const Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: controller.chartData.values.toList().asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
            isCurved: true,
            color: Colors.blue,
            barWidth: 3.w,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(show: true, color: Colors.blue.withValues(alpha: 0.1)),
          ),
        ],
      ),
    );
  }


}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  double get maxExtent => 70.h;

  @override
  double get minExtent => 70.h;

  @override
  Widget build(BuildContext context, double shrinkOffset,
      bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }



}