import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/recipe_bloc.dart';
import '../bloc/recipe_event.dart';
import '../bloc/recipe_state.dart';
import '../models/recipe.dart';

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({super.key});

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<RecipeBloc>().add(LoadMoreRecipes());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Explorer'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search Recipes',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                context.read<RecipeBloc>().add(SearchRecipes(value));
              },
            ),
          ),
          _CategoryFilterChips(),
          Expanded(
            child: BlocBuilder<RecipeBloc, RecipeState>(
              builder: (context, state) {
                if (state is RecipeLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is RecipeListLoaded) {
                  if (state.displayedRecipes.isEmpty) {
                    return const Center(
                        child: Text('No any recipes found matching criteria.'));
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: state.displayedRecipes.length + (state.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= state.displayedRecipes.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      final recipe = state.displayedRecipes[index];
                      return _RecipeListItem(recipe: recipe);
                    },
                  );
                }
                return const Center(child: Text('An error occurred.'));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryFilterChips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeBloc, RecipeState>(
      buildWhen: (previous, current) =>
      current is RecipeListLoaded &&
          previous is RecipeListLoaded &&
          previous.currentCategoryFilter != current.currentCategoryFilter,
      builder: (context, state) {
        if (state is! RecipeListLoaded) return const SizedBox.shrink();

        final allCategories = RecipeCategory.values;
        final selectedCategory = state.currentCategoryFilter;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              _buildFilterChip(
                context,
                label: 'All',
                isSelected: selectedCategory == null,
                onTap: () =>
                    context.read<RecipeBloc>().add(const FilterRecipes(null)),
              ),
              ...allCategories.map((category) => _buildFilterChip(
                context,
                label: category.name[0].toUpperCase() + category.name.substring(1),
                isSelected: selectedCategory == category,
                onTap: () => context.read<RecipeBloc>().add(FilterRecipes(category)),
              )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(
      BuildContext context, {
        required String label,
        required bool isSelected,
        required VoidCallback onTap,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ActionChip(
        label: Text(label),
        avatar: isSelected ? const Icon(Icons.check) : null,
        onPressed: onTap,
        backgroundColor: isSelected ? Colors.indigo.shade100 : Colors.grey.shade200,
        side: isSelected
            ? const BorderSide(color: Colors.indigo)
            : BorderSide.none,
      ),
    );
  }
}

class _RecipeListItem extends StatelessWidget {
  final Recipe recipe;

  const _RecipeListItem({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      elevation: 2,
      child: ListTile(
        leading: SizedBox(
          width: 80,
          height: 80,
          child: Image.network(
            recipe.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
          ),
        ),
        title: Text(
          recipe.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
            'Category: ${recipe.category.name[0].toUpperCase() + recipe.category.name.substring(1)}'),
        trailing: IconButton(
          icon: Icon(
            recipe.isFavorite ? Icons.star : Icons.star_border,
            color: recipe.isFavorite ? Colors.amber : Colors.grey,
          ),
          onPressed: () {
            context.read<RecipeBloc>().add(ToggleFavorite(recipe.id));
          },
        ),
        onTap: () {
          context.read<RecipeBloc>().add(SelectRecipe(recipe.id));
          context.go('/details/${recipe.id}');
        },
      ),
    );
  }
}