import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_code_challenge/blocks/block_button_entry.dart';
import 'package:flutter_code_challenge/blocks/block_unfocus_tap.dart';
import 'package:flutter_code_challenge/pages/profile/states/profile_state.dart';
import 'package:flutter_code_challenge/state/loading_state.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class ProfileAuthentication extends HookConsumerWidget{

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signin_loading = ref.watch(loading_state('signin_loading'));
    final signup_loading = ref.watch(loading_state('signup_loading'));
    
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final isLogin = useState<bool>(true);
    final textPage = isLogin.value ? 'Login' : 'Register'; 

    final theme = Theme.of(context);
    final buttonBackground = theme.colorScheme.primary;

    final emailInput = useTextEditingController();
    final passwordInput = useTextEditingController();


    return 
        signin_loading == LoadingIndicatorState.loading || 
        signup_loading == LoadingIndicatorState.loading
      ? Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        )
      : BlockUnfocusTap(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 24.0),
              Center(
                child: Text(
                  textPage,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Form(
                key: formKey,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailInput,
                        decoration: InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: passwordInput,
                        obscureText: true,
                        decoration: InputDecoration(labelText: 'Password'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8.0),
          
              TextButton(
                onPressed: () {
                  isLogin.value = !isLogin.value;
                },
                child: Text(
                  isLogin.value
                    ? 'Don\'t have an account? Register'
                    : 'Already have an account? ',
                ),
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: SupaSocialsAuth(
                  showSuccessSnackBar: false,
                  nativeGoogleAuthConfig: NativeGoogleAuthConfig(
                    webClientId: '987218376325-9bb8unv50nniukbigrabuigad509q0cc.apps.googleusercontent.com',
                    iosClientId: '987218376325-o3t499n17u7eb6p5f86j627eea8kp4qt.apps.googleusercontent.com',
                  ),
                  socialProviders: [
                    OAuthProvider.google,
                  ],
                  colored: true,
                  onSuccess: (Session response) {
                    ref.read(profile_state.notifier).login_by_provider();
                  },
                  onError: (e) {
                    print('⁉️ Login Error: $e');
                  },
                ),
              ),
          
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                width: double.infinity,
                child: BlockButtonEntry(
                  buttonColor: buttonBackground,
                  onPressed: () {

                    if( isLogin.value == true){
                      // Signin
                      if (formKey.currentState?.validate() == true) {
                        ref.read(profile_state.notifier).signIn(
                          {
                            'email': emailInput.text,
                            'password': passwordInput.text,
                          },
                          prefix_loading: 'signin_loading'
                        );
                      }
                    }else{
                      // Signup
                      if (formKey.currentState?.validate() == true) {
                        ref.read(profile_state.notifier).signUp(
                          {
                            'email': emailInput.text,
                            'password': passwordInput.text,
                          },
                          prefix_loading: 'signup_loading'
                        );
                      }
                    }
                  },
                  title: 'Submit',
                ),
              )
          
              
            ],
          ),
        ),
      )
    );
  }

}