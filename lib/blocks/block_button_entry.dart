import 'package:flutter/material.dart';

class BlockButtonEntry extends StatelessWidget{

  final VoidCallback? onPressed;
  final String? title;
  final Widget? customWidget;
  final Color? buttonColor;
  final Color? buttonTextColor;
  final EdgeInsets padding;

  BlockButtonEntry({
    super.key,
    this.title,
    this.onPressed,
    this.customWidget,
    this.buttonColor,
    this.buttonTextColor,
    this.padding = EdgeInsets.zero
  });
  
  @override
  Widget build(BuildContext context ) {

    return Container(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor ?? Colors.transparent,
          foregroundColor: Colors.transparent,
          padding: padding,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shadowColor: Colors.transparent,
        ),
        onPressed: () {  
          if( onPressed != null ) onPressed!();
        }, 
        child: customWidget != null ? customWidget : Text(
          title ?? 'Title Button Entry',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: buttonTextColor ?? Colors.white,
          ),
        ),
      )
    );


  }

}