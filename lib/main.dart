import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'bloc/recipe_bloc.dart';
import 'bloc/recipe_event.dart';
import 'pages/recipe_list_page.dart';
import 'pages/recipe_details_page.dart';

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const RecipeListPage();
      },
      routes: [
        GoRoute(
          path: 'details/:id',
          builder: (BuildContext context, GoRouterState state) {
            return const RecipeDetailsPage();
          },
        ),
      ],
    ),
  ],
  initialLocation: '/',
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const RecipeExplorerApp());
}

class RecipeExplorerApp extends StatelessWidget {
  const RecipeExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecipeBloc()..add(LoadRecipes()),
      child: MaterialApp.router(
        title: 'Recipe Explorer',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        routerConfig: _router,
      ),
    );
  }
}