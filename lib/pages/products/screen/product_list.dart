import 'package:flutter/material.dart';
import 'package:flutter_code_challenge/config/app_routes.dart';
import 'package:flutter_code_challenge/pages/products/widgets/product_item.dart';
import 'package:flutter_code_challenge/state/product_state.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductList extends HookConsumerWidget{

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final _product_state = ref.watch(product_state);

    if( _product_state.value?.isEmpty == true )
      return Center(
        child: Text('No products available'),
      );

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: _product_state.value?.length,
      itemBuilder: (context, index) {
        final product = _product_state.value![index];
        return ProductItem(
          product: product,
          onTap: (){
            GoRouter.of(context).push(
              '${ROUTE_TAB_HOME}/${ROUTE_PRODUCT_DETAILS}',
              extra: {
                'id': product.id,
              }
            );
          },
        );
        
      },
    );
  }

}