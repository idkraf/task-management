import 'package:flutter/material.dart';
import 'package:task_management/bloc/bloc_provider.dart';
import 'package:task_management/my_theme.dart';
import 'package:task_management/ui/widgets/text_widget.dart';

Future routeToWidget(BuildContext context, Widget widget) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) {
      return BlocProvider(
        bloc: null,
        child: widget,
      );
    }),
  );
}

showSuccessMessage(BuildContext context, String title, String message,String buttonText,
    {bool isDismiss = true, Color? titleColor, Color? messageColor, Color? backgroundColor, Color? buttonColor, Color? buttonTextColor, Function? onClick, double? heightPopUp}) {
  return  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          height: heightPopUp ?? MediaQuery.of(context).size.width / 2.5,
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: backgroundColor ?? Colors.white
                ),
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: TextWidget(
                          txt: title,
                          txtSize: 16,
                          maxLine: 2,
                          color: titleColor ?? Colors.red,
                          weight: FontWeight.bold,
                          align: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: TextWidget(
                          txt: message,
                          txtSize: 14,
                          maxLine: 10,
                          color: messageColor ?? MyTheme.text_color_1,
                          align: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          onClick!();
                          // Navigator.of(context).pop();
//                                Navigator.pushNamedAndRemoveUntil(context, "/login_menu", (_) => false);
                        },
                        child: Container(
                            width:
                            MediaQuery.of(context).size.width,
                            height: 50,
                            alignment: Alignment.center,
                            decoration:  BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(6.0)),
                                color: buttonColor ?? Colors.red),
                            child: TextWidget(
                              txt: buttonText ?? "Ok",
                              color: buttonTextColor ?? Colors.white,
                              txtSize: 14,
                            )),
                      )

                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      });
}

showMessage(BuildContext context, String title, String message,
    {bool isDismiss = true, Color? titleColor, Color? messageColor, Color? backgroundColor, Color? buttonColor, Color? buttonTextColor, Function? onClick, double? heightPopUp}) {
  return  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          height: heightPopUp ?? MediaQuery.of(context).size.width / 3,
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Colors.white ?? backgroundColor
                ),
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget(
                            txt: title,
                            txtSize: 16,
                            maxLine: 2,
                            color: titleColor ?? Colors.red,
                            weight: FontWeight.bold,
                            align: TextAlign.start,
                          ),
                          GestureDetector(
                              onTap: (){
                                Navigator.of(context).pop();
                              },
                              child: Icon(Icons.close)
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextWidget(
                        txt: message,
                        txtSize: 14,
                        maxLine: 10,
                        color: messageColor ?? MyTheme.text_color_1,
                        align: TextAlign.start,
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      });
}