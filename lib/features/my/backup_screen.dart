import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/app_locale.dart';
import '../../app/theme.dart';
import '../../app/widgets/app_button.dart';
import '../../app/widgets/app_card.dart';
import '../../domain/backup_service.dart';

/// 기록 내보내기·가져오기 (로그인 없음). 파일은 사용자가 카카오톡·드라이브 등에 직접 보관.
class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  bool _busy = false;
  String? _message;

  Future<void> _export() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _message = null;
    });
    final l = context.l10n; // await 이후 context 를 쓰지 않도록 먼저 잡아 둔다
    try {
      final svc = ref.read(backupServiceProvider);
      final bytes = await svc.exportZip();
      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}${Platform.pathSeparator}${svc.suggestedFileName()}',
      );
      await file.writeAsBytes(bytes, flush: true);
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'application/zip')],
          subject: l.backupShareSubject,
          text: l.backupShareText,
        ),
      );
      if (mounted) setState(() => _message = l.backupExported);
    } catch (e) {
      if (mounted) {
        setState(() => _message = l.backupExportFailed('$e'));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _import() async {
    if (_busy) return;
    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['zip'],
    );
    if (picked.isEmpty) return;
    final bytes = await picked.first.readAsBytes();

    final summary = BackupService.inspectZip(bytes);
    if (!mounted) return;
    if (summary == null) {
      setState(() => _message = context.l10n.backupNotOurs);
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.backupImportQ),
        content: Text(
          context.l10n.backupImportSummary(
            DateFormat.yMMMd(
              context.l10n.localeName,
            ).format(summary.exportedAt),
            summary.plants,
            summary.diaries,
            summary.photos,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              context.l10n.backupImport,
              style: TextStyle(color: ctx.colors.error),
            ),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final l = context.l10n;

    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      final docs = await getApplicationDocumentsDirectory();
      final photoDir = Directory('${docs.path}${Platform.pathSeparator}photos');
      await ref
          .read(backupServiceProvider)
          .importZip(bytes, photoDir: photoDir);
      if (mounted) setState(() => _message = l.backupImported);
    } catch (e) {
      if (mounted) {
        setState(() => _message = l.backupImportFailed('$e'));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.backupTitle)),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.screenH),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.backupExport,
                  style: AppText.title.copyWith(color: c.textPrimary),
                ),
                const SizedBox(height: AppSpace.sm),
                Text(
                  context.l10n.backupExportBody,
                  style: AppText.body.copyWith(color: c.textSecondary),
                ),
                const SizedBox(height: AppSpace.lg),
                AppButton.primary(
                  label: context.l10n.backupExportButton,
                  icon: Icons.ios_share_rounded,
                  onPressed: _busy ? null : _export,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.cardGap),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.backupImport,
                  style: AppText.title.copyWith(color: c.textPrimary),
                ),
                const SizedBox(height: AppSpace.sm),
                Text(
                  context.l10n.backupImportBody,
                  style: AppText.body.copyWith(color: c.textSecondary),
                ),
                const SizedBox(height: AppSpace.lg),
                AppButton.secondary(
                  label: context.l10n.backupImportButton,
                  icon: Icons.folder_open_rounded,
                  onPressed: _busy ? null : _import,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.lg),
          if (_busy) const Center(child: CircularProgressIndicator()),
          if (_message != null)
            Text(
              _message!,
              textAlign: TextAlign.center,
              style: AppText.body.copyWith(color: c.textSecondary),
            ),
          const SizedBox(height: AppSpace.section),
          Text(
            context.l10n.backupNote,
            style: AppText.caption.copyWith(color: c.textTertiary),
          ),
        ],
      ),
    );
  }
}
