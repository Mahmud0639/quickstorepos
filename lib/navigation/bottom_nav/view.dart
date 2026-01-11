/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_store_pos/modules/add_product/add_product_view.dart';
import 'package:quick_store_pos/modules/billing/billing_view.dart';
import 'package:quick_store_pos/modules/home/home_view.dart';
import 'package:quick_store_pos/modules/inventory/view.dart';
import 'package:quick_store_pos/modules/sales/sales_history/view.dart';
import 'package:quick_store_pos/modules/sales/view.dart';
import 'package:quick_store_pos/navigation/bottom_nav/controller.dart';

class MainNavigationView extends GetView<MainNavigationController> {
  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeView(),         // Index 0: ড্যাশবোর্ড
      const InventoryView(),    // Index 1: ইনভেন্টরি লিস্ট ও স্টক
      const SalesView(),      // Index 2: মেইন বিক্রি বা বিলিং করার পেজ
      const SalesHistoryView(), // Index 3: পুরনো সব বিক্রির লিস্ট
      const Center(child: Text("Report"),),
    ];

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 600;

          return Obx(

            () {

              bool isSalePage = controller.selectedIndex.value == 2;

              return Row(
                children: [
                  if (isDesktop) _buildNavigationRail(),
                  if (isDesktop) const VerticalDivider(thickness: 1, width: 1),
                  Expanded(child: pages[controller.selectedIndex.value]),
                ],
              );
            }
          );
        },
      ),

      floatingActionButton: context.width <= 600 ? _buildMobileFAB() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: context.width <= 600
          ? _buildMobileBottomBar()
          : null,
    );
  }

  Widget _buildNavigationRail() {
    return NavigationRail(
      onDestinationSelected: controller.changePage,
      backgroundColor: Colors.white,
      leading: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: FloatingActionButton(
          onPressed: () => controller.changePage(2),
          child: Icon(Icons.add_shopping_cart, size: 24.sp),
        ),
      ),
      destinations: [
        _railItem(Icons.dashboard_rounded, "ড্যাশবোর্ড"),
        _railItem(Icons.inventory_2_rounded, "ইনভেন্টরি"),
        _railItem(Icons.history_rounded, "হিস্ট্রি"),
        _railItem(Icons.bar_chart_rounded, "রিপোর্ট"),
      ],
      selectedIndex: controller.selectedIndex.value,
    );
  }

  NavigationRailDestination _railItem(IconData icon, String label) {
    return NavigationRailDestination(
      icon: Tooltip(
        message: label,
        child: _HoverIcon(icon: icon),
      ),
      selectedIcon: Icon(icon, color: Colors.blue, size: 28.sp),
      label: Text(label),
    );
  }

  Widget _buildMobileBottomBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.r,
      child: Container(
        height: 60.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomBtn(Icons.dashboard, 0),
            _bottomBtn(Icons.inventory_2, 1),
            SizedBox(width: 40.w),
            _bottomBtn(Icons.history, 3),
            _bottomBtn(Icons.bar_chart, 4),
          ],
        ),
      ),
    );
  }

  Widget _bottomBtn(IconData icon, int index) {
    return Obx(
      () => IconButton(
        onPressed: () => controller.changePage(index),
        icon: Icon(
          icon,
          size: 24,
          color: controller.selectedIndex.value == index
              ? Colors.blue
              : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildMobileFAB() {
    return FloatingActionButton(
      onPressed: () => controller.changePage(2),
      backgroundColor: Colors.blue,
      child: Icon(Icons.add_shopping_cart, color: Colors.white, size: 24.sp),
    );
  }
}

class _HoverIcon extends StatefulWidget {
  final IconData icon;

  const _HoverIcon({super.key, required this.icon});

  @override
  State<_HoverIcon> createState() => _HoverIconState();
}

class _HoverIconState extends State<_HoverIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() {
        _isHovered = true;
      }),
      onExit: (_) => setState(() {
        _isHovered = false;
      }),

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _isHovered
            ? (Matrix4.identity()..translate(0, -5))
            : Matrix4.identity(),
      child: Icon(
        widget.icon,
        size: _isHovered ? 28.sp : 24.sp,
        color: _isHovered ? Colors.blue : Colors.grey,
      ),
      ),
      
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_store_pos/modules/home/home_view.dart';
import 'package:quick_store_pos/modules/inventory/view.dart';
import 'package:quick_store_pos/modules/report/view.dart';
import 'package:quick_store_pos/modules/sales/sales_history/view.dart';
import 'package:quick_store_pos/modules/sales/view.dart';
import 'package:quick_store_pos/navigation/bottom_nav/controller.dart';

class MainNavigationView extends GetView<MainNavigationController> {
  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      //const HomeView(),
      const ReportView(),
      const InventoryView(),
      const SalesView(),
      const SalesHistoryView(),
      const Center(child: Text("Report")),
    ];

    return Obx(() {

      bool isSalePage = controller.selectedIndex.value == 2;
      bool isDesktop = context.width > 600;

      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result){
          if(didPop) return;
          if(controller.selectedIndex.value != 0){
            controller.changePage(0);
          }else{
            SystemNavigator.pop();
          }
        },
        child: Scaffold(
          body: Row(
            children: [
             // if (isDesktop && !isSalePage) _buildNavigationRail(),
              if(isDesktop && !isSalePage) SizedBox(width: 80.w,child: _buildNavigationRail(),),
              if (isDesktop && !isSalePage) const VerticalDivider(thickness: 1, width: 1),

              Expanded(child: pages[controller.selectedIndex.value]),
            ],
          ),

          floatingActionButton: (context.width <= 600 && !isSalePage)
              ? _buildMobileFAB()
              : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

          bottomNavigationBar: (context.width <= 600 && !isSalePage)
              ? _buildMobileBottomBar()
              : null,
        ),
      );
    });
  }

  Widget _buildNavigationRail() {
    return NavigationRail(
      onDestinationSelected: controller.changePage,
      backgroundColor: Colors.white,
      selectedIndex: controller.selectedIndex.value,
      leading: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: FloatingActionButton(
          onPressed: () => controller.changePage(2),
          shape: const CircleBorder(),
          child: Icon(Icons.add_shopping_cart, size: 24.sp),
        ),
      ),
      destinations: [
        _railItem(Icons.dashboard_rounded, "ড্যাশবোর্ড"),
        _railItem(Icons.inventory_2_rounded, "ইনভেন্টরি"),
        _railItem(Icons.history_rounded, "হিস্ট্রি"),
        _railItem(Icons.bar_chart_rounded, "রিপোর্ট"),
      ],
    );
  }

  NavigationRailDestination _railItem(IconData icon, String label) {
    return NavigationRailDestination(
      icon: Tooltip(
        message: label,
        child: _HoverIcon(icon: icon),
      ),
      selectedIcon: Icon(icon, color: Colors.blue, size: 28.sp),
      label: Text(label),
    );
  }

  Widget _buildMobileBottomBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.r,
      child: SizedBox(
        height: 60.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomBtn(Icons.dashboard, 0),
            _bottomBtn(Icons.inventory_2, 1),
            SizedBox(width: 40.w),
            _bottomBtn(Icons.history, 3),
            _bottomBtn(Icons.bar_chart, 4),
          ],
        ),
      ),
    );
  }

  Widget _bottomBtn(IconData icon, int index) {
    return IconButton(
      onPressed: () => controller.changePage(index),
      icon: Icon(
        icon,
        size: 24.sp,
        color: controller.selectedIndex.value == index ? Colors.blue : Colors.grey,
      ),
    );
  }

  Widget _buildMobileFAB() {
    return FloatingActionButton(
      onPressed: () => controller.changePage(2),
      shape: const CircleBorder(),
      backgroundColor: Colors.blue,
      child: Icon(Icons.add_shopping_cart, color: Colors.white, size: 24.sp),
    );
  }
}

class _HoverIcon extends StatefulWidget {
  final IconData icon;
  const _HoverIcon({super.key, required this.icon});

  @override
  State<_HoverIcon> createState() => _HoverIconState();
}

class _HoverIconState extends State<_HoverIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
      //  transform: _isHovered ? (Matrix4.identity()..translate(0, -5)) : Matrix4.identity(),
        transform: _isHovered ? Matrix4.translationValues(0, -5, 0) : Matrix4.translationValues(0, 0, 0),
        child: Icon(
          widget.icon,
          size: _isHovered ? 28.sp : 24.sp,
          color: _isHovered ? Colors.blue : Colors.grey,
        ),
      ),
    );
  }
}