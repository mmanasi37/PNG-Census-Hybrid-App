import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

import '../models/form_schema.dart';
import '../models/household_record.dart';
import '../services/auth_service.dart';
import '../services/isar_service.dart';
import '../services/sync_engine.dart';
import '../theme/app_theme.dart';
import '../widgets/wia_logo.dart';
import 'conflict_detail_screen.dart';

class SupervisorScreen extends StatelessWidget {
  const SupervisorScreen({super.key, required this.schema});

  final FormSchema schema;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.surfaceContainerLow,
        appBar: AppBar(
          backgroundColor: AppColors.navyDark,
          foregroundColor: Colors.white,
          elevation: 0,
          leading: const Padding(
            padding: EdgeInsets.all(10),
            child: WiaLogo(size: 32),
          ),
          title: Text(
            'Supervisor Dashboard',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout_rounded,
                  color: Colors.white70, size: 22),
              tooltip: 'Sign out',
              onPressed: () => _confirmLogout(context),
            ),
          ],
          bottom: TabBar(
            indicatorColor: AppColors.primaryContainer,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: AppColors.primaryContainer,
            labelStyle: GoogleFonts.inter(
                fontSize: 13, fontWeight: FontWeight.w600),
            unselectedLabelStyle:
                GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
            tabs: const [
              Tab(icon: Icon(Icons.bar_chart_rounded, size: 18),
                  text: 'Progress'),
              Tab(icon: Icon(Icons.warning_amber_rounded, size: 18),
                  text: 'Conflicts'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ProgressView(schema: schema),
            _ConflictQueueView(schema: schema),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Sign Out?',
            style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700)),
        content: Text(
          'You will be returned to the login screen.',
          style: GoogleFonts.inter(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
                minimumSize: Size.zero,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10)),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
    if (confirmed == true) AuthService.instance.logout();
  }
}

// ── Progress tab ───────────────────────────────────────────────────────────────

class _ProgressView extends StatefulWidget {
  const _ProgressView({required this.schema});
  final FormSchema schema;

  @override
  State<_ProgressView> createState() => _ProgressViewState();
}

