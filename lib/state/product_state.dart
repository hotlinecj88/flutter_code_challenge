import 'dart:async';
import 'package:flutter_code_challenge/pages/products/models/product_model.dart';
import 'package:flutter_code_challenge/state/loading_state.dart';
import 'package:flutter_code_challenge/state/database_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductState extends AsyncNotifier<List<ProductModel>> {

  @override
  Future<List<ProductModel>> build() async{
    // Future.microtask(() => fetchInit(prefix_loading: 'product_init_loading'));
    return [];
  }

  Future<void> fetchInit({ required String prefix_loading }) async {
    final loadingNotifier = ref.read(loading_state(prefix_loading).notifier);
    loadingNotifier.state = LoadingIndicatorState.loading;

    // Simulate a delay to show loading state
    await Future.delayed(Duration(seconds: 1));

    try{
      final rows = await DatabaseState.instance.get(
        table: 'games',
      );
      if(rows.isNotEmpty){
        state = AsyncData(
          rows.map((e) => ProductModel.fromJson(e)).toList()
        );
      }
      print('Loading Data: ${state.value?.length}');
      loadingNotifier.state = LoadingIndicatorState.hasData;
    }catch(e){
      loadingNotifier.state = LoadingIndicatorState.error;
      print('Data Not Found: $e');
    }
  }



}

final product_state = AsyncNotifierProvider<ProductState, List<ProductModel>>(ProductState.new);