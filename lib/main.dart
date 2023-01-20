import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(
    MaterialApp(
        home: Register()
      ),
  );
}

class Register extends StatefulWidget {
  
  @override
  State<Register> createState() => RegisterState();
}

class RegisterState extends State<Register>{
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false;
  late Future<bool> res;

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body: Center(
        child: !isLoading ? 
        Form(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Register'),
            Container(
              
              padding: EdgeInsets.all(50),
              
              child: TextFormField(
              controller: usernameController,
              validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
                }
                return null;
              },
            ),
            ),

            Padding(padding: EdgeInsets.all(50),
            child: TextFormField(
              controller: passwordController,
              validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
                }
                return null;
              },
            ),)            ,
            ElevatedButton(
              onPressed: () async{

                setState(() {
                  isLoading = true;
                });

                var res = await register(usernameController.text,passwordController.text);
                if(res){
                  setState((){
                      isLoading = false;
                  }) ;

                  Navigator.push(context,MaterialPageRoute(builder: (context) => Login()),);
                }

            },
            child: Text('Register'),),
          ],
          ),
        ) : CircularProgressIndicator(),
      ),
    );
  }
}

Future<bool> register(String username, String password) async {
  Response response;
  var dio = Dio();

  response = await dio.post('https://localhost:44369/UserAccount/Register',
    data: {'Name': 'fc', 'Email': username,'Password':password,'Contact':'1234'}
  );

  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    print(response.data);
    return response.data;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Registration failure');
  }
}

class Login extends StatefulWidget {
  
  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login>{
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false;
  late Future<String> res;

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body: Center(
        child: !isLoading ? 
        Form(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Login'),
            Container(
              
              padding: EdgeInsets.all(50),
              
              child: TextFormField(
              controller: usernameController,
              validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
                }
                return null;
              },
            ),
            ),

            Padding(padding: EdgeInsets.all(50),
            child: TextFormField(
              controller: passwordController,
              validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
                }
                return null;
              },
            ),)            ,
            ElevatedButton(
              onPressed: () async{

                setState(() {
                  isLoading = true;
                });

                var res = await login(usernameController.text,passwordController.text);
                // Save the JWT in client
                setState((){
                      isLoading = false;
                }) ;
            },
            child: Text('Login'),),
          ],
          ),
        ) : CircularProgressIndicator(),
      ),
    );
  }
}

Future<String> login(String username, String password) async {
  Response response;
  var dio = Dio();

  response = await dio.post('https://localhost:44369/UserAccount/Login',
    data: {'Email': username,'Password':password}
  );

  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    print(response.data);
    return response.data;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Registration failure');
  }
}