import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_code_challenge/blocks/block_appbar_static.dart';
import 'package:flutter_code_challenge/blocks/block_input.dart';
import 'package:flutter_code_challenge/config/app_routes.dart';
import 'package:flutter_code_challenge/pages/products/widgets/product_item.dart';
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

    final _product_state = ref.watch(product_state);
    
    final searchController = useTextEditingController();
    final searchQuery = useState<String>('');
    // Previous search query to compare with the current one
    final previousQuery = useRef<String>('');
    final isSearching = useState<bool>(false);
    // Debounce timer to limit the number of search queries
    final debounceTimer = useRef<Timer?>(null);

    useEffect(() {
      void listener() {
        final currentInput = searchController.text;
        if (currentInput == previousQuery.value) return;

        isSearching.value = true;
        debounceTimer.value?.cancel();

        debounceTimer.value = Timer(const Duration(milliseconds: 500), () {
          searchQuery.value = currentInput;
          previousQuery.value = currentInput;
          isSearching.value = false;
        });
      }

      searchController.addListener(listener);
      return () {
        searchController.removeListener(listener);
        debounceTimer.value?.cancel();
      };
    }, []);

    // Search products by title
    final filteredProducts = _product_state.value?.where((product) {
      final query = searchQuery.value.trim().toLowerCase();
      if (query.isEmpty) return false; // show all
      return product.title?.toLowerCase().contains(query) ?? false;
    }).toList();


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
              child: isSearching.value
              ? Center(child: CircularProgressIndicator())
              : filteredProducts?.isEmpty == true 
                ? Center(
                  child: Text('Search products by title'),
                )
                : ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: filteredProducts?.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts![index];

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
                )
            )

          ],
        )

      ),
    );

  }
} 