import 'package:business/redux/app_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/pages/splash_page.dart';
import 'package:ui/snack_bars/base_snack_bar.dart';

import '../connectors/forgot_password_page_connector.dart';
import '../connectors/home_page_connector.dart';
import '../connectors/log_in_page_connector.dart';
import '../connectors/registration_page_connector.dart';
import '../connectors/reset_password_page_connector.dart';
import '../dialogs/exception_dialog.dart';
import 'routers_flow.dart';

class Routes {
  static const initial = 'initial';
  static const splash = 'splash';
  static const home = 'home';
  static const login = 'login';
  static const registration = 'registration';
  static const forgotPassword = 'forgotPassword';
}

GoRouter get router => RoutersMap.instance._currentRouter;

class RoutersMap {
  RoutersMap._();

  static final RoutersMap instance = RoutersMap._();

  late GoRouter _currentRouter = _splashRouter;

  RoutersFlow _currentFlow = const SplashFlow();

  GoRouter routerWithFlow(RoutersFlow flow) {
    if (_currentFlow == flow) {
      return _currentRouter;
    }

    _currentFlow = flow;

    final newRouter = switch (flow) {
      AuthFlow() => _authRouter,
      SplashFlow() => _splashRouter,
      HomeFlow() => _homeRouter,
    };

    _currentRouter = newRouter;

    return newRouter;
  }

  GoRouter get _splashRouter => GoRouter(
        initialLocation: '/splash',
        routes: [
          GoRoute(
            path: '/splash',
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: const ExceptionDialog<AppState>(child: SplashPage()),
            ),
          ),
        ],
      );

  GoRouter get _homeRouter => GoRouter(
        initialLocation: '/home',
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: const ExceptionDialog<AppState>(
                child: HomePageConnector(),
              ),
            ),
          ),
        ],
      );

  GoRouter get _authRouter => GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            name: Routes.login,
            path: '/',
            builder: (context, state) => const ExceptionDialog<AppState>(
              child: LogInPageConnector(),
            ),
            routes: [
              GoRoute(
                name: Routes.registration,
                path: 'registration',
                pageBuilder: (context, state) => MaterialPage<void>(
                  key: state.pageKey,
                  child: const RegistrationPageConnector(),
                ),
              ),
              GoRoute(
                name: Routes.forgotPassword,
                path: 'forgot-password',
                pageBuilder: (context, state) => MaterialPage<void>(
                  key: state.pageKey,
                  child: const ForgotPasswordPageConnector(),
                ),
              ),
              GoRoute(
                path: 'reset-password',
                pageBuilder: (context, state) => MaterialPage<void>(
                  key: state.pageKey,
                  child: const ResetPasswordPageConnector(),
                ),
              ),
            ],
          ),
        ],
      );
}

extension RoutesExtension on GoRouter {
  void showSnackBar(BaseSnackBar model) {
    final context = routerDelegate.navigatorKey.currentContext!;
    final snackBar = model.build(context);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
