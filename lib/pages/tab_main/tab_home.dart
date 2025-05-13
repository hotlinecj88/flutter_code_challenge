import 'package:flutter/material.dart';
import 'package:flutter_code_challenge/blocks/block_appbar_static.dart';
import 'package:flutter_code_challenge/pages/products/screen/product_list.dart';
import 'package:flutter_code_challenge/state/loading_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TabHome extends HookConsumerWidget{

  TabHome({
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product_init_loading = ref.watch(loading_state('product_init_loading'));

    return Scaffold(
      appBar: BlockAppbarStatic(
        title: 'Deevolver Digital Games',
      ),
      body: product_init_loading == LoadingIndicatorState.loading
        ? Center(
          child: CircularProgressIndicator(),
        )
        : Container(
          child: ProductList()
      ),
    );
  }
} 