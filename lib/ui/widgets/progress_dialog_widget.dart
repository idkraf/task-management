import 'package:flutter/material.dart';
import 'package:task_management/my_theme.dart';
import 'package:task_management/ui/widgets/text_widget.dart';

class ProgressDialog extends StatelessWidget {
  final bool inAsyncCall;
  final double opacity;
  final Color color;
  final Widget progressIndicator;
  final Offset? offset;
  final bool dismissible;
  final Widget child;
  String message;

  ProgressDialog({
    Key? key,
    required this.inAsyncCall,
    this.opacity = 0.3,
    this.color = Colors.white,
    this.progressIndicator = const CircularProgressIndicator(),
    this.offset,
    this.dismissible = false,
    this.message = "",
    required this.child,
  })  : assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!inAsyncCall) return child;

    Widget layOutProgressIndicator;
    if (offset == null)
      layOutProgressIndicator = Center(child: progressIndicator);
    else {
      layOutProgressIndicator = Positioned(
        child: progressIndicator,
        left: offset!.dx,
        top: offset!.dy,
      );
    }

    return Stack(
      children: [
        child,
        Opacity(
          child: ModalBarrier(dismissible: dismissible, color: color),
          opacity: opacity,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            layOutProgressIndicator,
            SizedBox(height: 15,),
            TextWidget(
              txt: message == "" ?  "Please Wait" : message,
              weight: FontWeight.bold,
              color: MyTheme.text_color_1,
              txtSize: 16,
              align: TextAlign.justify,
            )

          ],
        )
      ],
    );
  }
}
