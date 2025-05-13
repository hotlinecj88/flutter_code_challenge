import 'package:hooks_riverpod/hooks_riverpod.dart';

enum LoadingIndicatorState{
  initial,
  loading,
  hasData,
  error
}

final loading_state = StateProvider.family<LoadingIndicatorState, String>(
  (ref, id) => LoadingIndicatorState.initial,
);