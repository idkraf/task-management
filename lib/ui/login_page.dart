import 'package:flutter/material.dart';
import 'package:task_management/my_theme.dart';
// import 'package:task_management/ui/auth/forgot_password_page.dart';
import 'package:task_management/ui/widgets/progress_dialog_widget.dart';
import 'package:task_management/ui/widgets/text_widget.dart';
import 'package:task_management/bloc/auth_bloc.dart' as authBloc;
import 'package:task_management/utility/colors.dart';
import 'package:task_management/utility/utils.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  bool _isHidePassword = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //cek if login or not

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: ProgressDialog(
        inAsyncCall: _isLoading,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _loginField(context),
            )
          ])
        )
      ),
    );
  }


  _login(){
    if(_emailController.text == "" || _passController.text == ""){
      showMessage(context, "Failed", "All form input required", backgroundColor: redColor, buttonColor: redColor, buttonTextColor: whiteColor, onClick: (){
        Navigator.of(context).pop();
      });
    } else if (_passController.text.length < 8) {
      showMessage(
        context,
        "Failed",
        "Password must be at least 8 characters",
        backgroundColor: redColor,
        buttonColor: redColor,
        buttonTextColor: whiteColor,
        onClick: () {
          Navigator.of(context).pop();
        },
      );

    }else{
      setState(() {
        _isLoading=true;
      });
      var loginData = {
        "email": _emailController.text,
        "password":_passController.text
      };

      authBloc.bloc.actDoLogin(loginData, (models) async{
        setState(() {
          _isLoading=false;
        });

        Navigator.pushNamedAndRemoveUntil(
            context, "/task_page", (_) => false);

      });
    }
  }

  Widget _loginField(context){
    return Column(
      children: <Widget>[
        SizedBox(height: 20,),
        const Center(
            child: Text.rich(
            style: TextStyle(
              color: MyTheme.text_color_1,
            ),
            TextSpan(
              text: 'Welcome back to your ', // Normal text
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w300,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'task management', // Bold part
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
        ),
        SizedBox(height: 20,),

        Container(
          margin: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              TextWidget(
                txt: "Email",
              ),

            ],
          ),
        ),
        Container(
            margin: const EdgeInsets.only(top: 5),
            decoration: const BoxDecoration (
              borderRadius: BorderRadius.all(Radius.circular(6.0)),

            ),
            child: TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyTheme.text_color_5, width: 1.0),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                  filled: true,
                  hintStyle: TextStyle(color: MyTheme.text_color_3, fontSize: 14),
                  labelStyle: TextStyle(color: MyTheme.text_color_3, fontSize: 14),
                  hintText: "Email",
                  fillColor: MyTheme.bg
              ),
            )),
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: const Row(
            children: [
              TextWidget(
                txt: "Password",
              ),

            ],
          ),
        ),
        Container(
            margin: const EdgeInsets.only(top: 5),
            decoration: const BoxDecoration (
              borderRadius: BorderRadius.all(Radius.circular(6.0)),

            ),
            child: TextFormField(
              keyboardType: TextInputType.text,
              controller: _passController,
              obscureText: _isHidePassword,
              decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: MyTheme.text_color_5, width: 1.0),
                  ),
                  suffixIcon: IconButton(
                      icon: Icon(_isHidePassword
                          ? Icons.remove_red_eye_outlined
                          : Icons.remove_red_eye,
                          color: MyTheme.text_color_3,
                          size: 20),
                      onPressed: () {
                        setState(() {
                          if (_isHidePassword) {
                            _isHidePassword = false;
                          } else {
                            _isHidePassword = true;
                          }
                        });
                      }),
                  contentPadding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                  filled: true,
                  labelStyle: const TextStyle(color: MyTheme.text_color_3, fontSize: 14),
                  hintStyle: const TextStyle(color: MyTheme.text_color_3, fontSize: 14),
                  hintText: "Password",
                  fillColor: MyTheme.bg
              ),
            )),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
          padding: const EdgeInsets.only(top: 10),
          alignment: FractionalOffset.centerRight,
          child: InkWell(
            child: TextWidget(
              txt: "Forgot Password",
              txtSize: 14,
              weight: FontWeight.w500,
              color: MyTheme.text_color_4,
            ),
            onTap: () {
              // routeToWidget(context, ForgotPasswordPage());
            },
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 20),
          width: MediaQuery.of(context).size.width,
          child: ElevatedButtonTheme(
            data: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(MediaQuery.of(context).size.width, 50)
                )
            ),
            child: ElevatedButton(
              child: TextWidget(
                txt: "Login",
                color: Colors.white,
                txtSize: 16,
                weight:FontWeight.w700,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: MyTheme.text_color_4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)
                ),
              ),
              onPressed: () {
                _login();
              },
            ),
            // height: 50.0,
          ),
        ),

      ],
    );
  }

}