class _ProgressViewState extends State<_ProgressView>
    with AutomaticKeepAliveClientMixin {
  List<HouseholdRecord>? _records;
  bool _syncing = false;
  String _lastSync = 'Never';

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final records = await IsarService.instance.getAll();
    final sync = await _readLastSync();
    if (mounted) setState(() { _records = records; _lastSync = sync; });
  }

  Future<String> _readLastSync() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final f = File('${dir.path}/.census_last_sync');
      if (!f.existsSync()) return 'Never';
      final t = DateTime.parse(f.readAsStringSync().trim());
      return _timeAgo(t);
    } catch (_) { return 'Never'; }
  }

  Future<void> _runSync() async {
    setState(() => _syncing = true);
    final result = await SyncEngine.instance.sync();
    await _load();
    if (!mounted) return;
    setState(() => _syncing = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(result.hasActivity
          ? '↑ ${result.uploaded}  ↓ ${result.downloaded}  ⚠ ${result.conflicts}'
          : result.hasErrors ? result.errors.first : 'Nothing to sync.'),
      backgroundColor:
          result.hasErrors ? AppColors.amber : AppColors.tertiary,
      duration: const Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_records == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final stats = _Stats.fromRecords(_records!);
    final provinceLabelMap = <String, String>{};
    final a01 = widget.schema.findQuestion('A01');
    for (final opt in a01?.options ?? <AnswerOption>[]) {
      provinceLabelMap[opt.value] = opt.label['en'] ?? opt.value;
    }

    return RefreshIndicator(
      color: AppColors.secondary,
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── 4-chip stat row ──────────────────────────────────────────
          Row(
            children: [
              _StatChip(label: 'Total', value: '${stats.total}',
                  color: AppColors.secondary),
              const SizedBox(width: 8),
              _StatChip(label: 'Synced', value: '${stats.synced}',
                  color: AppColors.tertiary),
              const SizedBox(width: 8),
              _StatChip(label: 'Pending', value: '${stats.pending}',
                  color: AppColors.amber),
              const SizedBox(width: 8),
              _StatChip(
                  label: 'Conflicts',
                  value: '${stats.conflict}',
                  color: stats.conflict > 0
                      ? AppColors.error
                      : AppColors.outlineVariant),
            ],
          ),
          const SizedBox(height: 14),

          // ── Completion card ──────────────────────────────────────────
          _CompletionCard(stats: stats, lastSync: _lastSync),
          const SizedBox(height: 12),

          // ── Sync button ──────────────────────────────────────────────
          FilledButton.icon(
            onPressed: _syncing ? null : _runSync,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: AppColors.onSecondary,
            ),
            icon: _syncing
                ? SizedBox(
                    width: 16, height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppColors.onSecondary))
                : const Icon(Icons.sync_rounded, size: 18),
            label: Text(_syncing ? 'Syncing…' : 'Sync Now',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 24),

          // ── Province breakdown ───────────────────────────────────────
          if (stats.byProvince.isNotEmpty) ...[
            _SectionHeader(
                icon: Icons.map_outlined,
                title: 'By Province (${stats.byProvince.length})'),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 4,
                    offset: const Offset(0, 2))],
              ),
              child: Column(
                children: stats.byProvince.entries.indexed.map((e) {
                  final (i, entry) = e;
                  return Column(
                    children: [
                      if (i > 0) Divider(height: 1,
                          color: AppColors.outlineVariant.withAlpha(60)),
                      _BreakdownRow(
                        label: provinceLabelMap[entry.key] ?? entry.key,
                        done: entry.value.done,
                        total: entry.value.total,
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
          ],

          // ── Enumerator breakdown ─────────────────────────────────────
          if (stats.byEnumerator.isNotEmpty) ...[
            _SectionHeader(
                icon: Icons.person_outline,
                title: 'By Enumerator (${stats.byEnumerator.length})'),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 4,
                    offset: const Offset(0, 2))],
              ),
              child: Column(
                children: stats.byEnumerator.entries.indexed.map((e) {
                  final (i, entry) = e;
                  return Column(
                    children: [
                      if (i > 0) Divider(height: 1,
                          color: AppColors.outlineVariant.withAlpha(60)),
                      _BreakdownRow(
                        label: entry.key,
                        done: entry.value.done,
                        total: entry.value.total,
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ── Conflict queue tab ─────────────────────────────────────────────────────────

class _ConflictQueueView extends StatefulWidget {
  const _ConflictQueueView({required this.schema});
  final FormSchema schema;

  @override
  State<_ConflictQueueView> createState() => _ConflictQueueViewState();
}

class _ConflictQueueViewState extends State<_ConflictQueueView>
    with AutomaticKeepAliveClientMixin {
  List<HouseholdRecord>? _conflicts;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final c = await IsarService.instance.getByStatus(RecordStatus.conflict);
    if (mounted) setState(() => _conflicts = c);
  }

  Future<void> _approve(HouseholdRecord record) async {
    await IsarService.instance.markComplete(record.uuid, 'supervisor');
    _load();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Approved — queued for sync'),
        backgroundColor: AppColors.tertiary,
      ));
    }
  }

  Future<void> _discard(HouseholdRecord record) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Return to Draft?',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
        content: Text(
          'HH ${record.householdNumber} will be returned to draft for re-enumeration.',
          style: GoogleFonts.inter(fontSize: 14),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('Return to Draft')),
        ],
      ),
    );
    if (confirmed != true) return;
    final r = record..status = RecordStatus.draft.value;
    await IsarService.instance.save(r);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_conflicts == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_conflicts!.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.tertiary.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_circle_outline_rounded,
                  size: 48, color: AppColors.tertiary),
            ),
            const SizedBox(height: 16),
            Text('No conflicts',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface)),
            const SizedBox(height: 6),
            Text('All records are clean.',
                style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.onSurfaceVariant)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.secondary,
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _conflicts!.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final r = _conflicts![i];
          return _ConflictCard(
            record: r,
            onApprove: () => _approve(r),
            onDiscard: () => _discard(r),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ConflictDetailScreen(record: r, schema: widget.schema),
                ),
              );
              _load();
            },
          );
        },
      ),
    );
  }
}

// ── Widgets ────────────────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  const _StatChip(
      {required this.label, required this.value, required this.color});
  final String label, value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border(left: BorderSide(color: color, width: 4)),
          boxShadow: [BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 4,
              offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            Text(value,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: color)),
            Text(label,
                style: GoogleFonts.inter(
                    fontSize: 10,
                    color: AppColors.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

class _CompletionCard extends StatelessWidget {
  const _CompletionCard({required this.stats, required this.lastSync});
  final _Stats stats;
  final String lastSync;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 4,
            offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Overall Completion',
                  style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface)),
              Text(
                '${(stats.rate * 100).toStringAsFixed(1)}%',
                style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.secondary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: stats.rate,
              minHeight: 8,
              backgroundColor: AppColors.surfaceContainerHigh,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${stats.done} of ${stats.total} records complete   ·   '
            'Last sync: $lastSync',
            style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title});
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.secondary),
        const SizedBox(width: 6),
        Text(title,
            style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurfaceVariant,
                letterSpacing: 0.8)),
      ],
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow(
      {required this.label, required this.done, required this.total});
  final String label;
  final int done, total;

  @override
  Widget build(BuildContext context) {
    final rate = total == 0 ? 0.0 : done / total;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label,
                style: GoogleFonts.inter(
                    fontSize: 12, color: AppColors.onSurface),
                overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: rate,
                minHeight: 7,
                backgroundColor: AppColors.surfaceContainerHigh,
                color: rate == 1.0 ? AppColors.tertiary : AppColors.secondary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 46,
            child: Text('$done/$total',
                style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurfaceVariant),
                textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}

