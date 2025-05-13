import 'package:flutter/material.dart';
import 'package:flutter_code_challenge/state/product_state.dart';
import 'package:flutter_code_challenge/state/router_state.dart';
import 'package:flutter_code_challenge/state/database_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

    // Warn-up app loading
    final hasInitialized = useState<bool>(false);

    useEffect((){
      Future.microtask(() async {
        await DatabaseState.instance.init();
        ref.read(product_state.notifier).fetchInit(prefix_loading: 'product_init_loading');
        hasInitialized.value = true;
      }); 
      return null;
    }, []);

    return MaterialApp.router(
      scaffoldMessengerKey: _scaffoldKey,
      debugShowCheckedModeBanner: false,
      routerConfig: _router_state,
      title: 'Devolver Digital',
      builder: ( mediaContext, child ){  
        
        if( !hasInitialized.value )
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        
        // Disable text scaling
        return MediaQuery.withClampedTextScaling(
          maxScaleFactor: 1.0,
          child: child!
        );
      }
    );
  }

}