import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../consts/constants.dart';
import '../services/utils.dart';
import 'products_widget.dart';
import 'text_widget.dart';

class ProductGridWidget extends StatelessWidget {
  const ProductGridWidget(
      {Key? key,
        this.crossAxisCount = 6,
        this.childAspectRatio = 1,
        this.isInMain = true})
      : super(key: key);
  final int crossAxisCount;
  final double childAspectRatio;
  final bool isInMain;
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    return StreamBuilder<QuerySnapshot>(
      //there was a null error just add those lines
      stream: FirebaseFirestore.instance.collection('products').snapshots(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(18.0),
                child: Text('Chưa có mặt hàng nào'),
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Lỗi không xác định vui lòng thử lại',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            );
          }
        }
        return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: isInMain && snapshot.data!.docs.length > 5
                ? 5
                : snapshot.data!.docs.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,

            ),
            itemBuilder: (context, index) {
              return ProductWidget(
                id: snapshot.data!.docs[index]['id'],
              );
            });
      },
    );
  }
}