class _ConflictCard extends StatelessWidget {
  const _ConflictCard({
    required this.record,
    required this.onApprove,
    required this.onDiscard,
    required this.onTap,
  });

  final HouseholdRecord record;
  final VoidCallback onApprove;
  final VoidCallback onDiscard;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      elevation: 2,
      shadowColor: Colors.black.withAlpha(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
                left: BorderSide(color: AppColors.amber, width: 4)),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge + title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.amber.withAlpha(25),
                      border: Border.all(
                          color: AppColors.amber.withAlpha(100)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text('CONFLICT',
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.amber)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'HH ${record.householdNumber}  —  ${record.village}',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // Meta
              Text(
                '${record.district}, ${record.province}  ·  '
                'Enumerator: ${record.enumeratorId}',
                style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant),
              ),
              Text(
                'Last updated: ${_timeAgo(record.updatedAt)}',
                style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.outlineVariant),
              ),
              const SizedBox(height: 12),

              // Actions
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: onTap,
                    icon: const Icon(Icons.search_rounded, size: 15),
                    label: Text('Review',
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary),
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: onApprove,
                    icon: const Icon(Icons.check_rounded, size: 15),
                    label: Text('Approve',
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.tertiary,
                      foregroundColor: AppColors.onTertiary,
                      visualDensity: VisualDensity.compact,
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.undo_rounded,
                        size: 18, color: AppColors.error),
                    tooltip: 'Return to Draft',
                    onPressed: onDiscard,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Stats model ────────────────────────────────────────────────────────────────

class _Stats {
  _Stats._({
    required this.total,
    required this.draft,
    required this.complete,
    required this.synced,
    required this.conflict,
    required this.byProvince,
    required this.byEnumerator,
  });

  factory _Stats.fromRecords(List<HouseholdRecord> records) {
    var draft = 0, complete = 0, synced = 0, conflict = 0;
    final byProvince = <String, _GroupStat>{};
    final byEnumerator = <String, _GroupStat>{};

    for (final r in records) {
      switch (r.status) {
        case 'draft': draft++;
        case 'complete': complete++;
        case 'synced': synced++;
        case 'conflict': conflict++;
      }
      final done = r.status != RecordStatus.draft.value;
      byProvince.update(
        r.province.isNotEmpty ? r.province : '—',
        (s) => _GroupStat(total: s.total + 1, done: s.done + (done ? 1 : 0)),
        ifAbsent: () => _GroupStat(total: 1, done: done ? 1 : 0),
      );
      byEnumerator.update(
        r.enumeratorId.isNotEmpty ? r.enumeratorId : '—',
        (s) => _GroupStat(total: s.total + 1, done: s.done + (done ? 1 : 0)),
        ifAbsent: () => _GroupStat(total: 1, done: done ? 1 : 0),
      );
    }

    final sortedProv = Map.fromEntries(byProvince.entries.toList()
      ..sort((a, b) => b.value.total.compareTo(a.value.total)));
    final sortedEnum = Map.fromEntries(byEnumerator.entries.toList()
      ..sort((a, b) => b.value.total.compareTo(a.value.total)));

    return _Stats._(
      total: records.length,
      draft: draft,
      complete: complete,
      synced: synced,
      conflict: conflict,
      byProvince: sortedProv,
      byEnumerator: sortedEnum,
    );
  }

  final int total, draft, complete, synced, conflict;
  final Map<String, _GroupStat> byProvince;
  final Map<String, _GroupStat> byEnumerator;

  int get done => complete + synced;
  double get rate => total == 0 ? 0 : done / total;
  int get pending => complete + conflict;
}

class _GroupStat {
  const _GroupStat({required this.total, required this.done});
  final int total, done;
}

// ── Helpers ────────────────────────────────────────────────────────────────────

String _timeAgo(DateTime t) {
  final diff = DateTime.now().difference(t);
  if (diff.inSeconds < 60) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays == 1) return 'yesterday';
  if (diff.inDays < 30) return '${diff.inDays}d ago';
  return '${t.day}/${t.month}/${t.year}';
}
