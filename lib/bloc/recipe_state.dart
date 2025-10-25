import 'package:equatable/equatable.dart';
import '../models/recipe.dart';

abstract class RecipeState extends Equatable {
  const RecipeState();

  @override
  List<Object?> get props => [];
}

class RecipeLoading extends RecipeState {}

class RecipeListLoaded extends RecipeState {
  final List<Recipe> recipes;
  final List<Recipe> displayedRecipes;
  final int offset;
  final String searchTerm;
  final RecipeCategory? currentCategoryFilter;
  final Recipe? selectedRecipe;
  final bool hasMore;


  const RecipeListLoaded({
    required this.recipes,
    required this.displayedRecipes,
    this.offset = 0,
    this.searchTerm = '',
    this.currentCategoryFilter,
    this.selectedRecipe,
    this.hasMore = true,
  });

  RecipeListLoaded copyWith({
    List<Recipe>? recipes,
    List<Recipe>? displayedRecipes,
    int? offset,
    String? searchTerm,
    RecipeCategory? currentCategoryFilter,
    Recipe? selectedRecipe,
    bool? hasMore,
  }) {
    return RecipeListLoaded(
      recipes: recipes ?? this.recipes,
      displayedRecipes: displayedRecipes ?? this.displayedRecipes,
      offset: offset ?? this.offset,
      searchTerm: searchTerm ?? this.searchTerm,
      currentCategoryFilter: currentCategoryFilter,
      selectedRecipe: selectedRecipe,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [
    recipes,
    displayedRecipes,
    offset,
    searchTerm,
    currentCategoryFilter,
    selectedRecipe,
    hasMore,
  ];
}

class RecipeError extends RecipeState {}