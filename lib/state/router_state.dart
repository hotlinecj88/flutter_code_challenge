import 'package:flutter/material.dart';
import 'package:flutter_code_challenge/blocks/block_scaffold_navbar.dart';
import 'package:flutter_code_challenge/config/app_routes.dart';
import 'package:flutter_code_challenge/pages/products/screen/product_detail.dart';
import 'package:flutter_code_challenge/pages/tab_main/tab_home.dart';
import 'package:flutter_code_challenge/pages/tab_main/tab_search.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


final GlobalKey<NavigatorState> root_navigator_key = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> tab_index_nagivator_key = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> tab_search_nagivator_key = GlobalKey<NavigatorState>();

final router_state = Provider<GoRouter>( (ref) {
  
  return GoRouter(
    navigatorKey: root_navigator_key, 
    initialLocation: ROUTE_TAB_HOME,
    routes: [

      // Stack Navigator
      StatefulShellRoute.indexedStack(
        builder: ( context, GoRouterState state, StatefulNavigationShell navigationShell) {
          return BlockScaffoldNavbar( key: state.pageKey, navigationShell: navigationShell );
        },

        branches: [
          StatefulShellBranch(
            navigatorKey: tab_index_nagivator_key,
            routes: [
              // Tab Home
              GoRoute(
                path: ROUTE_TAB_HOME,
                builder: (context, GoRouterState state) => TabHome(),
                routes: [

                  // Product Details
                  GoRoute(
                    path: ROUTE_PRODUCT_DETAILS,
                    builder: (BuildContext context, GoRouterState state) => ProductDetail(params: state.extra as Map<String, dynamic>)
                  ),


                ],
              ),
            ],
          ),

          // Tab Search
          StatefulShellBranch(
            navigatorKey: tab_search_nagivator_key,
            routes: [
              GoRoute(
                path: ROUTE_TAB_SEARCH,
                builder: (BuildContext context, GoRouterState state) => TabSearch(),
                routes: [],
              ),
            ],
          ),

        ]
      )

    ],

  );

});