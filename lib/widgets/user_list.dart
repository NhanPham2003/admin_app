import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_app_admin/widgets/users_widget.dart';
import 'package:flutter/material.dart';

import '../consts/constants.dart';
import 'orders_widget.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key, this.isInDashboard = true}) : super(key: key);
  final bool isInDashboard;

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      //there was a null error just add those lines
      stream: FirebaseFirestore.instance.collection('users').snapshots(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data!.docs.isNotEmpty) {
            return Container(
              padding: const EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.isInDashboard && snapshot.data!.docs.length > 4
                      ? 4
                      : snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) {
                    return Column(
                      children: [
                        UserWidget(imageUrl: 'https://yt3.googleusercontent.com/ytc/APkrFKaD8t4oFlgXcZKoW512Z81CBJuej3K9uHAlSI0x=s900-c-k-c0x00ffffff-no-rj',
                            name: snapshot.data!.docs[index]['name'],
                            email: snapshot.data!.docs[index]['email'],
                            address: snapshot.data!.docs[index]['shipping-address']),
                        const Divider(
                          thickness: 3,
                        ),
                      ],
                    );
                  }),
            );
          } else {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(18.0),
                child: Text('Your store is empty'),
              ),
            );
          }
        }
        return const Center(
          child: Text(
            'Something went wrong',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        );
      },
    );
  }
}