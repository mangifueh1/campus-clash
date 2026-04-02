import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:campus_clash/core/constants/app_colors.dart';
import 'package:campus_clash/core/widgets/screen_wrapper.dart';
import 'package:campus_clash/core/widgets/desktop_not_supported_screen.dart';
import 'package:campus_clash/core/providers/matches_provider.dart';
import 'package:campus_clash/core/providers/voting_provider.dart';
import 'package:campus_clash/routes/app_router.dart';
import 'package:campus_clash/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MatchesProvider()),
        ChangeNotifierProvider(create: (_) => VotingProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(400, 812), // Mobile-first design base
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Campus Clash',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: AppColors.background,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.background,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
            ),
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              brightness: Brightness.dark,
              surface: AppColors.surface,
            ),
            textTheme: Typography.englishLike2018.apply(
              fontSizeFactor: 1.sp,
              bodyColor: Colors.white,
            ),
          ),
          builder: (context, materialChild) {
            return LayoutBuilder(
              builder: (context, constraints) {
                // Device restriction: Show warning if width > 1024px
                if (constraints.maxWidth > 1024) {
                  return const DesktopNotSupportedScreen();
                }

                return ScreenWrapper(
                  // maxWidth: 400, // Enforcing mobile width as per instructions
                  child: materialChild!,
                );
              },
            );
          },
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
