abstract class NavigationEvent{}

class AllFeature extends NavigationEvent{
  final String feature;

  AllFeature(this.feature);
}

class RemoveFeature extends NavigationEvent{
  final String feature;

  RemoveFeature(this.feature);
}

class ReplaceFeature extends NavigationEvent{
  final String feature;
  final int index;
  ReplaceFeature(this.feature, this.index);
}

class ChangeTab extends NavigationEvent{
  final int index;

  ChangeTab(this.index);
}

class ChangeButton extends NavigationEvent{
  final int index;
  ChangeButton(this.index);
}
