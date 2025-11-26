import 'package:shared_core/bloc/navi_bloc/navi_state.dart';

class OpenSearchViewUseCase{
  NavigationState execute(NavigationState state){
    return state.copyWith(isSearchViewOpen: !state.isSearchViewOpen);
  }
}