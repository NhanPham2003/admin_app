import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_app_admin/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';


import '../inner_screen/edit_prod.dart';
import '../services/global_method.dart';
import '../services/utils.dart';
import 'text_widget.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({
    Key? key,
    required this.id,
  }) : super(key: key);
  final String id;
  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  String title = '';
  String productCat = '';
  String? imageUrl;
  String price = '0.0';
  String number='';
  double salePrice = 0.0;
  bool isOnSale = false;
  bool isPiece = false;
  double priceInt=0.0;
  var formatter = NumberFormat('###,###,###');
  @override
  void initState() {
    getProductsData();

    super.initState();
  }

  Future<void> getProductsData() async {
    try {
      final DocumentSnapshot productsDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.id)
          .get();
      if (productsDoc == null) {
        return;
      } else {
        // Add if mounted here
        if (mounted) {
          setState(() {
            title = productsDoc.get('title');
            productCat = productsDoc.get('productCategoryName');
            imageUrl = productsDoc.get('imageUrl');
            price = productsDoc.get('price');
            number = productsDoc.get('number');
            salePrice = productsDoc.get('salePrice');
            isOnSale = productsDoc.get('isOnSale');
            isPiece = productsDoc.get('isPiece');
            priceInt=double.parse(price);
          });
        }
      }
    } catch (error) {
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final color = Utils(context).color;
    final colorSub = Utils(context).colorSub;
    final colorSale = Utils(context).colorSale;
    final colorCard = Utils(context).colorCard;
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(12),
        color: colorCard,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditProductScreen(
                  id: widget.id,
                  title: title,
                  price: price,
                  salePrice: salePrice,
                  productCat: productCat,
                  imageUrl: imageUrl == null
                      ? 'https://yt3.googleusercontent.com/ytc/APkrFKaD8t4oFlgXcZKoW512Z81CBJuej3K9uHAlSI0x=s900-c-k-c0x00ffffff-no-rj'
                      : imageUrl!,
                  isOnSale: isOnSale,
                  isPiece: isPiece, number: number,
                ),
              ),
            );
          },
          child: Stack(
            children: [
            Stack(
              children: [
                Container(
                  width: size.width,

                  child: Image.network(
                    imageUrl == null
                        ? 'https://yt3.googleusercontent.com/ytc/APkrFKaD8t4oFlgXcZKoW512Z81CBJuej3K9uHAlSI0x=s900-c-k-c0x00ffffff-no-rj'
                        : imageUrl!,
                    fit: BoxFit.contain,
                  ),
                ),

                Positioned(
                  right: 0,
                  child: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: () {
                            deleteProduct(widget.id);
                          },
                          child: const Text(
                            'Xóa',
                            style: TextStyle(color: Colors.red),
                          ),
                          value: 2,
                        ),
                      ]),
                ),

              ],
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 3,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  TextWidget(
                    text: title,
                    color: color,
                    textSize: 20,
                    isTitle: true,
                  ),
                  TextWidget(
                    text: isOnSale
                        ? '₫${formatter.format(salePrice)}'
                        : '₫${formatter.format(priceInt)}',
                    color: colorSub,
                    textSize: 18,
                  ),
                  const SizedBox(
                    width: 7,
                  ),

                  Visibility(
                      visible: isOnSale,
                      child: Text(
                        '₫${formatter.format(priceInt)}',
                        style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: colorSale),
                      )),
                  Visibility(
                      visible: isOnSale==false,
                      child: Text(
                        '₫0',
                        style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: colorSale),
                      )),
                ],
              ),
            ),
          ]
          ),
        ),
      ),
    );
  }
  // Hàm để xóa dữ liệu
  void deleteProduct(String id) async {
    try {
      // Thực hiện xóa dữ liệu từ Firestore hoặc nơi lưu trữ dữ liệu
      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.id)
          .delete();

      Fluttertoast.showToast(
        msg: 'Đã xóa sản phẩm thành công',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        // textColor: Colors.white,
        // fontSize: 16.0,
      );

      setState(() {
        getProductsData();
      });
    } catch (error) {

      Fluttertoast.showToast(
        msg: 'Xóa sản phẩm không thành công: $error',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        // fontSize: 16.0,
      );
    }
  }
}