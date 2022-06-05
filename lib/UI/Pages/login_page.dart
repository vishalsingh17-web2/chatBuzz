import 'package:chatbuzz/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Image.asset(
                "assets/images/login.jpg",
                fit: BoxFit.cover,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: const Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        autovalidateMode: AutovalidateMode.always,
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: "Phone number",
                            labelStyle: TextStyle(fontSize: 16),
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                            prefixIcon: Icon(Icons.phone),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Get OTP",
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                "OR",
                style: TextStyle(fontSize: 20, fontFamily: "Monospace"),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    primary: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const MainScreen(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Continue with google ",
                        style: TextStyle(fontSize: 17, color: Colors.black),
                      ),
                      CircleAvatar(child: Image.asset("assets/images/google.png"), radius: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
