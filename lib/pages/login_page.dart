import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_case3/components/mybutton.dart';
import 'package:test_case3/components/mytextfield.dart';
import 'package:test_case3/services/auth/auth_service.dart';


class LoginPage extends StatefulWidget {

  final void Function()? onTap;
  const LoginPage({super.key , required this.onTap,});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  //text controllers
  final emailController=TextEditingController();
  final passwordController=TextEditingController();

    // sign in user
  void signIn() async{
  //   get the auth service
    final authService = Provider.of<AuthService>(context,listen:false);

    try{
      await authService.signInWithEmailandPassword(
          emailController.text,
          passwordController.text,);
    }
    catch (e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(e.toString(),),),);
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
                   MyButton(
                       onTap: signIn,
                       text: "Sign In "),
                    const SizedBox(height: 50,),
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

