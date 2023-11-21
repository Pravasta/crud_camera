import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/image_provider.dart';
import 'package:latihan_crud/db/database.dart';
import 'package:latihan_crud/model/db_model.dart';
import 'package:latihan_crud/shared/constant.dart';
import 'package:latihan_crud/shared/style.dart';
import 'package:latihan_crud/view/home_page.dart';
import 'package:latihan_crud/widget/text_field_widget.dart';

class EditProductPage extends StatefulWidget {
  const EditProductPage({super.key, required this.data});

  final DbModel data;

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DatabaseInstance db = DatabaseInstance();
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    db.database();
    nameController.text = widget.data.name;
    priceController.text = widget.data.price.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ImageController>();

    Widget button({
      required String title,
      Color backgroundColor = Colors.amber,
      Color colorText = Colors.black,
      required Function()? onTap,
    }) {
      return InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: backgroundColor,
          ),
          child: Center(
            child: Text(
              title,
              style: AppTextStyle.style.copyWith(color: colorText),
            ),
          ),
        ),
      );
    }

    Widget image() {
      return GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                padding: const EdgeInsets.all(15),
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: button(
                        title: 'From Gallery',
                        onTap: () {
                          controller.onGalleryView();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: button(
                        title: 'From Camera',
                        backgroundColor: Colors.blueGrey,
                        colorText: Colors.white,
                        onTap: () {
                          controller.onCameraView();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.withOpacity(0.1),
          ),
          child: widget.data.image != '' && controller.imagePath == null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(widget.data.image),
                    fit: BoxFit.cover,
                  ),
                )
              : controller.imagePath == null
                  ? Image.asset(ConstantItem.noProfile)
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(controller.imagePath.toString()),
                        fit: BoxFit.cover,
                      ),
                    ),
        ),
      );
    }

    Widget fieldText() {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFieldWidget(
                label: 'Nama',
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFieldWidget(
                label: 'Harga',
                controller: priceController,
                textInputType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    }

    Widget buttonSubmit() {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: const Size(double.infinity, 55),
            backgroundColor: Colors.amber,
            foregroundColor: Colors.blueGrey),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            setState(() {
              isLoading = true;
            });

            final navigator = Navigator.of(context);
            await db.update(
              widget.data.id,
              {
                'image': controller.imagePath == null
                    ? widget.data.image
                    : controller.imagePath.toString(),
                'name': nameController.text,
                'price': priceController.text,
                'updated_at': DateTime.now().toIso8601String(),
              },
            );

            // Kalau pakai ini tambahin then di move page sebelum ini
            // navigator.pop();

            await Future.delayed(
              const Duration(seconds: 2),
              () {
                controller.toEmptyImage();

                navigator.pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                  (route) => false,
                );
                db.getAllProduct();
              },
            );

            setState(() {
              isLoading = false;
            });
          }
        },
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                'Change Product',
                style: AppTextStyle.style.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Product',
          style: AppTextStyle.style,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            image(),
            fieldText(),
            buttonSubmit(),
          ],
        ),
      ),
    );
  }
}
