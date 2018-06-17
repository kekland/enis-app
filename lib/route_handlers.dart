import 'package:enis_new/pages/birthday_page.dart';
import 'package:enis_new/pages/onboarding_page.dart';

import 'pages/calculator_page.dart';
import 'pages/login_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'pages/grades_page.dart';
import 'pages/settings_page.dart';

var LoginRouteHandler = new Handler(handlerFunc: ((BuildContext context, Map<String, List<String>> args) {
  return new LoginPage();
}));

var GradesRouteHandler = new Handler(handlerFunc: ((BuildContext context, Map<String, List<String>> args) {
  return new GradesPage();
}));

var SettingsRouteHandler = new Handler(handlerFunc: ((BuildContext context, Map<String, List<String>> args) {
  return new SettingsPage();
}));

var OnboardingRouteHandler = new Handler(handlerFunc: ((BuildContext context, Map<String, List<String>> args) {
  return new OnboardingPage();
}));

var BirthdayRouteHandler = new Handler(handlerFunc: ((BuildContext context, Map<String, List<String>> args) {
  return new BirthdayPage();
}));
var CalculatorRouteHandler = new Handler(handlerFunc: ((BuildContext context, Map<String, List<String>> args) {
  String calcType = args['type'].first;
  if (calcType == '1') {
    String data = args['data'].first;
    return new CalculatorPage(
      routedIndex: 0,
      routedData: data,
    );
  } else {
    return new CalculatorPage(routedIndex: 2);
  }
}));
