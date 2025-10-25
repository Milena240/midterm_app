import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/recipe_bloc.dart';
import '../bloc/recipe_state.dart';
import '../bloc/recipe_event.dart';

class RecipeDetailsPage extends StatelessWidget {
  const RecipeDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Details'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          if (state is RecipeListLoaded) {
            final recipe = state.selectedRecipe;

            if (recipe == null) {
              return const Center(child: Text('Recipe details not found!'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    recipe.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      color: Colors.grey.shade300,
                      child: const Center(child: Icon(Icons.broken_image, size: 50)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        recipe.title,
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(
                          recipe.isFavorite ? Icons.star : Icons.star_border,
                          color: recipe.isFavorite ? Colors.amber : Colors.grey,
                          size: 30,
                        ),
                        onPressed: () {
                          context.read<RecipeBloc>().add(ToggleFavorite(recipe.id));
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Category: ${recipe.category.name[0].toUpperCase() + recipe.category.name.substring(1)}',
                    style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.indigo.shade700),
                  ),
                  const Divider(height: 32),
                  const Text('Description',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(recipe.description, style: const TextStyle(fontSize: 16)),
                  const Divider(height: 32),
                  const Text('Ingredients',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...recipe.ingredients
                      .map((ingredient) => Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text('• $ingredient',
                        style: const TextStyle(fontSize: 16)),
                  ))
                      .toList(),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}