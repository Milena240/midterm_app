import 'package:equatable/equatable.dart';

enum RecipeCategory {
  mainCourse,
  dessert,
  appetizer,
  breakfast,
  drink,
  salad,
}

class Recipe extends Equatable {
  final String id;
  final String title;
  final RecipeCategory category;
  final String imageUrl;
  final String description;
  final List<String> ingredients;
  final bool isFavorite;

  const Recipe({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.description,
    required this.ingredients,
    this.isFavorite = false,
  });

  Recipe copyWith({
    String? id,
    String? title,
    RecipeCategory? category,
    String? imageUrl,
    String? description,
    List<String>? ingredients,
    bool? isFavorite,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    category,
    imageUrl,
    description,
    ingredients,
    isFavorite,
  ];
}