import 'package:equatable/equatable.dart';

abstract class NavigationEvent extends Equatable{}

class AllFeature extends NavigationEvent{
  final String feature;

  AllFeature(this.feature);

  @override
  List<Object?> get props => [feature];
}

class RemoveFeature extends NavigationEvent{
  final String feature;

  RemoveFeature(this.feature);

  @override
  List<Object?> get props => [feature];
}

class ReplaceFeature extends NavigationEvent{
  final String feature;
  final int index;
  ReplaceFeature(this.feature, this.index);

  @override
  List<Object?> get props => [feature,index];
}

class SearchFeature extends NavigationEvent {
  final String query;
  final List<String>? allFeatures;

  SearchFeature(this.query, {this.allFeatures});

  @override
  List<Object?> get props => [query, allFeatures];
}

class OpenSearchView extends NavigationEvent{
  @override
  List<Object?> get props => [];

}

class CloseSearchView extends NavigationEvent{
  @override
  List<Object?> get props => [];
}

class ChangeTab extends NavigationEvent{
  final int index;

  ChangeTab(this.index);

  @override
  List<Object?> get props => [index];
}

class ChangeButton extends NavigationEvent{
  final int index;
  ChangeButton(this.index);

  @override
  List<Object?> get props => [index];
}
class InitializeNavigationEvent extends NavigationEvent {
  @override
  List<Object?> get props => [];
}
