import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:utility/auth/loading_screen.dart';
import 'package:utility/provider/common_provider.dart';
import 'package:utility/provider/spaces_provider.dart';
import 'package:utility/ui/homeScreen.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      /// Initialize the WidgetFlutterBinding if required
      WidgetsFlutterBinding.ensureInitialized();

      /// Used to initialize hive db and register adapters and generate encryption
      /// key for encrypted hive box
      // await HiveHelper.initializeHiveAndRegisterAdapters();
      // await SecureStorageHelper.instance.generateEncryptionKey();
      // await Firebase.initializeApp();
      // Lock orientation to portrait only
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      /// Ensuring Size of the phone in UI Design
      await ScreenUtil.ensureScreenSize();

      /// Sets the device orientation of application
      // AppStyles.setDeviceOrientationOfApp();

      /// Sets the server config of application
      // await setUpServiceLocator();

      /// Runs the application in its own error zone
      runApp(MyApp());
    },
    (error, stack) {
      debugPrint("Error while launching application $error && $stack");
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyAppState>()?.restartApp();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key _appKey = UniqueKey();

  void restartApp() {
    setState(() {
      _appKey = UniqueKey(); // New key forces full rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,

      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_, child) {
        return DevicePreview(
          enabled: false,
          tools: const [...DevicePreview.defaultTools],
          builder: (context) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider<CommonProvider>(
                  create: (context) => CommonProvider(),
                ),
                ChangeNotifierProvider<SpacesProvider>(
                  create: (context) => SpacesProvider(),
                ),
              ],
              child: MaterialApp(
                key: _appKey,
                navigatorKey: navigationKey,
                routes: {
                  '/homeScreen': (context) => Homescreen(
                    startIndex: 1,
                  ), // ← This doesn't handle arguments
                },
                debugShowCheckedModeBanner: false,
                title: 'SplashScreen',
                // You can use the library anywhere in the app even in theme
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  textTheme: Typography.englishLike2018.apply(
                    fontSizeFactor: 1.sp,
                  ),
                ),
                home: child,
              ),
            );
          },
        );
      },
      child: const MyHomePage(),
    );
  }
}

final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     nextFunction(context);
  //   });
  // }

  // void nextFunction(BuildContext context) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString("access_token")?.trim();
  //   String? userName = prefs.getString("user_name");

  //   // Fetch spaces before navigating, update providers accordingly
  //   final spacesProvider = Provider.of<SpacesProvider>(context, listen: false);
  //   final commonProvider = Provider.of<CommonProvider>(context, listen: false);

  //   final spacesModel = await spacesProvider.fetchSpaces(context);

  //   if (spacesModel != null) {
  //     if (spacesModel.data.length == 1) {
  //       final onlySpace = spacesModel.data[0];
  //       spacesProvider.setSelectedSpaceAndDevice(onlySpace.id);
  //       commonProvider.setSelectedSpaceName(onlySpace.spaceName);
  //     }
  //   }

  //   await Future.delayed(const Duration(seconds: 2));

  //   if (token != null && token.isNotEmpty) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (_) => Homescreen(startIndex: 0, phoneNumber: userName),
  //       ),
  //     );
  //   } else {
  //     await prefs.remove('access_token');
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (_) => const LandingScreen()),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: LoadingScreen());
  }
}

/*
class MyApp extends StatelessWidget {
  const MyApp({super.key});


  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
} */
