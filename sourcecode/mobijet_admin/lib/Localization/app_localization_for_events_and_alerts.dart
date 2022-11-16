//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

import 'dart:convert';
import 'package:thinkcreative_technologies/Configs/app_constants.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizationForEventsAndAlerts {
  AppLocalizationForEventsAndAlerts(this.locale);

  final Locale locale;
  static AppLocalizationForEventsAndAlerts? of(BuildContext context) {
    return Localizations.of<AppLocalizationForEventsAndAlerts>(
        context, AppLocalizationForEventsAndAlerts);
  }

  late Map<String, String> _localizedValues;

  Future<void> load() async {
    String jsonStringValues = await rootBundle.loadString(
        'lib/Localization/json_languages/$DefaulLANGUAGEfileCodeForEVENTSandALERTS.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    _localizedValues =
        mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  String? translate(String key) {
    return _localizedValues[key];
  }

  // static member to have simple access to the delegate from Material App
  static const LocalizationsDelegate<AppLocalizationForEventsAndAlerts>
      delegate = _AppLocalizationForEventsAndAlertsDelegate();
}

class _AppLocalizationForEventsAndAlertsDelegate
    extends LocalizationsDelegate<AppLocalizationForEventsAndAlerts> {
  const _AppLocalizationForEventsAndAlertsDelegate();

  @override
  bool isSupported(Locale locale) {
    return languagelist.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizationForEventsAndAlerts> load(Locale locale) async {
    AppLocalizationForEventsAndAlerts localization =
        new AppLocalizationForEventsAndAlerts(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(
          LocalizationsDelegate<AppLocalizationForEventsAndAlerts> old) =>
      false;
}
