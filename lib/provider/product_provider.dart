import 'package:flutter/widgets.dart';

class ProductProvider with ChangeNotifier {
  Map<String, dynamic> productData = {};

  getFormData(
      {String? productName,
        int? productPrice,
        int? productQuantity,
        String? productDescription,
        String? category,
        DateTime? scheduleTime,
        List<String>? imageUrlList}) {
    if (category != null) {
      productData['category'] = category;
    }
    notifyListeners();
  }

  clearData() {
    productData.clear();
    notifyListeners();
  }
}
