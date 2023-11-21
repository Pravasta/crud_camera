import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:latihan_crud/db/database.dart';
import 'package:latihan_crud/model/db_model.dart';
import 'package:latihan_crud/shared/constant.dart';
import 'package:latihan_crud/shared/style.dart';
import 'package:latihan_crud/view/add_product_page.dart';
import 'package:latihan_crud/view/edit_product_page.dart';

import '../shared/string_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final db = DatabaseInstance();

  @override
  void initState() {
    db.database();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    data({required List<DbModel> item}) {
      return ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: item.length,
        itemBuilder: (context, index) {
          final items = item[index];

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProductPage(
                    data: items,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    child: items.image == ''
                        ? Image.asset(
                            ConstantItem.noProfile,
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(items.image),
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          items.name,
                          style: AppTextStyle.style,
                        ),
                        Text(
                          'Rp. ${formatNumber(items.price.toDouble())}',
                          style: AppTextStyle.style.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        db.delete(items.id);
                      });
                    },
                    icon: const Icon(Icons.delete_forever_outlined),
                  ),
                ],
              ),
            ),
          )
              .animate()
              .moveX(
                begin: index % 2 == 0 ? -100 : 100,
                duration: 800.ms,
              )
              .fadeIn(
                duration: 800.ms,
              );
        },
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Latihan CRUD',
            style: AppTextStyle.style,
          ),
        ),
        body: FutureBuilder<List<DbModel>>(
          future: db.getAllProduct(),
          builder: (context, snapshot) {
            final item = snapshot.data;

            if (snapshot.hasData) {
              if (item!.isEmpty) {
                return const Center(
                  child: Text('Data Masih Kosong'),
                );
              }
              return data(
                item: item,
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddProductPage(),
              ),
            ).then((value) {
              setState(() {});
            });
          },
          child: const Icon(Icons.add),
        ));
  }
}
