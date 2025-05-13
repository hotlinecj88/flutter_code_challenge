import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BlockAppbarStatic extends HookConsumerWidget implements PreferredSizeWidget {
  
  final String? title;
  final PreferredSizeWidget? bottom;
  final Color? appbarBackground;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;

  const BlockAppbarStatic({
    super.key,
    this.title,
    this.bottom,
    this.appbarBackground,
    this.actions,
    this.automaticallyImplyLeading = true
  });

  @override
  Widget build(BuildContext context, WidgetRef ref ) {

    return Container(
      child: AppBar(
        automaticallyImplyLeading: automaticallyImplyLeading,
        centerTitle: true,
        title: Text(
          '${title ?? ''}',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600
          )
        ),
        bottom: bottom != null ? bottom : null,
        actions: [
          if( actions != null ) ...actions!,
        ],
      )
    );

  }


  @override
  Size get preferredSize {
    double _height = kToolbarHeight;
    if (bottom != null) {
      _height += bottom!.preferredSize.height;
    }
    return Size.fromHeight(_height);
  }
  
}