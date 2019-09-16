import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop4you/models/http_exception.dart';
import 'package:shop4you/providers/auth.dart';

// Since we have to show loading so it has to be stateful
class AuthScreen extends StatelessWidget {
  static const routeName = "/auth";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                child: Text(
                  "Shop4you",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: const AuthCard(),
            )
          ],
        ),
      ),
    ));
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key key}) : super(key: key);

  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    "email": "",
    "password": "",
  };

  var _isLoading = false;

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("An Error Occurred"),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                  child: Text("okay"),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save(); // Call the onSaved Method
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Auth>(context, listen: false)
          .loginUser(_authData["email"], _authData["password"]);
    } on HttpException catch (err) {
      _showErrorDialog(err.toString());
    } catch (err) {
      _showErrorDialog(err.toString());
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: "E-Mail"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains("@")) {
                      return "Invalid Email";
                    }
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty || value.length < 6) {
                      return "The password must be longer than 6 Character.";
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  RaisedButton(
                    child: const Text("Login"),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 4),
                    textColor: Colors.white,
                    onPressed: _submit,
                    color: Theme.of(context).primaryColor,
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
