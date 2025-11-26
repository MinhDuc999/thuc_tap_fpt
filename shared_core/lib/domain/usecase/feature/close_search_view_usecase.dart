import 'package:flutter/material.dart';
import 'package:shared_core/bloc/navi_bloc/navi_state.dart';

class CloseSearchViewUseCase{
  NavigationState execute(NavigationState state, {FocusNode? focusNode}){
    focusNode?.unfocus();
    return state.copyWith(
      isSearchViewOpen: false
    );
  }
}