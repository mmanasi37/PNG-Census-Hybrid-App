import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/form_schema.dart';
import '../models/household_record.dart';
import '../screens/enumeration_screen.dart';
import '../services/auth_service.dart';
import '../services/isar_service.dart';
import '../services/sync_engine.dart';
import '../theme/app_theme.dart';

class EnumeratorDashboard extends StatefulWidget {
  const EnumeratorDashboard({super.key, required this.schema});

  final FormSchema schema;

  @override
  State<EnumeratorDashboard> createState() => _EnumeratorDashboardState();
}

class _EnumeratorDashboardState extends State<EnumeratorDashboard> {
  List<HouseholdRecord>? _myRecords;
  bool _syncing = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final user = AuthService.instance.currentUser!;
    final records =
        await IsarService.instance.getByEnumerator(user.username);
    if (mounted) setState(() => _myRecords = records);
  }

  Future<void> _sync() async {
    setState(() => _syncing = true);
    final result = await SyncEngine.instance.sync();
    await _load();
    if (!mounted) return;
    setState(() => _syncing = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(result.hasActivity
          ? '↑ ${result.uploaded}  ↓ ${result.downloaded}  ⚠ ${result.conflicts}'
          : result.hasErrors
              ? result.errors.first
              : 'Nothing to sync.'),
      backgroundColor:
          result.hasErrors ? AppColors.amber : AppColors.tertiary,
      duration: const Duration(seconds: 3),
    ));
  }

  void _startEnumeration() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => EnumerationScreen(schema: widget.schema)),
    ).then((_) => _load());
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser!;
    final records = _myRecords;

    final total = records?.length ?? 0;
    final drafts = records?.where((r) => r.status == 'draft').length ?? 0;
    final synced = records?.where((r) => r.status == 'synced').length ?? 0;
    final pendingSync = records
            ?.where(
                (r) => r.status == 'complete' || r.status == 'conflict')
            .length ??
        0;

    final initials = user.fullName.trim().isNotEmpty
        ? user.fullName
            .trim()
            .split(' ')
            .take(2)
            .map((w) => w[0].toUpperCase())
            .join()
        : 'E';

    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLow,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _load,
        child: CustomScrollView(
          slivers: [
            // ── Hero header ────────────────────────────────────────────
            SliverAppBar(
              expandedHeight: 156,
              pinned: true,
              backgroundColor: AppColors.navyDark,
              foregroundColor: Colors.white,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.navyDark, AppColors.primaryDim],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              // Avatar
                              CircleAvatar(
                                radius: 24,
                                backgroundColor:
                                    Colors.white.withAlpha(30),
                                child: Text(
                                  initials,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Welcome, ${user.fullName.split(' ').first}',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${user.province} · ${user.district}',
                                      style: GoogleFonts.inter(
                                        color: AppColors.primaryContainer,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.logout_rounded,
                                    color: Colors.white70, size: 22),
                                tooltip: 'Sign out',
                                onPressed: _confirmLogout,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Role badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.white.withAlpha(80)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.person_outline,
                                    color: Colors.white, size: 13),
                                const SizedBox(width: 5),
                                Text(
                                  'Enumerator',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Stats grid ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: records == null
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Column(
                        children: [
                          Row(
                            children: [
                              _StatCard(
                                  label: 'Total HH',
                                  value: '$total',
                                  accent: AppColors.secondary),
                              const SizedBox(width: 12),
                              _StatCard(
                                  label: 'Synced',
                                  value: '$synced',
                                  accent: AppColors.tertiary),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _StatCard(
                                  label: 'Drafts',
                                  value: '$drafts',
                                  accent: AppColors.amber),
                              const SizedBox(width: 12),
                              _StatCard(
                                  label: 'Pending Sync',
                                  value: '$pendingSync',
                                  accent: pendingSync > 0
                                      ? AppColors.teal
                                      : AppColors.outlineVariant,
                                  badge:
                                      pendingSync > 0 ? true : false),
                            ],
                          ),
                        ],
                      ),
              ),
            ),

            // ── Quick actions ──────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'QUICK ACTIONS',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _ActionCard(
                          icon: Icons.add_circle_outline_rounded,
                          label: 'New\nEnumeration',
                          accent: AppColors.secondary,
                          onTap: _startEnumeration,
                        ),
                        const SizedBox(width: 10),
                        _ActionCard(
                          icon: Icons.sync_rounded,
                          label: _syncing ? 'Syncing…' : 'Sync\nNow',
                          accent: AppColors.secondary,
                          onTap: _syncing ? null : _sync,
                          badge: pendingSync > 0 ? '$pendingSync' : null,
                        ),
                        const SizedBox(width: 10),
                        _ActionCard(
                          icon: Icons.edit_note_rounded,
                          label: 'My\nDrafts',
                          accent: AppColors.amber,
                          onTap: (drafts > 0 && records != null)
                              ? () => _showDraftsList(records
                                  .where((r) => r.status == 'draft')
                                  .toList())
                              : null,
                          badge: drafts > 0 ? '$drafts' : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Recent records header ──────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 28, 16, 8),
                child: Text(
                  'RECENT RECORDS',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),

            // ── Records list ───────────────────────────────────────────
            if (records == null)
              const SliverToBoxAdapter(child: SizedBox())
            else if (records.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Icon(Icons.folder_open_outlined,
                          size: 60,
                          color: AppColors.outlineVariant),
                      const SizedBox(height: 12),
                      Text(
                        'No records yet',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap "New Enumeration" to start',
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.outlineVariant),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(10),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: records.take(10).indexed.map((e) {
                      final (i, r) = e;
                      return Column(
                        children: [
                          if (i > 0)
                            Divider(
                                height: 1,
                                indent: 56,
                                color: AppColors.outlineVariant
                                    .withAlpha(60)),
                          _RecordTile(record: r),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 96)),
          ],
        ),
      ),

      // ── FAB ──────────────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _startEnumeration,
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.onSecondary,
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: Text('New Form',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
      ),
    );
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Sign Out?',
            style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700)),
        content: Text(
          'Any unsynced data stays on this device until you sync again.',
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
                minimumSize: Size.zero),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
    if (confirmed == true) AuthService.instance.logout();
  }

  void _showDraftsList(List<HouseholdRecord> drafts) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.55,
        maxChildSize: 0.9,
        builder: (_, ctrl) => Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                  color: AppColors.outlineVariant,
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text('Draft Records',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.amber.withAlpha(25),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: AppColors.amber.withAlpha(80)),
                    ),
                    child: Text(
                      '${drafts.length}',
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.amber),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Divider(height: 1, color: AppColors.outlineVariant.withAlpha(60)),
            Expanded(
              child: ListView.separated(
                controller: ctrl,
                itemCount: drafts.length,
                separatorBuilder: (_, _) => Divider(
                    height: 1,
                    indent: 56,
                    color: AppColors.outlineVariant.withAlpha(60)),
                itemBuilder: (ctx, i) =>
                    _RecordTile(record: drafts[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Stat card ──────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.accent,
    this.badge = false,
  });

  final String label, value;
  final Color accent;
  final bool badge;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border(left: BorderSide(color: accent, width: 4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: accent,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (badge)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                    color: accent, shape: BoxShape.circle),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Action card ────────────────────────────────────────────────────────────────

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.label,
    required this.accent,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final String label;
  final Color accent;
  final VoidCallback? onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return Expanded(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            elevation: disabled ? 0 : 2,
            shadowColor: Colors.black.withAlpha(15),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16, horizontal: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: disabled
                            ? AppColors.surfaceContainer
                            : accent.withAlpha(25),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon,
                          color: disabled
                              ? AppColors.outlineVariant
                              : accent,
                          size: 22),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: disabled
                            ? AppColors.outlineVariant
                            : AppColors.onSurface,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (badge != null)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: accent.withAlpha(60),
                          blurRadius: 4,
                          offset: const Offset(0, 2))
                    ]),
                child: Text(
                  badge!,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Record tile ────────────────────────────────────────────────────────────────

class _RecordTile extends StatelessWidget {
  const _RecordTile({required this.record});

  final HouseholdRecord record;

  static const _statusMeta = {
    'synced': (Icons.check_circle_outline, AppColors.tertiary, 'Synced'),
    'complete': (Icons.task_alt, AppColors.secondary, 'Complete'),
    'conflict': (Icons.warning_amber_rounded, AppColors.error, 'Conflict'),
    'draft': (Icons.edit_outlined, AppColors.amber, 'Draft'),
  };

  @override
  Widget build(BuildContext context) {
    final (icon, color, label) =
        _statusMeta[record.status] ?? _statusMeta['draft']!;

    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: color.withAlpha(25),
        child: Icon(icon, color: color, size: 18),
      ),
      title: Text(
        'HH ${record.householdNumber} — ${record.village}',
        style: GoogleFonts.inter(
            fontSize: 13, fontWeight: FontWeight.w600,
            color: AppColors.onSurface),
      ),
      subtitle: Text(
        '${record.district}, ${record.province}  ·  '
        '${_timeAgo(record.updatedAt)}',
        style: GoogleFonts.inter(
            fontSize: 11, color: AppColors.onSurfaceVariant),
      ),
      trailing: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withAlpha(70)),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ),
    );
  }
}

String _timeAgo(DateTime t) {
  final diff = DateTime.now().difference(t);
  if (diff.inSeconds < 60) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays == 1) return 'yesterday';
  if (diff.inDays < 30) return '${diff.inDays}d ago';
  return '${t.day}/${t.month}/${t.year}';
}
