import 'package:flutter/material.dart';
import 'package:flutter_code_challenge/blocks/block_appbar_static.dart';
import 'package:flutter_code_challenge/blocks/block_input.dart';
import 'package:flutter_code_challenge/config/app_routes.dart';
import 'package:flutter_code_challenge/pages/products/widgets/product_item.dart';
import 'package:flutter_code_challenge/state/loading_state.dart';
import 'package:flutter_code_challenge/state/product_state.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TabSearch extends HookConsumerWidget{
  
  TabSearch({
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final _product_state = ref.watch(product_state); // keep the state in memory
    final product_search_loading = ref.watch(loading_state('product_search_loading'));
    
    final searchController = useTextEditingController();
    final previousQuery = useRef<String>('');

    useEffect(() {
      void listener() {
        final currentInput = searchController.text;
        if (currentInput == previousQuery.value) return;

        if (searchController.text.isNotEmpty) {
          previousQuery.value = searchController.text;
          ref.read(product_state.notifier).search(
            query: currentInput, 
            prefix_loading: 'product_search_loading'
          );
        }
      }
      searchController.addListener(listener);
      return () {
        searchController.removeListener(listener);
      };
    }, []);


    // Get search data from product state
    final displayProducts = ref.read(product_state.notifier).displayProducts;


    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: BlockAppbarStatic(
        title: 'Search',
      ),
      body: Container(
        child: Column(
          children: [

            Container(
              margin: EdgeInsets.all(16.0),
              child: BlockInput(
                controller: searchController,
                placeholder: 'Search Products',
              ),
            ),

            Expanded(
              child: product_search_loading == LoadingIndicatorState.loading
              ? Center(child: CircularProgressIndicator())
              : displayProducts.isEmpty == true 
                ? 
                  product_search_loading == LoadingIndicatorState.error
                    ? Center(child: Text('Search not found'),)
                    : Center(child: Text('Search products by title'),) 
                : Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Found ${displayProducts.length} products',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: displayProducts.length,
                        itemBuilder: (context, index) {
                          final product = displayProducts[index];
                      
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
                      ),
                    ),
                  ],
                )
            )

          ],
        )

      ),
    );

  }
} 