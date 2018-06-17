import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'route_handlers.dart';

class Routes {
  static String login = "/login";
  static String grades = "/grades";
  static String settings = "/settings";
  static String calculator = "/calculator";
  static String onboarding = '/onboarding';
  static String birthday = '/birthday';

  static void configureRoutes(Router router) {
    router.notFoundHandler = new Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
    });
    router.define(login, handler: LoginRouteHandler);
    router.define(grades, handler: GradesRouteHandler);
    router.define(settings, handler: SettingsRouteHandler);
    router.define(calculator, handler: CalculatorRouteHandler);
    router.define(onboarding, handler: OnboardingRouteHandler);
    router.define(birthday, handler: BirthdayRouteHandler);
  }
}
