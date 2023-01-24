import 'package:cloud_firestore/cloud_firestore.dart';

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
