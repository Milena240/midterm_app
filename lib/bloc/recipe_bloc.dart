import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'recipe_event.dart';
import 'recipe_state.dart';
import '../models/recipe.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  RecipeBloc() : super(RecipeLoading()) {
    on<LoadRecipes>(_onLoadRecipes);
    on<SearchRecipes>(_onSearchRecipes);
    on<FilterRecipes>(_onFilterRecipes);
    on<LoadMoreRecipes>(_onLoadMoreRecipes);
    on<SelectRecipe>(_onSelectRecipe);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  final _uuid = const Uuid();
  final _limit = 7;

  late List<Recipe> _allRecipes;

  final List<Recipe> _initialRecipes = [
    for (int i = 1; i <= 17; i++)
      Recipe(
        id: const Uuid().v4(),
        title: 'Spicy Veggie Delight $i',
        category: i % 4 == 0
            ? RecipeCategory.dessert
            : i % 3 == 0
            ? RecipeCategory.appetizer
            : RecipeCategory.mainCourse,
        imageUrl: 'https://picsum.photos/id/${100}/300/200',
        description:
        'A delightful mix of fresh vegetables with a spicy kick. Perfect for a quick dinner.',
        ingredients: const ['Bell Peppers', 'Onion', 'Garlic', 'Chili Sauce', 'Rice'],
        isFavorite: i % 5 == 0,
      ),
    Recipe(
      id: const Uuid().v4(),
      title: 'Chocolate Lava Cake',
      category: RecipeCategory.dessert,
      imageUrl: 'https://picsum.photos/id/${100}/300/200',
      description: 'Rich, decadent chocolate cake.',
      ingredients: const ['Chocolate', 'Butter', 'Sugar', 'Eggs', 'Flour'],
    ),
    Recipe(
      id: const Uuid().v4(),
      title: 'Summer Berry Smoothie',
      category: RecipeCategory.drink,
      imageUrl: 'https://picsum.photos/id/${100}/300/200',
      description: 'A refreshing and healthy drink made with seasonal berries.',
      ingredients: const ['Mixed Berries', 'Yogurt', 'Milk', 'Honey'],
    ),
    Recipe(
      id: const Uuid().v4(),
      title: 'Classic Caesar Salad',
      category: RecipeCategory.salad,
      imageUrl: 'https://picsum.photos/id/${100}/300/200',
      description: 'Crisp romaine lettuce, croutons, and Parmesan cheese with Caesar dressing.',
      ingredients: const ['Lettuce', 'Croutons', 'Parmesan', 'Caesar Dressing'],
    ),
  ];

  List<Recipe> _getFilteredAndSearchedRecipes(
      String searchTerm, RecipeCategory? categoryFilter) {
    var filteredList = _allRecipes;

    if (categoryFilter != null) {
      filteredList = filteredList
          .where((recipe) => recipe.category == categoryFilter)
          .toList();
    }

    if (searchTerm.isNotEmpty) {
      filteredList = filteredList
          .where((recipe) =>
          recipe.title.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    }
    return filteredList;
  }

  void _onLoadRecipes(LoadRecipes event, Emitter<RecipeState> emit) {
    _allRecipes = List<Recipe>.from(_initialRecipes);
    final initialDisplayed = _allRecipes.take(_limit).toList();
    final hasMore = _allRecipes.length > _limit;

    emit(RecipeListLoaded(
      recipes: _allRecipes,
      displayedRecipes: initialDisplayed,
      offset: _limit,
      hasMore: hasMore,
    ));
  }

  void _onSearchRecipes(SearchRecipes event, Emitter<RecipeState> emit) {
    if (state is RecipeListLoaded) {
      final currentState = state as RecipeListLoaded;

      final searchTerm = event.searchTerm.trim();

      final filteredList = _getFilteredAndSearchedRecipes(
          searchTerm, currentState.currentCategoryFilter);

      final displayed = filteredList.take(_limit).toList();
      final hasMore = filteredList.length > _limit;

      emit(currentState.copyWith(
        recipes: filteredList, // The currently searchable/filterable pool
        displayedRecipes: displayed,
        searchTerm: searchTerm,
        offset: displayed.length,
        hasMore: hasMore,
      ));
    }
  }

  void _onFilterRecipes(FilterRecipes event, Emitter<RecipeState> emit) {
    if (state is RecipeListLoaded) {
      final currentState = state as RecipeListLoaded;

      // Get the full filtered/searched list based on allRecipes
      final filteredList = _getFilteredAndSearchedRecipes(
          currentState.searchTerm, event.category);

      // Apply initial pagination to the new list
      final displayed = filteredList.take(_limit).toList();
      final hasMore = filteredList.length > _limit;

      emit(currentState.copyWith(
        recipes: filteredList, // The currently searchable/filterable pool
        displayedRecipes: displayed,
        currentCategoryFilter: event.category,
        offset: displayed.length,
        hasMore: hasMore,
      ));
    }
  }

  void _onLoadMoreRecipes(LoadMoreRecipes event, Emitter<RecipeState> emit) async {
    if (state is RecipeListLoaded) {
      final currentState = state as RecipeListLoaded;

      if (!currentState.hasMore) return; // Stop if no more to load

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 700));

      final allFiltered = currentState.recipes;
      final newOffset = currentState.offset + _limit;

      final newItems = allFiltered.skip(currentState.offset).take(_limit).toList();
      final updatedDisplayed = List<Recipe>.from(currentState.displayedRecipes)..addAll(newItems);
      final hasMore = updatedDisplayed.length < allFiltered.length;

      emit(currentState.copyWith(
        displayedRecipes: updatedDisplayed,
        offset: newOffset,
        hasMore: hasMore,
      ));
    }
  }

  void _onSelectRecipe(SelectRecipe event, Emitter<RecipeState> emit) {
    if (state is RecipeListLoaded) {
      final currentState = state as RecipeListLoaded; // <-- FIX: Semicolon added
      final selected = _initialRecipes.firstWhere((r) => r.id == event.id);

      emit(currentState.copyWith(
        selectedRecipe: selected,
      ));
    }
  }

  void _onToggleFavorite(ToggleFavorite event, Emitter<RecipeState> emit) {
    if (state is RecipeListLoaded) {
      final currentState = state as RecipeListLoaded; // <-- FIX: Semicolon added

      // Update the main source list
      _allRecipes = _allRecipes.map((recipe) {
        return recipe.id == event.id
            ? recipe.copyWith(isFavorite: !recipe.isFavorite)
            : recipe;
      }).toList();

      // Find the updated recipe
      final updatedRecipe = _allRecipes.firstWhere((r) => r.id == event.id);

      // Re-run the filter/search logic to update the `recipes` property (the pool)
      final newRecipesPool = _getFilteredAndSearchedRecipes(
          currentState.searchTerm, currentState.currentCategoryFilter);

      // Reconstruct the displayed list to reflect the favorite change
      final updatedDisplayed = currentState.displayedRecipes
          .map((d) {
        final r = newRecipesPool.firstWhere((r) => r.id == d.id);
        return r.id == event.id ? updatedRecipe : r;
      }).toList();

      // Check if the selected recipe needs updating
      final newSelectedRecipe = currentState.selectedRecipe?.id == event.id
          ? updatedRecipe
          : currentState.selectedRecipe;

      emit(currentState.copyWith(
        recipes: newRecipesPool,
        displayedRecipes: updatedDisplayed,
        selectedRecipe: newSelectedRecipe,
        // Keep offset and hasMore the same
        offset: currentState.offset,
        hasMore: currentState.hasMore,
      ));
    }
  }
}