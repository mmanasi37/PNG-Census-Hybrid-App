import 'package:flutter/widgets.dart';
import 'package:workmanager/workmanager.dart';

import 'isar_service.dart';
import 'sync_engine.dart';

/// Top-level entry point executed by WorkManager in a background isolate.
/// Must remain a top-level function and be annotated with vm:entry-point.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      await IsarService.instance.open();
      final result = await SyncEngine.instance.sync();
      return !result.hasErrors;
    } catch (_) {
      return false;
    }
  });
}

/// Registers the periodic background sync task.
/// Call once from [main] after Isar is open.
Future<void> initBackgroundSync() async {
  await Workmanager().initialize(callbackDispatcher);

  // Periodic sync every 15 min, only when network is available.
  await Workmanager().registerPeriodicTask(
    SyncEngine.periodicTaskName,
    SyncEngine.periodicTaskName,
    frequency: const Duration(minutes: 15),
    constraints: Constraints(networkType: NetworkType.connected),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    backoffPolicy: BackoffPolicy.exponential,
    backoffPolicyDelay: const Duration(minutes: 1),
  );
}

/// Schedules an immediate one-shot sync (e.g. on connectivity restored).
Future<void> triggerImmediateSync() async {
  await Workmanager().registerOneOffTask(
    SyncEngine.oneTimeTaskName,
    SyncEngine.oneTimeTaskName,
    constraints: Constraints(networkType: NetworkType.connected),
    existingWorkPolicy: ExistingWorkPolicy.replace,
  );
}
