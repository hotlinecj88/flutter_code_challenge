import 'package:flutter/material.dart';
import 'package:flutter_code_challenge/blocks/block_appbar_static.dart';

class BlockNotFound extends StatelessWidget{

  final bool? autoback;
  final Duration? duration;
  final bool? disableAppbar;

  BlockNotFound({
    super.key,
    this.autoback,
    this.duration,
    this.disableAppbar
  });

  @override
  Widget build(BuildContext context) {

    if( autoback == true ){
      if (Navigator.canPop(context)) {
        Future.delayed( duration ?? Duration.zero, (){
          Navigator.pop(context);
        } );
      }
    }

    return Scaffold(
      appBar: disableAppbar == true ? null : BlockAppbarStatic(title: ''),
      body: Center(
        child: Container(
          child: Text(
            'Data Not Found',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w400
            )
          )
        )
      )
    );
  }

}