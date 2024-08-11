
import 'package:get/get.dart';
import 'export.dart';
import 'feature_export.dart';
import 'firebase_options.dart';


Future<void> _backgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print(message.data.toString());
    print(message.notification!.title);
  }
}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await ScreenUtil.ensureScreenSize();
  await FirebaseAppCheck.instance.activate();
  await initLocator();

  if (!kIsWeb && FirebaseMessaging.onBackgroundMessage != null) {
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  }


  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: AppColors.white),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) => runApp(Phoenix(child: const MyApp())));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    _defineThePlatform(context);

    return MultiBlocs(
      child: GetBuilder<AppLanguage>(
          init: AppLanguage.getInstance(),
          tag: AppLanguage.tag,
          builder: (controller) {
            return ScreenUtilInit(
              designSize: const Size(360, 690),
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (context, child) {
                return GestureDetector(
                  onTap: () => WidgetsBinding
                      .instance.focusManager.primaryFocus!
                      .unfocus(),
                  child: GetMaterialApp(
                    transitionDuration: const Duration(seconds: 0),
                    debugShowCheckedModeBanner: false,
                    navigatorObservers: [AppNavigateObserver()],
                    routes: AppPages.routes,
                    title: 'Instagram',
                    theme: AppTheme.light,
                    supportedLocales: const [
                      Locale('en'),
                      Locale('es'),
                    ],
                    fallbackLocale: const Locale(
                      'en',
                    ),
                    locale: Locale(controller.languageSelected),
                    translationsKeys: AppTranslation.translations,
                    darkTheme: AppTheme.dark,
                    themeMode: ThemeOfApp.theme,
                    scrollBehavior: WebDragScrollBehavior(),
                    // initialRoute: AppPages.INITIAL,

                    home: AnimatedSplashScreen.withScreenFunction(
                      screenFunction: screenFunction,
                      centered: true,
                      splash: splashIcon,
                      backgroundColor: AppColors.white,
                      splashTransition: SplashTransition.scaleTransition,
                    ),
                  ),
                );
              },
            );
          }),
    );
  }

  Future<Widget> screenFunction() async {
    String? myId = await initializeDefaultValues();

    return myId == null ? const LoginPage() : GetMyPersonalInfo(myPersonalId: myId);
  }


  _defineThePlatform(BuildContext context) {
    TargetPlatform platform = Theme.of(context).platform;
    isThatMobile =
        platform == TargetPlatform.iOS || platform == TargetPlatform.android;
    isThatAndroid = platform == TargetPlatform.android;
  }

  Future<String?> initializeDefaultValues() async {
    await Future.wait([
      // initializeDependencies(),

      GetStorage.init("AppLang"),
      if (!kIsWeb) _crashlytics(),
    ]);

    if (!kIsWeb) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    }



    final sharePrefs = locator<SharedPreferences>();
    String? myId = sharePrefs.getString("myPersonalId");
    if (myId != null) myPersonalId = myId;
    return myId;
  }

  Future<void> _crashlytics() async {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    if (kDebugMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    } else {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    }
  }


}

class WebDragScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class MultiBlocs extends StatefulWidget {
  final Widget child;

  const MultiBlocs({super.key, required this.child});

  @override
  State<MultiBlocs> createState() => _MultiBlocsState();
}

class _MultiBlocsState extends State<MultiBlocs> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<AuthCubit>(
        create: (context) => locator<AuthCubit>(),
      ),
      BlocProvider<UserInfoCubit>(
        create: (context) => locator<UserInfoCubit>(),
      ),
      BlocProvider<FireStoreAddNewUserCubit>(
        create: (context) => locator<FireStoreAddNewUserCubit>(),
      ),
      BlocProvider<PostCubit>(
        create: (context) => locator<PostCubit>()..getAllPostInfo(),
      ),
      BlocProvider<FollowCubit>(
        create: (context) => locator<FollowCubit>(),
      ),
      BlocProvider<UsersInfoCubit>(
        create: (context) => locator<UsersInfoCubit>(),
      ),
      BlocProvider<SpecificUsersPostsCubit>(
        create: (context) => locator<SpecificUsersPostsCubit>(),
      ),
      BlocProvider<PostLikesCubit>(
        create: (context) => locator<PostLikesCubit>(),
      ),
      BlocProvider<CommentsInfoCubit>(
        create: (context) => locator<CommentsInfoCubit>(),
      ),
      BlocProvider<CommentLikesCubit>(
        create: (context) => locator<CommentLikesCubit>(),
      ),
      BlocProvider<ReplyLikesCubit>(
        create: (context) => locator<ReplyLikesCubit>(),
      ),
      BlocProvider<ReplyInfoCubit>(
        create: (context) => locator<ReplyInfoCubit>(),
      ),
      BlocProvider<MessageCubit>(
        create: (context) => locator<MessageCubit>(),
      ),
      BlocProvider<MessageBloc>(
        create: (context) => locator<MessageBloc>(),
      ),
      BlocProvider<StoryCubit>(
        create: (context) => locator<StoryCubit>(),
      ),
      BlocProvider<SearchAboutUserBloc>(
        create: (context) => locator<SearchAboutUserBloc>(),
      ),
      BlocProvider<NotificationCubit>(
        create: (context) => locator<NotificationCubit>(),
      ),
      BlocProvider<CallingRoomsCubit>(
        create: (context) => locator<CallingRoomsCubit>(),
      ),
      BlocProvider<CallingStatusBloc>(
        create: (context) => locator<CallingStatusBloc>(),
      ),
      BlocProvider<MessageForGroupChatCubit>(
        create: (context) => locator<MessageForGroupChatCubit>(),
      ),
      BlocProvider<UsersInfoReelTimeBloc>(
        create: (context1) {
          if (myPersonalId.isNotEmpty) {
            return locator<UsersInfoReelTimeBloc>()..add(LoadMyPersonalInfo());
          } else {
            return locator<UsersInfoReelTimeBloc>();
          }
        },
      ),
    ], child: widget.child);
  }
}
