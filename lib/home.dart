import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duit_flutter/admin.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

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

  List<Product> products = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //currentUser = firebaseAuth.currentUser?.uid as String;

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
      appBar: AppBar(
        title: const Text('DUIT'),
      ),
      endDrawer: Drawer(
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
            isLoggedIn
                ? Column(
                    children: [
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
                    ],
                  )
                : Column(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          },
                          child: Text('Login')),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Register()),
                            );
                          },
                          child: Text('New User? Register'))
                    ],
                  )
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
            icon: Icon(Icons.list),
            label: 'Category',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Orders',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
            backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: selectedIndex,
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
                onTap: () async {
                  if (isLoggedIn) {
                    // logged in user. Add item to cart and create entry in database
                    final cartItem = <String, dynamic>{
                      "ProductCode": product.Code,
                      "ProductName": product.Name,
                      "ProductPrice": product.Price,
                      "ProductQuantity": 1,
                      "ThumbnailURL": product.ThumbnailURL,
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
                                          builder: (context) => ProductCart()),
                                    );
                                  },
                                ),
                              ),
                            ));
                  } else {
                    // add item to cart and save entry in local database

                    var cartBox = await Hive.openBox<Cart>('cart_box');

                    final cartItem = Cart(
                      ProductCode: product.Code,
                      ProductName: product.Name,
                      ProductPrice: product.Price,
                      ProductQuantity: 1,
                      ThumbnailURL: product.ThumbnailURL,
                    );

                    cartBox.add(cartItem);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Product added to cart'),
                        action: SnackBarAction(
                          label: 'View Cart',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductCart()),
                            );
                          },
                        ),
                      ),
                    );
                  }
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
      selectedIndex = index;
    });
    if (selectedIndex == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else if (selectedIndex == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductCart()),
      );
    }
  }
}

LogoutUser() async {
  await sharedPref.clear();
  await firebaseAuth.signOut();
}

class ProductCart extends StatefulWidget {
  @override
  State<ProductCart> createState() => CartState();
}

class CartState extends State<ProductCart> {
  var isLoading = true;
  List<Cart> cartItems = [];
  int totalPrice = 0;
  int totalQuantity = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetCartData();
  }

  GetCartData() async {
    if (isLoggedIn) {
      // user is logged in. Get cart items from firebase database

      db.collection('Cart').get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          final item = Cart(
            ProductCode: doc["ProductCode"],
            ProductName: doc["ProductName"],
            ProductPrice: int.parse(doc["ProductPrice"]),
            ProductQuantity: int.parse(doc["ProductQuantity"]),
            ThumbnailURL: doc["ThumbnailURL"],
          );

          cartItems.add(item);
        });

        setState(() {
          isLoading = false;
          totalPrice =
              cartItems.fold(0, (sum, item) => sum + item.ProductPrice);
          totalQuantity =
              cartItems.fold(0, (sum, item) => sum + item.ProductQuantity);
        });
      });
    } else {
      // user not logged in . Get cart items from hive local database
      final cartItemBox = await Hive.openBox<Cart>('cart_box');
      if (cartItemBox.values.isEmpty) {
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          cartItems = cartItemBox.values.toList();
          isLoading = false;
          totalPrice =
              cartItems.fold(0, (sum, item) => sum + item.ProductPrice);
          totalQuantity =
              cartItems.fold(0, (sum, item) => sum + item.ProductQuantity);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      endDrawer: Drawer(
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
            isLoggedIn
                ? Column(
                    children: [
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
                    ],
                  )
                : Column(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          },
                          child: Text('Login')),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Register()),
                            );
                          },
                          child: Text('New User? Register'))
                    ],
                  )
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
            icon: Icon(Icons.list),
            label: 'Category',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Orders',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
            backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      body: !isLoading
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                    child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: cartItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 50,
                              child: Image.network(
                                  '${cartItems[index].ThumbnailURL}'),
                            ),
                            Text('${cartItems[index].ProductName}'),
                            Text('${cartItems[index].ProductCode}'),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Price: ${cartItems[index].ProductPrice}'),
                                Text(
                                    'Quantity: ${cartItems[index].ProductQuantity}'),
                                IconButton(
                                  onPressed: () {
                                    DeleteFromCart(cartItems[index], index);
                                  },
                                  icon: Icon(Icons.delete),
                                )
                              ],
                            ),
                          ],
                        ));
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                )),
                Divider(),
                ListTile(
                  title: Text('Total'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Price: ${totalPrice}'),
                      Text('Quantity: ${totalQuantity}'),
                    ],
                  ),
                ),
                ElevatedButton(onPressed: () {}, child: Text('Checkout')),
                SizedBox(
                  height: 10,
                )
              ],
            )
          : CircularProgressIndicator(),
    );
  }

  void DeleteFromCart(Cart cartItem, int index) async {
    if (isLoggedIn) {
      // user is logged in. Remove item from firebase database

      db
          .collection('Cart')
          .where('ProductCode', cartItem.ProductCode)
          .delete()
          .then({});
    } else {
      // user not logged in . Remove item from  hive local database
      final cartItemBox = await Hive.openBox<Cart>('cart_box');
      if (!cartItemBox.values.isEmpty) {
        await cartItemBox.deleteAt(index);
        setState(() {
          cartItems.removeWhere(
            (element) => element.ProductCode == cartItem.ProductCode,
          );
          totalPrice =
              cartItems.fold(0, (sum, item) => sum + item.ProductPrice);
          totalQuantity =
              cartItems.fold(0, (sum, item) => sum + item.ProductQuantity);
        });
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    if (selectedIndex == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else if (selectedIndex == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductCart()),
      );
    }
  }
}
