import 'dart:async';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:thinkcreative_technologies/Configs/db_paths.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Localization/app_localization_for_current_user.dart';
import 'package:thinkcreative_technologies/Localization/app_localization_for_events_and_alerts.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Screens/initialization/initialization_constant.dart';
import 'package:thinkcreative_technologies/Screens/splashScreen/SplashScreen.dart';
import 'package:thinkcreative_technologies/Services/my_providers/GroupChatProvider.dart';
import 'package:thinkcreative_technologies/Services/my_providers/bottom_nav_bar.dart';
import 'package:thinkcreative_technologies/Services/my_providers/observer.dart';
import 'package:thinkcreative_technologies/Services/my_providers/TicketChatProvider.dart';
import 'package:thinkcreative_technologies/Services/my_providers/liveListener.dart';
import 'package:thinkcreative_technologies/Services/my_providers/user_registry_provider.dart';
import 'package:thinkcreative_technologies/Screens/initialization/initialize.dart';
import 'package:thinkcreative_technologies/Services/my_providers/session_provider.dart';
import 'package:thinkcreative_technologies/Utils/connectivity_services.dart';
import 'package:thinkcreative_technologies/Services/my_providers/firestore_collections_data_admin.dart';
import 'package:thinkcreative_technologies/Services/my_providers/firestore_documents_data.dart';
import 'package:thinkcreative_technologies/Services/my_providers/download_info_provider.dart';

List<CameraDescription> cameras = <CameraDescription>[];
Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Mycolors.primary, //or set color with: Color(0xFF0000FF)
  ));
  final WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
  binding.renderView.automaticSystemUiAdjustment = false;
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }

  runApp(AppWrapper());
}

