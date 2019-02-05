 import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kokushi Connect',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {

    void login () {
      Navigator.of(context).push(
        new MaterialPageRoute(
          builder: (BuildContext context) {
            return new Scaffold(
              appBar: new AppBar(
                title: const Text('Saved Suggestions'),
              ),
              body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Welcome!'),
                    TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '...',
                          labelText: 'username'
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '...',
                          labelText: 'password'
                      ),
                    ),
                    RaisedButton(
                      child: const Text('LOGIN'),
                      color: Colors.blue,
                      onPressed: () {

                      },
                    ),
                  ]
              ),
            );
          }
        ),
      );
    }

    var logo = new Image.network("https://images-na.ssl-images-amazon.com/images/I/51G0WNRVGiL._SX425_.jpg",
      scale: 0.1,
    );
    
    var loginButton = new RaisedButton(
      onPressed: login,
      child:
        Text("Login")
    );

    var createButton = new RaisedButton(
        onPressed: login,
        child: Text("Create Account")
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Kokushi Connect'),
      ),
      body: Center (
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            logo,
            Text("Login As:"),
            loginButton,
            createButton,
          ],
        )
      ),
    );
  }
}
