abstract class HomePageState {}

class HomePageInitial extends HomePageState {}

class HomePageProductsLoading extends HomePageState {}

class HomePageProductsSuccess extends HomePageState {}

class HomePageProductsError extends HomePageState {
  HomePageProductsError(this.message);
  final String message;
}

class HomePageCategoriesLoading extends HomePageState {}

class HomePageCategoriesSuccess extends HomePageState {}

class HomePageCategoriesError extends HomePageState {
  HomePageCategoriesError(this.message);
  final String message;
}

class HomeToggleButton extends HomePageState {}

class HomeIsDarkMode extends HomePageState {}

class ChangeIndexState extends HomePageState {}

class ChangeReviewIndexState extends HomePageState {}

class HomePageGetProducts extends HomePageState {}
