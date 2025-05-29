import 'package:flutter_code_challenge/state/loading_state.dart';
import 'package:flutter_code_challenge/state/product_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _AuthStateModel{
  final bool? is_login;

  _AuthStateModel({
    this.is_login
  });

  _AuthStateModel copyWith({
    bool? is_login
  }){
    return _AuthStateModel(
      is_login: is_login ?? this.is_login
    );
  }
}

class ProfileState extends AsyncNotifier<_AuthStateModel> {

  @override
  Future<_AuthStateModel> build() async{
    return _AuthStateModel(
      is_login: false
    );
  }


  Future<void> auto_login({ required String prefix_loading }) async {
    final loadingNotifier = ref.read(loading_state(prefix_loading).notifier);

    try {
      loadingNotifier.state = LoadingIndicatorState.loading;
      final supabase = Supabase.instance.client;
      await supabase.auth.refreshSession(); // Get new session when app start
      final currentSession = supabase.auth.currentSession;

      if (currentSession == null) {
        loadingNotifier.state = LoadingIndicatorState.error;
        ref.read(profile_autologin_message_error.notifier).state = 'Login session expired';
        return;
      }
      
      state = AsyncData(state.value!.copyWith(
        is_login: true
      ));

      loadingNotifier.state = LoadingIndicatorState.hasData;
      ref.read(profile_autologin_message_error.notifier).state = 'Login Success';

      Future.microtask(() async {
        ref.read(product_state.notifier).
          fetch_my_game(prefix_loading: 'my_product_init_loading');
          return;
      });
      
    } catch (e) {
      loadingNotifier.state = LoadingIndicatorState.error;
      print('⁉️ Auto Login Error: $e');
    }
  }


  Future<void> signIn(Map<String, dynamic>? params, { required String prefix_loading }) async {
    if( params == null) return;
    final loadingNotifier = ref.read(loading_state(prefix_loading).notifier);

    try{
      loadingNotifier.state = LoadingIndicatorState.loading;
      final supabase = Supabase.instance.client;
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: params['email'],
        password: params['password'],
      );
      if (res.user == null || res.session == null) {
        loadingNotifier.state = LoadingIndicatorState.error;
        ref.read(profile_message_error.notifier).state = 
          'Sign in failed: Invalid credentials or no session returned.';
          return;
      }

      state = AsyncData(state.value!.copyWith(
        is_login: true
      ));

      loadingNotifier.state = LoadingIndicatorState.hasData;
      ref.read(profile_message_error.notifier).state = 'Login Success';

      Future.microtask(() async {
        ref.read(product_state.notifier).
          fetch_my_game(prefix_loading: 'my_product_init_loading');
          return;
      });

    }catch(e){
      loadingNotifier.state = LoadingIndicatorState.error;
      ref.read(profile_message_error.notifier).state = 
        'SignIn error account not found or invalid credentials';
    }
  }


  Future<void> signUp(Map<String, dynamic>? params,{ required String prefix_loading }) async {
    if( params == null) return;
    final loadingNotifier = ref.read(loading_state(prefix_loading).notifier);

    try{
      loadingNotifier.state = LoadingIndicatorState.loading;
      final supabase = Supabase.instance.client;
      final AuthResponse res = await supabase.auth.signUp(
        email: params['email'],
        password: params['password'],
      );

      if (res.user == null || res.session == null) {
        loadingNotifier.state = LoadingIndicatorState.error;
        ref.read(profile_message_error.notifier).state = 
          'Sign up failed: Invalid credentials or no session returned.';
          return;
      }

      loadingNotifier.state = LoadingIndicatorState.hasData;
      ref.read(profile_message_error.notifier).state = 'SignUp success';
    }catch(e){
      loadingNotifier.state = LoadingIndicatorState.error;
      if( e is AuthApiException) {
        ref.read(profile_message_error.notifier).state = 
          "${e.message}";
      }
    }
  }

  Future<void> logout({ required String prefix_loading }) async {
    final loadingNotifier = ref.read(loading_state(prefix_loading).notifier);
    loadingNotifier.state = LoadingIndicatorState.loading;
    try{
      final supabase = Supabase.instance.client;
      await supabase.auth.signOut();
      state = AsyncData(state.value!.copyWith(
        is_login: false
      ));
      Future.microtask(() {
        ref.read(product_state.notifier).clear_my_game();
        return;
      });
      loadingNotifier.state = LoadingIndicatorState.hasData;
    }catch(e){
      loadingNotifier.state = LoadingIndicatorState.error;
    }
  }

  void login_by_provider() async{
    final loadingNotifier = ref.read(loading_state('login_by_provider').notifier);
    loadingNotifier.state = LoadingIndicatorState.loading;
    await Future.delayed(Duration(milliseconds: 500));
    try{
      state = AsyncData(state.value!.copyWith(
        is_login: true
      ));
      Future.microtask(() async {
        ref.read(product_state.notifier).
          fetch_my_game(prefix_loading: 'my_product_init_loading');
          return;
      });
      loadingNotifier.state = LoadingIndicatorState.hasData;
    } catch(e){
      loadingNotifier.state = LoadingIndicatorState.error;
    }
  }

}

final profile_state = AsyncNotifierProvider<ProfileState, _AuthStateModel>( ProfileState.new );
final profile_message_error = StateProvider<String>((ref) => '' );
final profile_autologin_message_error = StateProvider<String>((ref) => '' );