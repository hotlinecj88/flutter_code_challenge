import 'package:flutter/material.dart';
import 'package:flutter_code_challenge/extensions/snackbar_extension.dart';
import 'package:flutter_code_challenge/pages/profile/screens/profile_authentication.dart';
import 'package:flutter_code_challenge/pages/profile/screens/profile_user.dart';
import 'package:flutter_code_challenge/pages/profile/states/profile_state.dart';
import 'package:flutter_code_challenge/state/loading_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TabProfile extends HookConsumerWidget{
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final _profile_state = ref.watch(profile_state);
    final auto_login_loading = ref.watch(loading_state('auto_login_loading'));
    final logout_loading = ref.watch(loading_state('logout_loading'));
    final login_by_provider = ref.watch(loading_state('login_by_provider'));

    ref.listen(profile_message_error, (_, errorMessage ){
      if (errorMessage.isNotEmpty) {
        context.showSnackbar(
          title: errorMessage,
          showDuration: Duration(milliseconds: 2000),
          onClose: (){
            WidgetsBinding.instance.addPostFrameCallback((_){
              ref.read(profile_message_error.notifier).state = '';
            });
          }
        );
      }
    });

    if(
      auto_login_loading == LoadingIndicatorState.loading ||
      logout_loading == LoadingIndicatorState.loading || 
      login_by_provider == LoadingIndicatorState.loading
    ){
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if( _profile_state.value?.is_login == true ){
      return ProfileUser();
    }
    
    return ProfileAuthentication();
  }

}