import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:test_case3/components/mybutton.dart';
import 'package:test_case3/components/mytextfield.dart';
import 'package:test_case3/services/auth/auth_service.dart';

import '../components/square_tile.dart';

class RegisterPage extends StatefulWidget {

  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {

  //text controllers
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  final confirmpasswordController=TextEditingController();

  // sign up user
  void signUp() async{
    if(passwordController.text != confirmpasswordController.text){
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(content: Text("Passwords do not match!"),
        ),
      );
      return;
    }
  //   get auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    try{
      await authService.signUpWithEmailandPassword(emailController.text, passwordController.text);
    }catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),));
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade300,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 50,),
                  //logo
                  Icon(
                    Icons.message,
                    size: 80,
                    color: Colors.grey.shade800,),
                  const SizedBox(height: 50,),
        
                  //welcome back message
                  const Text(
                    "Lets create an account for you!",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 25,),
        
                  //email text-field
                  MyTextField(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false),
                  const SizedBox(height: 10,),
                  //password
                  MyTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true),
                  const SizedBox(height: 10,),
        
                  // confirm password
                  MyTextField(
                      controller: confirmpasswordController,
                      hintText: 'Confirm Password',
                      obscureText: true),
                  const SizedBox(height: 25,),
                  //sign up
                  MyButton(
                      onTap: signUp,
                      text: "Sign Up "),
                  const SizedBox(height: 50,),


                  //or continue button
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 25.0),

                    child: Row(
                      children: [
                        Expanded(child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                        ),
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(color: Colors.grey[700],),
                          ),
                        ),
                        Expanded(child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ))
                      ],
                    ),
                  ),
                  const SizedBox(height: 10,),

                  //google sign in
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // google button
                      SquareTile(
                          onTap: ()=>AuthService().signInWithGoogle(),
                          imagePath:"lib/assets/google.png"),


                    ],
                  ),
                  const SizedBox(height: 10,),
                  //Login now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already a member?'),
                      const SizedBox(width: 4,),
        
                      GestureDetector(
                        onTap: widget.onTap,
                        child:const Text(
                          'Login Now',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

