import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesController extends GetxController{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var cartItems = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  //scanner and focus control
  final TextEditingController barcodeController = TextEditingController();
  final FocusNode barcodeFocusNode = FocusNode();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_)=>barcodeFocusNode.requestFocus());
  }
  
  //adding products in cart with searching or scanning
  void addToCart(DocumentSnapshot doc){
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    int availableStock = int.tryParse(data['stock']?.toString() ?? '0') ?? 0;
    
    if(availableStock <= 0){
      Get.snackbar("স্টক শেষ", "এই পণ্যটি বর্তমানে স্টকে নেই!",backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    int index = cartItems.indexWhere((item)=>item['id'] == doc.id);

    if(index != -1){
      incrementQuantity(index, availableStock);
    }else{
      cartItems.add({
        'id' : doc.id,
        'name' : data['name'] ?? 'Unknown',
        'category' : data['category'] ?? 'Uncategorized',
        'price' : double.tryParse(data['price']?.toString() ?? '0.0') ?? 0.0,
        'purchasePrice' : double.tryParse(data['purchasePrice']?.toString() ?? '0.0') ?? 0.0,
        'quantity' : 1,
        'maxStock' : availableStock,
      });
      
      Get.snackbar("সফল", "পণ্যটি ঝুড়িতে যোগ হয়েছে", snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 1));
      
    }

  }

  //searching a product using barcode
  Future<void> onBarcodeScanned(String code)async{
    if(code.isEmpty) return;
    isLoading(true);
    try{
      var snapshot = await _firestore.collection('products').where('barcode',isEqualTo: code.trim())
          .limit(1)
          .get();
      if(snapshot.docs.isNotEmpty){
        addToCart(snapshot.docs.first);
        barcodeController.clear();//clear all barcode code from the search bar after search
        barcodeFocusNode.requestFocus();//again ready to scan barcode
      }
    }catch(e){
      Get.snackbar("Error", "কিঞ্চিৎ সমস্যা হয়েছে: $e");
    }finally{
      isLoading(false);
    }
  }
  
  //confirm sale
  Future<void> confirmSale()async{
    if(cartItems.isEmpty) return;
    
    try{
      isLoading(true);
      WriteBatch batch = _firestore.batch();
      String saleId = _firestore.collection('sales').doc().id;

      DateTime now = DateTime.now();
      String formattedDate = "${now.year}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')}";

      //sales date creating
      DocumentReference saleRef = _firestore.collection('sales').doc(saleId);
      batch.set(saleRef, {
        'saleId' : saleId,
        'items' : cartItems.toList(),
        'totalPrice' : totalAmount,
        'totalPurchasePrice' : totalPurchaseCost,
        'totalQuantity' : totalItemsCount,
        'date' : formattedDate,
        'timestamp' : FieldValue.serverTimestamp(),
      });

      //inventory stock update
      for(var item in cartItems){
        DocumentReference productRef = _firestore.collection('products').doc(item['id']);
        batch.update(productRef, {
          'stock': FieldValue.increment(-item['quantity']),
        });
      }
      
      //final submit
      await batch.commit();
      
      cartItems.clear();
      Get.back();
      Get.snackbar("সফল", "পণ্যটি সফলভাবে বিক্রি হয়েছে!",backgroundColor: Colors.green,colorText: Colors.white);
      barcodeFocusNode.requestFocus();
      
    }catch(e){
      Get.snackbar("Error", "বিক্রি সম্পন্ন করা যায়নি: $e");
    }finally{
      isLoading(false);
    }
  }
  
  //increasing amount(+) - stock check
  void incrementQuantity(int index, int maxStock){
    if(cartItems[index]['quantity'] < maxStock){
      cartItems[index]['quantity']++;
      cartItems.refresh();//to inform the Getx that data changed
    }else{
      Get.snackbar("লিমিট শেষ", "স্টকে আর মাল নেই!",backgroundColor: Colors.orange, colorText: Colors.white);
    }
  }

  //decrement amount(-) - (-1) won't go below
  void decrementQuantity(int index){
    if(cartItems[index]['quantity'] > 1){
      cartItems[index]['quantity']--;
      cartItems.refresh();
    }else{
      removeFromCart(index);
    }
  }
  
  //item remove from cart
void removeFromCart(int index){
    cartItems.removeAt(index);
    Get.snackbar("রিমুভ", "আইটেমটি কার্ট থেকে রিমুভ করা হয়েছে", snackPosition: SnackPosition.BOTTOM);
}

//total counting amount tk
double get totalAmount => cartItems.fold(0, (sum,item) => sum + (item['price'] * item['quantity']));
  //total how much profit can be come
double get totalPurchaseCost => cartItems.fold(0, (sum, item) => sum + (item['purchasePrice'] * item['quantity']));

//total how much products
int get totalItemsCount => cartItems.fold(0, (sum, item)=> sum + (item['quantity'] as int));

@override
  void onClose() {
    // TODO: implement onClose
  barcodeController.dispose();
  barcodeFocusNode.dispose();
    super.onClose();
  }







}