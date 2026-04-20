import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../features/main/presentation/pages/main_page.dart';
import '../../../features/news/presentation/pages/news_page.dart';
import '../../../features/news/presentation/pages/article_detail_page.dart';
import '../../../features/news/domain/entities/article_entity.dart';
import 'route_path.dart';

class AppRoute {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final GoRouter _routerX = GoRouter(
    initialLocation: RoutePath.mainPagePath,
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [

      // ── Article Detail ────────────────────────────────────────────────
      // GoRoute(
      //   name: RoutePath.articleDetailPage,
      //   path: RoutePath.articleDetailPagePath,
      //   pageBuilder: (context, state) {
      //     final article = state.extra as ArticleEntity;
      //     return NoTransitionPage(child: ArticleDetailPage(article: article));
      //   },
      // ),

      // ///main page route
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // the UI shell
          return MainPage(navigationShell: navigationShell);
        },
        branches: [
          ///Home branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePath.mainPagePath,
                builder: (context, state) => const NewsPage(),
              ),
            ],
          ),
          /// Chat branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePath.chatPagePath,
                builder: (context, state) => const Scaffold(body: Center(child: Text("Chat Page"))),
              ),
            ],
          ),
          /// Cart branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePath.cartPagePath,
                builder: (context, state) => const Scaffold(body: Center(child: Text("Cart Page"))),
              ),
            ],
          ),
          /// Profile branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePath.profilePagePath,
                builder: (context, state) => const Scaffold(body: Center(child: Text("Profile Page"))),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text("Something went wrong"))),
  );

  static GoRouter get router => _routerX;
}
