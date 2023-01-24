import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duit_flutter/models.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'account.dart';
import 'home.dart';
import 'main.dart';

class Admin extends StatefulWidget {
  @override
  State<Admin> createState() => AdminState();
}

class AdminState extends State<Admin> {
  var isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DUIT-Admin'), actions: <Widget>[]),
      body: Center(
        child: Column(children: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProduct()),
                );
              },
              child: Text('Add Product'))
        ]),
      ),
    );
  }
}

class AddProduct extends StatefulWidget {
  @override
  State<AddProduct> createState() => AddProductState();
}

class AddProductState extends State<AddProduct> {
  var isLoading = false;
  final prdName = TextEditingController();
  final prdDesc = TextEditingController();
  final prdPrice = TextEditingController();
  final prdQty = TextEditingController();
  final prdCode = TextEditingController();
  final category1 = TextEditingController();
  final category2 = TextEditingController();
  late FilePickerResult pfResult;
  var downloadURL = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DUIT-Admin'), actions: <Widget>[]),
      body: Center(
          child: !isLoading
              ? SingleChildScrollView(
                  child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Add Product'),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: category1,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Category 1',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: category2,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Category 2',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: prdCode,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Product Code',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: prdName,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Product Name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: prdDesc,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Product Description',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: prdPrice,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Product Price',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: prdQty,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Product Quantity',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          pfResult = (await FilePicker.platform.pickFiles(
                            type: FileType.image,
                          ))!;
                        },
                        child: Text('Upload Files'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });

                          if (pfResult != null) {
                            Uint8List? fileBytes = pfResult.files.first.bytes;
                            String fileName = pfResult.files.first.name;

                            // Upload file
                            final storageRef = storage.ref();
                            Reference photoRef =
                                storageRef.child("prd_upload/$fileName");

                            await photoRef.putData(fileBytes!);
                            downloadURL = await photoRef.getDownloadURL();
                            log(downloadURL);

                            final product = <String, dynamic>{
                              "Code": prdCode.text,
                              "Name": prdName.text,
                              "Description": prdDesc.text,
                              "Price": prdPrice.text,
                              "Quantity": prdQty.text,
                              "Category1": category1.text,
                              "Category2": category2.text,
                              "ThumbnailURL": downloadURL
                            };

                            db.collection("Product").add(product).then(
                                (DocumentReference doc) => print(
                                    'DocumentSnapshot added with ID: ${doc.id}'));

                            setState(() {
                              isLoading = false;
                            });

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Home()),
                            );

                            /* final product = Product(
                                Code: prdCode.text,
                                Name: prdName.text,
                                Description: prdDesc.text,
                                Price: int.parse(prdPrice.text),
                                Quantity: int.parse(prdQty.text),
                                Category1: category1.text,
                                Category2: category2.text,
                                ThumbnailURL: downloadURL);

                            final docRef = db
                                .collection("Product")
                                .withConverter(
                                  fromFirestore: Product.fromFirestore,
                                  toFirestore: (Product prd, options) =>
                                      prd.toFirestore(),
                                )
                                .doc();

                            await docRef.set(product); */

                          }
                        },
                        child: Text('Add Product'),
                      ),
                    ],
                  ),
                ))
              : CircularProgressIndicator()),
    );
  }
}
