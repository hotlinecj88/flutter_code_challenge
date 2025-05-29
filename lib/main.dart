import 'package:flutter/material.dart';
import 'package:flutter_code_challenge/config/app_config.dart';
import 'package:flutter_code_challenge/extensions/snackbar_extension.dart';
import 'package:flutter_code_challenge/pages/profile/states/profile_state.dart';
import 'package:flutter_code_challenge/state/product_state.dart';
import 'package:flutter_code_challenge/state/router_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

   await Supabase.initialize(
    url: SUPABASE_URL,
    anonKey: SUPABASE_ANON_KEY,
  );
  
  final container = ProviderContainer();
  // Loading state to memory
  container.read(product_state);

  runApp( UncontrolledProviderScope( 
    container: container,
    child: App())
  );

}


class App extends HookConsumerWidget{ 
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _router_state = ref.watch(router_state);

    useEffect((){
      Future.microtask(() async {
        ref.read(profile_state.notifier).auto_login(prefix_loading: 'auto_login_loading');
        ref.read(product_state.notifier).fetchInit(prefix_loading: 'product_init_loading');
        return;
      }); 
      return null;
    }, []);

    ref.listen(profile_autologin_message_error, (_, errorMessage ){
      if (errorMessage.isNotEmpty) {
        root_navigator_key.currentContext?.showSnackbar(
          title: errorMessage,
          showDuration: Duration(milliseconds: 2000),
          onClose: (){
            WidgetsBinding.instance.addPostFrameCallback((_){
              ref.read(profile_autologin_message_error.notifier).state = '';
            });
          }
        );
      }
    });

    return MaterialApp.router(
      scaffoldMessengerKey: _scaffoldKey,
      debugShowCheckedModeBanner: false,
      routerConfig: _router_state,
      title: 'Devolver Digital',
      builder: ( mediaContext, child ){  
        
        // Disable text scaling
        return MediaQuery.withClampedTextScaling(
          maxScaleFactor: 1.0,
          child: child!
        );
      }
    );
  }

}