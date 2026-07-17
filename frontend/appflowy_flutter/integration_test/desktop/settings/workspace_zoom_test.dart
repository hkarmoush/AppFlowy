import 'package:appflowy/startup/tasks/app_window_size_manager.dart';
import 'package:appflowy/workspace/application/settings/settings_dialog_bloc.dart';
import 'package:appflowy/workspace/presentation/home/hotkeys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../shared/util.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App zoom setting:', () {
    Future<void> resetAppFlowyScaleFactor(
      WindowSizeManager windowSizeManager,
    ) async {
      appflowyScaleFactor = 1.0;
      await windowSizeManager.setScaleFactor(1.0);
    }

    testWidgets('zoom in, out and reset from the workspace settings',
        (tester) async {
      await tester.initializeAppFlowy();
      await tester.tapAnonymousSignInButton();

      // this value can't be defined in the setUp method, because the
      // windowSizeManager is not initialized yet.
      final windowSizeManager = WindowSizeManager();
      await resetAppFlowyScaleFactor(windowSizeManager);

      await tester.openSettings();
      await tester.openSettingsPage(SettingsPage.workspace);
      await tester.pumpAndSettle();

      // zoom in twice -> 120%
      for (var i = 0; i < 2; i++) {
        await tester.tapButton(find.byKey(const Key('ZoomIncreaseButton')));
      }
      expect(appflowyScaleFactor, 1.2);
      expect(await windowSizeManager.getScaleFactor(), 1.2);

      // zoom out once -> 110%
      await tester.tapButton(find.byKey(const Key('ZoomDecreaseButton')));
      expect(appflowyScaleFactor, 1.1);
      expect(await windowSizeManager.getScaleFactor(), 1.1);

      // reset -> 100%
      await tester.tapButton(find.byKey(const Key('ZoomResetButton')));
      expect(appflowyScaleFactor, 1.0);
      expect(await windowSizeManager.getScaleFactor(), 1.0);
    });
  });
}
