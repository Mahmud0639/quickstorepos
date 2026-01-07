
import 'package:flutter/material.dart';
class InvoiceDesignWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final double width;

  const InvoiceDesignWidget({super.key, required this.data, required this.width});

  @override
  Widget build(BuildContext context) {
    final items = data['items'] as List;

    double baseFontSize = width < 350 ? 8 : 10;

    return IntrinsicHeight(
      child: Container(
        width: width,
        padding: EdgeInsets.all(width < 350 ? 8 : 15),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("আল এহেসান ট্রেডার্স",
                          style: TextStyle(fontSize: width < 350 ? 16 : 22, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
                      Text("সকল মালামাল খুচরা ও পাইকারী বিক্রেতা",
                          style: TextStyle(fontSize: baseFontSize - 1, color: Colors.black87)),
                      Text("মস্তফাপুর, মাদারীপুর।", style: TextStyle(fontSize: baseFontSize - 1)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("MEMO", style: TextStyle(fontSize: baseFontSize + 2, fontWeight: FontWeight.bold)),
                      Text("ID: ${data['saleId'].toString().substring(0, 5)}", style: TextStyle(fontSize: baseFontSize - 2)),
                      Text("${data['date']}", style: TextStyle(fontSize: baseFontSize - 2)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Divider(thickness: 1, color: Colors.blue.shade900),

            Container(
              color: Colors.blue.shade900,
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  Expanded(flex: 4, child: Text("পণ্য", style: TextStyle(color: Colors.white, fontSize: baseFontSize, fontWeight: FontWeight.bold))),
                  Expanded(flex: 1, child: Text("পরিমান", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: baseFontSize))),
                  Expanded(flex: 2, child: Text("মোট", textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontSize: baseFontSize))),
                ],
              ),
            ),

            // Item List
            ...items.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 0.5))),
                child: Row(
                  children: [
                    Expanded(flex: 4, child: Text("${item['name']}", style: TextStyle(fontSize: baseFontSize))),
                    Expanded(flex: 1, child: Text("${item['quantity']}", textAlign: TextAlign.center, style: TextStyle(fontSize: baseFontSize))),
                    Expanded(flex: 2, child: Text("${(item['quantity'] * item['price']).toStringAsFixed(0)}", textAlign: TextAlign.right, style: TextStyle(fontSize: baseFontSize))),
                  ],
                ),
              );
            }).toList(),

            const SizedBox(height: 10),

            // Total Section
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("মোট আইটেম: ${data['totalQuantity']}", style: TextStyle(fontSize: baseFontSize)),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: Colors.blue.shade50,
                    child: Text(
                      "সর্বমোট: ৳${data['totalPrice']}",
                      style: TextStyle(fontSize: baseFontSize + 2, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}