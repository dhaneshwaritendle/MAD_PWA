import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_case3/components/mybutton.dart';
import 'package:test_case3/components/mytextfield.dart';
import 'package:test_case3/components/square_tile.dart';
import 'package:test_case3/services/auth/auth_service.dart';


class LoginPage extends StatefulWidget {

  final void Function()? onTap;
  const LoginPage({super.key , required this.onTap,});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;


  // sign in user
  void signIn() async {
    //   get the auth service
    final authService = Provider.of<AuthService>(context, listen: false);


    // Update isLoading to true to show the loader
    setState(() {
      isLoading = true;
    });

    try {
      // Try sign-in
      await authService.signInWithEmailandPassword(
        emailController.text,
        passwordController.text,
      );
    } catch (e) {
      // Handle sign-in error
      // You can show an error message here if needed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign-in error: $e'),
          duration: Duration(seconds: 3), // Adjust duration as needed
        ),
      );    } finally {
      // Update isLoading to false to hide the loader
      setState(() {
        isLoading = false;
      });
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
                      Icons.message_rounded,
                      size: 100,
                     color: Colors.grey.shade700),
                    const SizedBox(height: 50,),
          
                    //welcome back message
                     const Text(
                        "Welcome back you have been missed !",
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
                    const SizedBox(height: 50,),
                    //sign in button
                    Stack(
                      children: [
                        MyButton(
                          onTap: signIn,
                          text: "Sign In",
                        ),
                        if ( isLoading)
                          Positioned.fill(
                            child: Container(
                              color: Colors.black.withOpacity(0.5),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                      ],
                    ),

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
                         // Google button
                         SquareTile(
                           onTap: () async {
                             setState(() {
                               isLoading = true;
                             });
                             await AuthService().signInWithGoogle();
                             setState(() {
                               isLoading = false;
                             });
                           },
                           imagePath: "lib/assets/google.png",
                         ),
                       ],
                    ),

                    const SizedBox(height: 10,),
                    //Not a member?Register Now
                     Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Not a member?'),
                        const SizedBox(width: 4,),
          
                        GestureDetector(
                          onTap: widget.onTap,
                          child:const Text(
                           'Register Now',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
}

