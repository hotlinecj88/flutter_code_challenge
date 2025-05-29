import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_code_challenge/config/app_routes.dart';
import 'package:flutter_code_challenge/pages/products/models/product_model.dart';
import 'package:flutter_code_challenge/state/loading_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide MultipartFile;

class ProductModelState{
  final List<ProductModel>? products;
  final List<ProductModel>? my_products;

  ProductModelState({
    this.products,
    this.my_products,
  });
  ProductModelState copyWith({
    List<ProductModel>? products,
    List<ProductModel>? my_products,
  }){
    return ProductModelState(
      products: products ?? this.products,
      my_products: my_products ?? this.my_products,
    );
  }
}

class ProductState extends AsyncNotifier<ProductModelState> {
  Timer? _debounce;
  CancelToken? _cancelToken;

  List<ProductModel> _searchResults = [];
  List<ProductModel> get displayProducts => _searchResults;

  @override
  Future<ProductModelState> build() async{
    return ProductModelState(
      products: [], my_products: []
    );
  }

  Future<void> fetchInit({ required String prefix_loading }) async {
    final loadingNotifier = ref.read(loading_state(prefix_loading).notifier);
    loadingNotifier.state = LoadingIndicatorState.loading;

    // Simulate a delay to show loading state
    // await Future.delayed(Duration(seconds: 1));

    final dio = Dio();
    try{
      final response = await dio.get(ROUTE_REQUEST_GAMES);
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data as List<dynamic>;
        final List<ProductModel> products = data.map((item) => ProductModel.fromJson(item)).toList();
        state = AsyncValue.data(state.value!.copyWith(
          products: products
        ));
        loadingNotifier.state = LoadingIndicatorState.hasData;
      }else{
        print('Error fetching data: ${response.statusCode}');
        loadingNotifier.state = LoadingIndicatorState.error;  
      }
    }catch(e){
      print('Error fetching data: $e');
      loadingNotifier.state = LoadingIndicatorState.error;
    }


  }


  Future<void> fetch_my_game({ required String prefix_loading }) async {
    final loadingNotifier = ref.read(loading_state(prefix_loading).notifier);
    loadingNotifier.state = LoadingIndicatorState.loading;

    final dio = Dio();
    try{
      final currentSession = Supabase.instance.client.auth.currentSession;
      if (currentSession == null) {
        print('No current session found.');
        loadingNotifier.state = LoadingIndicatorState.error;
        return;
      }

      final response = await dio.get(
        ROUTE_REQUEST_GAMES_BYUSER,
        queryParameters: {'id': currentSession.user.id},
        options: Options(validateStatus: (_) => true), // accept all responses
      );
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data as List<dynamic>;
        final List<ProductModel> products = data.map((item) => ProductModel.fromJson(item)).toList();
        state = AsyncValue.data(state.value!.copyWith(
          my_products: products
        ));
        loadingNotifier.state = LoadingIndicatorState.hasData;
      }else{
        print('Error fetching my games: ${response.statusCode}');
        loadingNotifier.state = LoadingIndicatorState.error;
      }

    }catch(e){
      print('Error fetching my games: $e');
      loadingNotifier.state = LoadingIndicatorState.error;
    }


  }

  void clear_my_game() {
    state = AsyncValue.data(state.value!.copyWith(
      my_products: []
    ));
  }


  Future<void> search({ String? query, required String prefix_loading }) async {
    final loadingNotifier = ref.read(loading_state(prefix_loading).notifier);
    loadingNotifier.state = LoadingIndicatorState.loading;

    _debounce?.cancel();
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      try {
        _cancelToken!.cancel();
        print("Previous search request canceled.");
      } catch (e) {
        print("Error canceling request: $e");
        loadingNotifier.state = LoadingIndicatorState.error;
      }
    }

    _debounce = Timer(Duration(milliseconds: 500), () async {
      loadingNotifier.state = LoadingIndicatorState.loading;
      _cancelToken?.cancel();
      _cancelToken = CancelToken();

      final dio = Dio();
      try{
        final response = await dio.get(
          ROUTE_REQUEST_SEARCH_GAMES,
          queryParameters: {'q': query ?? ''},
          cancelToken: _cancelToken,
          options: Options(validateStatus: (_) => true), // accept all responses
        );
        if (response.statusCode == 200 && response.data != null) {
          final List<dynamic> data = response.data as List<dynamic>;
          final List<ProductModel> products = data.map((item) => ProductModel.fromJson(item)).toList();
          _searchResults = products;
          loadingNotifier.state = LoadingIndicatorState.hasData;
        }else{
          clearSearch();
          loadingNotifier.state = LoadingIndicatorState.error;
        }
      }catch(e){
        print('Error fetching data: $e');
        clearSearch();
        loadingNotifier.state = LoadingIndicatorState.error;
      }
      
    });
  }

  Future<void> add_product(Map<String, dynamic>? params, { required String prefix_loading, Function()? onCallback }) async{

    if( params == null) return;
    final loadingNotifier = ref.read(loading_state(prefix_loading).notifier);
    loadingNotifier.state = LoadingIndicatorState.loading;

    final dio = Dio();
    final supabase = Supabase.instance.client;
    final accessToken = supabase.auth.currentSession?.accessToken;
    if (accessToken == null) {
      print('No access token found.');
      loadingNotifier.state = LoadingIndicatorState.error;
      return;
    }
    
    final formDataRaw = {
      ...params,
    };
    if( params.containsKey(['image'])){
      final imageFile = params['image'] as File;
      formDataRaw['image'] = await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      );
    }

    final formData = FormData.fromMap(formDataRaw);

    try{
      final response = await dio.post(
        ROUTE_REQUEST_ADD_GAME,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'multipart/form-data',
          },
          validateStatus: (_) => true, // Accept all responses
        ),
      );
      if (response.statusCode == 201 && response.data != null) {
        final ProductModel newProduct = ProductModel.fromJson(response.data['game']);
        state = AsyncValue.data(state.value!.copyWith(
          my_products: [ ...state.value?.my_products ?? [], newProduct ] 
        ));
        loadingNotifier.state = LoadingIndicatorState.hasData;

        if( onCallback != null) {
          onCallback();
        }
      }else{
        print('Error adding product: ${response.statusCode}');
        loadingNotifier.state = LoadingIndicatorState.error;  
      }
    }catch(e){
      print('Error adding product: $e');
      loadingNotifier.state = LoadingIndicatorState.error;
    }
  }


  void clearSearch() {
    _debounce?.cancel();
    _searchResults = [];
  }


}

final product_state = AsyncNotifierProvider<ProductState, ProductModelState>(ProductState.new);