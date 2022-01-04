// @dart=2.9
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/layout/shop_app/shop_layout.dart';
import 'package:shop_app/modules/shop_app/login/cubit/cubit.dart';
import 'package:shop_app/modules/shop_app/login/cubit/states.dart';
import 'package:shop_app/modules/shop_app/register/cubit/register.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/local/cach_helper.dart';


class ShopLoginScreen extends StatelessWidget
{
  var formKey =GlobalKey<FormState>();
  var email_add = TextEditingController();
  var pass_control = TextEditingController();

  ShopLoginScreen({Key key}) : super(key: key);

  @override
  Widget build (BuildContext context) {
    return BlocProvider(
      create: (context)=>ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context,state){
          if (state is ShopLoginSuccessState)
            {
              if( state.loginModel.status)
                {
                  print (state.loginModel.message);
                  print (state.loginModel.data.token);
                  CacheHelper.saveData(key: 'token', value: state.loginModel.data.token);
                  navigateAndFinish(context,ShopLayout(),);

                }
              else{
                print (state.loginModel.message);
                showToast(text:state.loginModel.message,
                  state: ToastStates.ERROR,);
              }
            }
          },
        builder: (context,state){
          return Scaffold(
            appBar:  AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Login',
                          style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        defaultFormField(
                          controller: email_add,
                          type: TextInputType.emailAddress,
                          validate: (String value) {
                            if (value.isEmpty) {
                              return 'please enter your email address';
                            }
                          },
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        defaultFormField(
                          controller: pass_control,
                          type: TextInputType.visiblePassword,
                          suffix: ShopLoginCubit.get(context).suffix,
                          onSubmit: (value) {
                            if (formKey.currentState.validate())
                              {
                                ShopLoginCubit.get(context).userLogin(
                                  email: email_add.text,
                                  password: pass_control.text,
                                );
                              }

                          },
                          isPassword: ShopLoginCubit.get(context).isPassword,
                          suffixPressed: () {
                            ShopLoginCubit.get(context)
                                .changePasswordVisibility();
                          },
                          validate: (String value) {
                            if (value.isEmpty) {
                              return 'password is too short';
                            }
                          },
                          label: 'Password',
                          prefix: Icons.lock_outline,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopLoginLoadingState,
                          builder: (context) => defaultButton(
                            function: () {
                              if (formKey.currentState.validate()) {
                                ShopLoginCubit.get(context).userLogin(
                                  email: email_add.text,
                                  password: pass_control.text,
                                );
                              }
                            },
                            text: 'login',
                            isUpperCase: true,
                          ),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('don\'t have an account',
                            style: TextStyle(
                              fontSize: 10
                            ),),
                            TextButton(onPressed: () {
                              navigateTo(context,ShopRegisterScreen());
                            },
                                child:
                                Text('Register now',)

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
        },

      ),
    );

  }
}
