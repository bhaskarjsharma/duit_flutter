import 'dart:developer';
import 'dart:js_util';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duit_flutter/admin.dart';
import 'package:flutter/material.dart';

import 'account.dart';
import 'main.dart';
import 'models.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  var isLoading = true;
  var currentUser = '';
  int _selectedIndex = 0;
  List<Product> products = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser = firebaseAuth.currentUser?.uid as String;

    db.collection('Product').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final product = Product(
            Code: doc["Code"],
            Name: doc["Name"],
            Description: doc["Description"],
            Price: int.parse(doc["Price"]),
            Quantity: int.parse(doc["Quantity"]),
            Category1: doc["Category1"],
            Category2: doc["Category2"],
            ThumbnailURL: doc["ThumbnailURL"]);

        products.add(product);
      });

      setState(() {
        isLoading = false;
      });
    });

    /*  final docRef = db.collection("Product").doc("cAJnTuYj7T0iCOUKrcGm");
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        print(data);
      },
      onError: (e) => print("Error getting document: $e"),
    );  */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DUIT'), actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Logout',
          onPressed: () {
            LogoutUser();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
          },
        ),
      ]),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Admin()),
                );
              },
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('Admin'),
                trailing: Icon(Icons.account_circle),
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      body: !isLoading
          ? GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                return productCard(products[index]);
              })
          : Center(child: CircularProgressIndicator()),
    );
  }

  Card productCard(Product product) {
    return Card(
      elevation: 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: () {},
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    height: 100,
                    color: Colors.teal[100],
                    child: Image.network(product.ThumbnailURL),
                  ),
                  Text(product.Name),
                  Text(product.Description),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(product.Price.toString()),
                      Text('Review'),
                    ],
                  ),
                ],
              )),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  final cartItem = <String, dynamic>{
                    "Code": product.Code,
                    "Name": product.Name,
                    "Price": product.Price,
                    "Quantity": 1,
                  };

                  db.collection("Cart").add(cartItem).then(
                      (DocumentReference doc) =>
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Product added to cart'),
                              action: SnackBarAction(
                                label: 'View Cart',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Cart()),
                                  );
                                },
                              ),
                            ),
                          ));
                },
                child: Icon(Icons.shopping_cart),
              ),
              GestureDetector(
                onTap: () {},
                child: Icon(Icons.favorite),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

LogoutUser() async {
  await sharedPref.clear();
  await firebaseAuth.signOut();
}

class Cart extends StatefulWidget {
  @override
  State<Cart> createState() => CartState();
}

class CartState extends State<Cart> {
  var isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart'), actions: <Widget>[]),
      body: Center(
        child: Text('Cart'),
      ),
    );
  }
}
