import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:fashion_app_admin/consts/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../controllers/menucontroller.dart';
import '../provider/product_provider.dart';
import '../responsive.dart';

import '../screens/loading_manager.dart';
import '../services/global_method.dart';
import '../services/utils.dart';
import '../widgets/buttons.dart';
import '../widgets/header.dart';
import '../widgets/side_menu.dart';
import '../widgets/text_widget.dart';

class UploadProductForm extends StatefulWidget {
  static const routeName = '/UploadProductForm';

  const UploadProductForm({Key? key}) : super(key: key);

  @override
  _UploadProductFormState createState() => _UploadProductFormState();
}

class _UploadProductFormState extends State<UploadProductForm> {
  final _formKey = GlobalKey<FormState>();
  String _catValue = 'Áo Thun';
  String _sizeValue = 'S';
  String _colorValue = 'Xanh';
  late final TextEditingController _titleController, _priceController, _numberController;
  int _groupValue = 1;
  bool isPiece = false;
  File? _pickedImage;
  Uint8List webImage = Uint8List(8);
  String? imageUrl;
  var logger=Logger();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> productVariants = [];

  @override
  void initState() {
    _numberController= TextEditingController();
    _priceController = TextEditingController();
    _titleController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      _numberController.dispose();
      _priceController.dispose();
      _titleController.dispose();
    }
    super.dispose();
  }

  bool _isLoading = false;
  // void _addVariantToProductVariants() {
  //   var variant = {'size': _sizeValue, 'color': _colorValue};
  //   productVariants.add(variant);
  // }
  void _uploadForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    // _addVariantToProductVariants();
    if (isValid) {
      _formKey.currentState!.save();
      if (_pickedImage == null) {
        GlobalMethods.errorDialog(
            subtitle: 'Chọn ảnh sản phẩm', context: context);
        return;
      }
      final _uuid = const Uuid().v4();
      try {
        setState(() {
          _isLoading = true;
        });
        final ref = FirebaseStorage.instance
            .ref()
            .child('productsImages')
            .child('$_uuid.jpg');
        if (kIsWeb) {
          await ref.putData(webImage);
        } else {
          await ref.putFile(_pickedImage!);
        }
        imageUrl=await ref.getDownloadURL();
        await FirebaseFirestore.instance.collection('products').doc(_uuid).set({
          'id': _uuid,
          'title': _titleController.text,
          'price': _priceController.text,
          'number': _numberController.text,
          'salePrice': 0.1,
          'imageUrl': imageUrl,
          'productCategoryName': _catValue,
          'isOnSale': false,
          'isPiece': isPiece,
          'createdAt': Timestamp.now(),
          // 'variants': productVariants,
        });
        _clearForm();
        Fluttertoast.showToast(
          msg: "Product uploaded succefully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          // backgroundColor: ,
          // textColor: ,
          // fontSize: 16.0
        );
      } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(
            subtitle: '${error.message}', context: context);
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        GlobalMethods.errorDialog(subtitle: '$error', context: context);
        setState(() {
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _clearForm() {
    isPiece = false;
    _groupValue = 1;
    _priceController.clear();
    _titleController.clear();
    _numberController.clear();
    setState(() {
      _pickedImage = null;
      webImage = Uint8List(8);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = Utils(context).color;
    final _scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    Size size = Utils(context).getScreenSize;



    var inputDecoration = InputDecoration(
      filled: true,
      fillColor: _scaffoldColor,
      border: InputBorder.none,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 1.0,
        ),
      ),
    );
    return Scaffold(
      key: context.read<MenuControllers>().getAddProductscaffoldKey,
      drawer: const SideMenu(),
      body: LoadingManager(
        isLoading: _isLoading,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              const Expanded(
                child: SideMenu(),
              ),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Header(
                          fct: () {
                            context
                                .read<MenuControllers>()
                                .controlAddProductsMenu();
                          },
                          title: 'Thêm sản phẩm',
                          showTexField: false),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      width: size.width > 650 ? 650 : size.width,
                      // color: Theme.of(context).cardColor,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextWidget(
                              text: 'Tên sản phẩm *',
                              color: color,
                              isTitle: true,
                            ),
                            TextFormField(
                              controller: _titleController,
                              key: const ValueKey('Title'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Vui lòng nhập tên sản phẩm';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: _scaffoldColor, // Màu nền
                                border: OutlineInputBorder( // Đây là phần quan trọng để đặt đường viền
                                  borderSide: BorderSide(
                                    color: color, // Màu đường viền
                                    width: 1.0, // Độ rộng của đường viền
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder( // Đường viền khi ô input được focus
                                  borderSide: BorderSide(
                                    color: color, // Màu đường viền
                                    width: 1.0, // Độ rộng của đường viền
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: FittedBox(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        TextWidget(
                                          text: 'Số lượng \$*',
                                          color: color,
                                          isTitle: true,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: TextFormField(
                                            controller: _numberController,
                                            key: const ValueKey('Number \$'),
                                            keyboardType: TextInputType.number,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Vui lòng nhập số lượng';
                                              }
                                              return null;
                                            },
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[0-9.]')),
                                            ],
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: _scaffoldColor, // Màu nền
                                              border: OutlineInputBorder( // Đây là phần quan trọng để đặt đường viền
                                                borderSide: BorderSide(
                                                  color: color, // Màu đường viền
                                                  width: 1.0, // Độ rộng của đường viền
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder( // Đường viền khi ô input được focus
                                                borderSide: BorderSide(
                                                  color: color, // Màu đường viền
                                                  width: 1.0, // Độ rộng của đường viền
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextWidget(
                                          text: 'Giá \$*',
                                          color: color,
                                          isTitle: true,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: TextFormField(
                                            controller: _priceController,
                                            key: const ValueKey('Price \$'),
                                            keyboardType: TextInputType.number,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Vui lòng nhập giá cả';
                                              }
                                              return null;
                                            },
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[0-9.]')),
                                            ],
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: _scaffoldColor, // Màu nền
                                              border: OutlineInputBorder( // Đây là phần quan trọng để đặt đường viền
                                                borderSide: BorderSide(
                                                  color: color, // Màu đường viền
                                                  width: 1.0, // Độ rộng của đường viền
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder( // Đường viền khi ô input được focus
                                                borderSide: BorderSide(
                                                  color: color, // Màu đường viền
                                                  width: 1.0, // Độ rộng của đường viền
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        TextWidget(
                                          text: 'Danh mục*',
                                          color: color,
                                          isTitle: true,
                                        ),
                                        const SizedBox(height: 10),
                                        // Drop down menu code here
                                        _categoryDropDown(),
                                        // const SizedBox(
                                        //   height: 20,
                                        // ),
                                        // TextWidget(
                                        //   text: 'Màu sắc*',
                                        //   color: color,
                                        //   isTitle: true,
                                        // ),
                                        // const SizedBox(
                                        //   height: 10,
                                        // ),
                                        // _colorDropDown(),
                                        // const SizedBox(
                                        //   height: 20,
                                        // ),
                                        // TextWidget(
                                        //   text: 'Kích thước*',
                                        //   color: color,
                                        //   isTitle: true,
                                        // ),
                                        // const SizedBox(
                                        //   height: 10,
                                        // ),
                                        // _sizeDropDown(),
                                        // Radio button code here

                                      ],
                                    ),
                                  ),
                                ),
                                // Image to be picked code is here
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        height: size.width > 650
                                            ? 350
                                            : size.width * 0.45,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          borderRadius:
                                          BorderRadius.circular(12.0),
                                        ),
                                        child: _pickedImage == null
                                            ? dottedBorder(color: color)
                                            : ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(12),
                                          child: kIsWeb
                                              ? Image.memory(webImage,
                                              fit: BoxFit.fill)
                                              : Image.file(_pickedImage!,
                                              fit: BoxFit.fill),
                                        )),
                                  ),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: FittedBox(
                                      child: Column(
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                _pickedImage = null;
                                                webImage = Uint8List(8);
                                              });
                                            },
                                            child: TextWidget(
                                              text: 'Xóa ảnh',
                                              color: AppColor.subTextColor,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {},
                                            child: TextWidget(
                                              text: 'Cập nhật ảnh',
                                              color: AppColor.primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [
                                  ButtonsWidget(
                                    onPressed: _clearForm,
                                    text: 'Xóa',
                                    icon: IconlyBold.danger,
                                    backgroundColor: Colors.black12,
                                  ),
                                  ButtonsWidget(
                                    onPressed: () {
                                      _uploadForm();
                                    },
                                    text: 'Cập nhật',
                                    icon: IconlyBold.upload,
                                    backgroundColor: AppColor.primaryColor,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // void _loadCategoryList() async{
  //   FirebaseFirestore.instance.collection('category').get().then((querySnapshot) {
  //     querySnapshot.docs.forEach((doc) {
  //       String category = doc.data()['title'];
  //       setState(() {
  //         _categoryList.add(category);
  //       });
  //     });
  //   });
  // }


  Future<void> _pickImage() async {
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _pickedImage = selected;
        });
      } else {
        print('Không có ảnh nào được chọn');
      }
    } else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
          _pickedImage = File('a');
        });
      } else {
        print('Không có ảnh nào được chọn');
      }
    } else {
      print('Something went wrong');
    }
  }

  Widget dottedBorder({
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DottedBorder(
          dashPattern: const [6.7],
          borderType: BorderType.RRect,
          color: color,
          radius: const Radius.circular(12),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_outlined,
                  color: color,
                  size: 50,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: (() {
                      _pickImage();
                    }),
                    child: TextWidget(
                      text: 'Chọn ảnh',
                      color: AppColor.primaryColor,
                    ))
              ],
            ),
          )),
    );
  }
  Widget _categoryDropDown() {
    final color = Utils(context).color;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('category').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            List<DropdownMenuItem<String>> items = snapshot.data!.docs.map<DropdownMenuItem<String>>((doc) {
              return DropdownMenuItem<String>(
                child: Text(
                  doc['title'],
                ),
                value: doc['title'],
              );
            }).toList();

            return DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
                value: _catValue,
                onChanged: (value) {
                  setState(() {
                    _catValue = value!;
                  });
                  print(_catValue);
                },
                hint: const Text('Chọn danh mục'),
                items: items,
              ),
            );
          },
        ),
      ),
    );
  }

  // Widget _sizeDropDown() {
  //   final color = Utils(context).color;
  //   return Container(
  //     color: Theme.of(context).scaffoldBackgroundColor,
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: DropdownButtonHideUnderline(
  //           child: DropdownButton<String>(
  //             style: TextStyle(
  //               color: color,
  //               fontWeight: FontWeight.w600,
  //               fontSize: 18,
  //             ),
  //             value: _sizeValue,
  //             onChanged: (value) {
  //               setState(() {
  //                 _sizeValue = value!;
  //               });
  //               print(_sizeValue);
  //             },
  //             hint: const Text('Chọn kích thước'),
  //             items: const [
  //               DropdownMenuItem(
  //                 child: Text(
  //                   'S',
  //                 ),
  //                 value: 'S',
  //               ),
  //               DropdownMenuItem(
  //                 child: Text(
  //                   'M',
  //                 ),
  //                 value: 'M',
  //               ),
  //               DropdownMenuItem(
  //                 child: Text(
  //                   'L',
  //                 ),
  //                 value: 'L',
  //               ),
  //               DropdownMenuItem(
  //                 child: Text(
  //                   'XL',
  //                 ),
  //                 value: 'XL',
  //               ),
  //             ],
  //           )),
  //     ),
  //   );
  // }
  // Widget _colorDropDown() {
  //   final color = Utils(context).color;
  //   return Container(
  //     color: Theme.of(context).scaffoldBackgroundColor,
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: DropdownButtonHideUnderline(
  //           child: DropdownButton<String>(
  //             style: TextStyle(
  //               color: color,
  //               fontWeight: FontWeight.w600,
  //               fontSize: 18,
  //             ),
  //             value: _colorValue,
  //             onChanged: (value) {
  //               setState(() {
  //                 _colorValue = value!;
  //               });
  //               print(_colorValue);
  //             },
  //             hint: const Text('Chọn màu sắc'),
  //             items: const [
  //               DropdownMenuItem(
  //                 child: Text(
  //                   'Xanh',
  //                 ),
  //                 value: 'Xanh',
  //               ),
  //               DropdownMenuItem(
  //                 child: Text(
  //                   'Đỏ',
  //                 ),
  //                 value: 'Đỏ',
  //               ),
  //               DropdownMenuItem(
  //                 child: Text(
  //                   'Tím',
  //                 ),
  //                 value: 'Tím',
  //               ),
  //               DropdownMenuItem(
  //                 child: Text(
  //                   'Vàng',
  //                 ),
  //                 value: 'Vàng',
  //               ),
  //               DropdownMenuItem(
  //                 child: Text(
  //                   'Hồng',
  //                 ),
  //                 value: 'Hồng',
  //               ),
  //               DropdownMenuItem(
  //                 child: Text(
  //                   'Cam',
  //                 ),
  //                 value: 'Cam',
  //               )
  //             ],
  //           )),
  //     ),
  //   );
  // }

}