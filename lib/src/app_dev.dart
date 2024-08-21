// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';

// Package imports:
import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import '../src/core/localization/string_hardcoded.dart';
import '../src/core/providers/app_state_provider.dart';
import '../src/routing/app_router.dart';
import 'core/themes/app_themes.dart';

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

class DevApp extends ConsumerWidget {
  const DevApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(appRouterProvider);
    final appState = ref.watch(appStateNotifierProvider);

    return isIOS
        ? ScreenUtilInit(
            designSize: const Size(
                393, 852), // viewport size of iPhone 14 Pro, iPhone 15
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (_, child) {
              return CupertinoApp.router(
                routerConfig: appRouter,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                debugShowCheckedModeBanner: false,
                theme: AppThemes.idark(),
              );
            })
        : ScreenUtilInit(
            designSize:
                const Size(393, 851), // viewport size of Google Pixel 4a
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (_, child) {
              return MaterialApp.router(
                useInheritedMediaQuery: true,
                routerConfig: appRouter,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: DevicePreview.locale(context),
                builder: DevicePreview.appBuilder,
                debugShowCheckedModeBanner: false,
                restorationScopeId: 'app',
                onGenerateTitle: (BuildContext context) => 'Example'.hardcoded,
                themeMode: appState.isDarkModeEnabled
                    ? ThemeMode.dark
                    : ThemeMode.light,
                theme: AppThemes.light(),
                darkTheme: AppThemes.dark(),
              );
            });
  }
}
