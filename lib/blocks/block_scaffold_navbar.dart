
import 'package:flutter/material.dart';
import 'package:flutter_code_challenge/blocks/block_button_entry.dart';
import 'package:flutter_code_challenge/blocks/block_unfocus_tap.dart';
import 'package:flutter_code_challenge/config/app_config.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BlockScaffoldNavbar extends StatefulHookConsumerWidget{

  final StatefulNavigationShell? navigationShell;

  BlockScaffoldNavbar({
    Key? key,
    required this.navigationShell,
  }) : super( key: key ?? ValueKey<String>('BlockScaffoldNavbar'));

  @override
  createState() => _BlockScaffoldNavbar();
}

// ignore: must_be_immutable
class _BlockScaffoldNavbar extends ConsumerState<BlockScaffoldNavbar>{

  List<Map<String, dynamic>> listMenu = [
    {'id': 0, 'title': 'Home', 'icon': Icons.home},
    {'id': 1, 'title': 'Search', 'icon': Icons.search},
    {'id': 2, 'title': 'Profile', 'icon': Icons.person},
  ];
  
  @override
  Widget build(BuildContext context) {

    

    return BlockUnfocusTap(
      child: Stack(
        children: [

          Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              child: Stack(
                children: [
                  // Main Content
                  Container( child: widget.navigationShell ),

                ],
              ),
            ),
            bottomNavigationBar: Container(
              height: BOTTOMBAR_HEIGHT,
              padding: EdgeInsets.symmetric( vertical: 8.0 ),
              margin: EdgeInsets.only( top: 0.0, bottom: 12.0,),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  
                  for( var menu in listMenu ) ...[
                    Expanded(
                      child: buttonMenu(
                        onPressed: (){
                          if( widget.navigationShell!.currentIndex != menu['id'] ){
                            widget.navigationShell!.goBranch(
                              menu['id'],
                              initialLocation: menu['id'] == widget.navigationShell!.currentIndex,
                            );
                          }
                        },
                        isCurrentMenu: widget.navigationShell!.currentIndex == menu['id'],
                        icon: menu['icon'],
                        text: menu['title']
                      ),
                    )
                  ]
                  
                ]
              )
            )
          ),


        ]
      ),

    );
  }
  
  Widget buttonMenu({
    VoidCallback? onPressed,
    bool isCurrentMenu = false,
    IconData? icon,
    double iconSize = 18.0,
    String? text,
  }){ 
    final theme = Theme.of(context);

    final Color iconColor = isCurrentMenu
      ? theme.colorScheme.primary
      : theme.iconTheme.color ?? Colors.black;

    final Color textColor = isCurrentMenu
      ? theme.colorScheme.primary
      : theme.textTheme.bodySmall?.color ?? Colors.black;

    final Color backgroundColor = isCurrentMenu
      ? theme.colorScheme.primary.withAlpha(50)
      : Colors.transparent;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.0,),
      child: BlockButtonEntry(
        buttonColor: backgroundColor,
        onPressed: (){
          if( onPressed != null) onPressed();
        },
        customWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon( icon, 
              size: iconSize, color: iconColor
            ),
            if(text != null) Text( 
              '${text}',
              style: TextStyle(
                color: textColor,
                fontSize: 12.0
              )
            )
          ]
        ),
      ),
    );
  }

}