class AppWrapper extends StatefulWidget {
  const AppWrapper({Key? key}) : super(key: key);
  static void setLocale(BuildContext context, Locale newLocale) {
    _AppWrapperState state =
        context.findAncestorStateOfType<_AppWrapperState>()!;
    state.setLocale(newLocale);
  }

  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  Locale? _locale;
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocaleForUsers().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });

    super.didChangeDependencies();
  }

  final FirebaseLiveDataServices firebaseLiveDataServices =
      FirebaseLiveDataServices();
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    if (this._locale == null) {
      return MaterialApp(
          debugShowCheckedModeBanner: false, home: Splashscreen());
    } else {
      return FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: new Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      'ERROR ${snapshot.error}',
                      style: TextStyle(color: Colors.white),
                    )),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return FutureBuilder(
                  future: SharedPreferences.getInstance(),
                  builder:
                      (context, AsyncSnapshot<SharedPreferences> snapshot) {
                    if (snapshot.hasData) {
                      return FutureBuilder(
                          future: SharedPreferences.getInstance(),
                          builder: (context,
                              AsyncSnapshot<SharedPreferences> snapshot) {
                            if (snapshot.hasData) {
                              return MultiProvider(
                                  providers: [
                                    ChangeNotifierProvider<
                                        FirestoreDataProviderMESSAGESforGROUPCHAT>(
                                      create: (BuildContext context) {
                                        return FirestoreDataProviderMESSAGESforGROUPCHAT();
                                      },
                                    ),
                                    ChangeNotifierProvider<Observer>(
                                      create: (BuildContext context) {
                                        return Observer();
                                      },
                                    ),
                                    ChangeNotifierProvider<UserRegistry>(
                                      create: (BuildContext context) {
                                        return UserRegistry();
                                      },
                                    ),

                                    ChangeNotifierProvider<
                                        FirestoreDataProviderMESSAGESforTICKETCHAT>(
                                      create: (BuildContext context) {
                                        return FirestoreDataProviderMESSAGESforTICKETCHAT();
                                      },
                                    ),
                                    ChangeNotifierProvider<
                                        FirestoreDataProviderCHATMESSAGES>(
                                      create: (BuildContext context) {
                                        return FirestoreDataProviderCHATMESSAGES();
                                      },
                                    ),
                                    ChangeNotifierProvider<
                                        FirestoreDataProviderREPORTS>(
                                      create: (BuildContext context) {
                                        return FirestoreDataProviderREPORTS();
                                      },
                                    ),
                                    ChangeNotifierProvider<
                                        FirestoreDataProviderAGENTS>(
                                      create: (BuildContext context) {
                                        return FirestoreDataProviderAGENTS();
                                      },
                                    ),
                                    ChangeNotifierProvider<
                                        FirestoreDataProviderCUSTOMERS>(
                                      create: (BuildContext context) {
                                        return FirestoreDataProviderCUSTOMERS();
                                      },
                                    ),
                                    ChangeNotifierProvider<
                                        FirestoreDataProviderCALLHISTORY>(
                                      create: (BuildContext context) {
                                        return FirestoreDataProviderCALLHISTORY();
                                      },
                                    ),
                                    ChangeNotifierProvider<
                                        FirestoreDataProviderDocNOTIFICATION>(
                                      create: (BuildContext context) {
                                        return FirestoreDataProviderDocNOTIFICATION();
                                      },
                                    ),

                                    ChangeNotifierProvider<CommonSession>(
                                      create: (BuildContext context) {
                                        return CommonSession();
                                      },
                                    ),
                                    ChangeNotifierProvider<
                                        DownloadInfoprovider>(
                                      create: (BuildContext context) {
                                        return DownloadInfoprovider();
                                      },
                                    ),
                                    //---- All the above providers are AUTHENTICATION PROVIDER -------

                                    ChangeNotifierProvider<
                                        BottomNavigationBarProvider>(
                                      create: (BuildContext context) {
                                        return BottomNavigationBarProvider();
                                      },
                                    ),
                                  ],
                                  child: StreamProvider<ConnectivityStatus>(
                                      initialData: ConnectivityStatus.Cellular,
                                      create: (context) => ConnectivityService()
                                          .connectionStatusController
                                          .stream,
                                      child: StreamProvider<
                                              SpecialLiveConfigData?>(
                                          create: (BuildContext context) =>
                                              firebaseLiveDataServices
                                                  .getLiveData(FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                          DbPaths.userapp)
                                                      .doc(DbPaths
                                                          .collectionconfigs)),
                                          initialData: null,
                                          catchError: (context, e) {
                                            return SpecialLiveConfigData
                                                .fromJson({});
                                          },
                                          child: MaterialApp(
                                            debugShowCheckedModeBanner: false,
                                            home: Initialize(
                                              prefs: snapshot.data!,
                                              app: InitializationConstant.k11,
                                              doc: InitializationConstant.k9,
                                            ),
                                            // ignore: todo
                                            //TODO:---- All localizations settings----
                                            locale: _locale,
                                            supportedLocales: supportedlocale,
                                            localizationsDelegates: [
                                              AppLocalizationForCurrentUser
                                                  .delegate,
                                              AppLocalizationForEventsAndAlerts
                                                  .delegate,
                                              GlobalMaterialLocalizations
                                                  .delegate,
                                              GlobalWidgetsLocalizations
                                                  .delegate,
                                              GlobalCupertinoLocalizations
                                                  .delegate,
                                            ],
                                            localeResolutionCallback:
                                                (locale, supportedLocales) {
                                              for (var supportedLocale
                                                  in supportedLocales) {
                                                if (supportedLocale
                                                            .languageCode ==
                                                        locale!.languageCode &&
                                                    supportedLocale
                                                            .countryCode ==
                                                        locale.countryCode) {
                                                  return supportedLocale;
                                                }
                                              }
                                              return supportedLocales.first;
                                            },
                                          ))));
                            }
                            return MaterialApp(
                                debugShowCheckedModeBanner: false,
                                home: Splashscreen());
                          });
                    }
                    return MaterialApp(
                        debugShowCheckedModeBanner: false,
                        home: Splashscreen());
                  });
            }
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Splashscreen(),
            );
          });
    }
  }
}

void logError(String code, String? message) {
  if (message != null) {
    print('Error: $code\nError Message: $message');
  } else {
    print('Error: $code');
  }
}
