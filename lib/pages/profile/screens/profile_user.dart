import 'package:flutter/material.dart';
import 'package:flutter_code_challenge/config/app_routes.dart';
import 'package:flutter_code_challenge/pages/products/widgets/product_item.dart';
import 'package:flutter_code_challenge/pages/profile/screens/profile_add_game.dart';
import 'package:flutter_code_challenge/pages/profile/states/profile_state.dart';
import 'package:flutter_code_challenge/state/product_state.dart';
import 'package:flutter_code_challenge/state/router_state.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileUser extends HookConsumerWidget{

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final my_games = ref.watch(product_state.select((state) => state.value?.my_products ?? []));

    print('My Games: ${my_games.length}');

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          root_navigator_key.currentState?.push(
            MaterialPageRoute<void>(
              fullscreenDialog: true,
              builder: (BuildContext context) => ProfileAddGame()
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Profile User'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              ref.read(profile_state.notifier).logout(prefix_loading: 'logout_loading');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if( my_games.isEmpty) 
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('No games found.'),
                ),
              ),
            ),

          if( my_games.isNotEmpty ) Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 80.0),
              itemCount: my_games.length,
              itemBuilder: (context, index) {
                final product = my_games[index];
                return ProductItem(
                  product: product,
                  onTap: (){
                    GoRouter.of(context).push(
                      '${ROUTE_TAB_HOME}/${ROUTE_PRODUCT_DETAILS}',
                      extra: {
                        'id': product.id,
                        'is_owner': true,
                      }
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}