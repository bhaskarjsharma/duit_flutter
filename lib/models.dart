import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
part 'models.g.dart';

class Product {
  final String Code;
  final String Name;
  final String Description;
  final int Price;
  final int Quantity;
  final String Category1;
  final String Category2;
  final String ThumbnailURL;

  Product({
    required this.Code,
    required this.Name,
    required this.Description,
    required this.Price,
    required this.Quantity,
    required this.Category1,
    required this.Category2,
    required this.ThumbnailURL,
  });

/*   factory Product.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return Product(
      Code: data!['Code'],
      Name: data!['Name'],
      Description: data!['Description'],
      Price: data!['Price'],
      Quantity: data!['Quantity'],
      Category1: data!['Category1'],
      Category2: data!['Category2'],
      ThumbnailURL: data!['ThumbnailURL'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (Code != null) "Code": Code,
      if (Name != null) "Name": Name,
      if (Description != null) "Description": Description,
      if (Price != null) "Price": Price,
      if (Quantity != null) "Quantity": Quantity,
      if (Category1 != null) "Category1": Category1,
      if (Category2 != null) "Category2": Category2,
      if (ThumbnailURL != null) "ThumbnailURL": ThumbnailURL,
    };
  } */
}

@HiveType(typeId: 0)
class Cart extends HiveObject {
  // add package hive_generator and build_runner
  // add part 'models.g.dart'; on top import
  // run command "flutter packages pub run build_runner build" to create the adpter

  @HiveField(0)
  String ProductCode;

  @HiveField(1)
  String ProductName;

  @HiveField(2)
  int ProductPrice;

  @HiveField(3)
  int ProductQuantity;

  @HiveField(4)
  String ThumbnailURL;

  Cart({
    required this.ProductCode,
    required this.ProductName,
    required this.ProductPrice,
    required this.ProductQuantity,
    required this.ThumbnailURL,
  });
}
