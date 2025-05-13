import 'package:flutter/material.dart';
class BlockUnfocusTap extends StatelessWidget{

  final Widget? child;
  
  BlockUnfocusTap({
    super.key,
    required this.child,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapUp: ( drag ){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: child
    );

  }

}