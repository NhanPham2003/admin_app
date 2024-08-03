import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


import '../services/utils.dart';
import 'text_widget.dart';

class UserWidget extends StatefulWidget {
  const UserWidget(
      {Key? key,
        required this.imageUrl, required this.name, required this.email, required this.address,
      })
      : super(key: key);
  final String name, email, imageUrl, address;
  @override
  _UserWidgetState createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  late String orderDateStr;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    Color color = theme == true ? Colors.white : Colors.black;
    Size size = Utils(context).getScreenSize;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        color: Theme.of(context).cardColor.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: size.width < 650 ? 3 : 1,
                child: Image.network(
                  widget.imageUrl,

                  fit: BoxFit.fill,
                  // height: screenWidth * 0.15,
                  // width: screenWidth * 0.15,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextWidget(
                      text:
                      'Tên Đăng Nhập: ${widget.name}',
                      color: color,
                      textSize: 16,
                      isTitle: true,
                    ),
                    TextWidget(
                      text:
                      'Email: ${widget.email}',
                      color: color,
                      textSize: 16,
                      isTitle: true,
                    ),
                    TextWidget(
                      text:
                      'Địa chỉ: ${widget.name}',
                      color: color,
                      textSize: 16,
                      isTitle: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}