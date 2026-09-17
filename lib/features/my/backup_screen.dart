import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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
          subject: '잘자라라 기록 백업',
          text: '잘자라라 기록 백업 파일이에요. 새 폰에서 MY › 기록 가져오기로 복원할 수 있어요',
        ),
      );
      if (mounted) setState(() => _message = '파일을 만들었어요. 보관할 곳으로 보내 주세요');
    } catch (e) {
      if (mounted) setState(() => _message = '내보내기에 실패했어요: $e');
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
      setState(() => _message = '잘자라라 백업 파일이 아니에요');
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('기록을 가져올까요?'),
        content: Text(
          '${DateFormat('yyyy년 M월 d일', 'ko_KR').format(summary.exportedAt)}에 내보낸 파일이에요.\n'
          '식물 ${summary.plants}개 · 일기 ${summary.diaries}개 · 사진 ${summary.photos}장\n\n'
          '지금 이 폰에 있는 기록은 모두 이 파일의 내용으로 바뀌어요.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('가져오기', style: TextStyle(color: ctx.colors.error)),
          ),
        ],
      ),
    );
    if (ok != true) return;

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
      if (mounted) setState(() => _message = '가져왔어요. 홈에서 확인해 보세요');
    } catch (e) {
      if (mounted) setState(() => _message = '가져오기에 실패했어요: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      appBar: AppBar(title: const Text('기록 내보내기·가져오기')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.screenH),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '내보내기',
                  style: AppText.title.copyWith(color: c.textPrimary),
                ),
                const SizedBox(height: AppSpace.sm),
                Text(
                  '식물·물 준 기록·일기·사진을 파일 하나로 만들어요. 카카오톡 나에게 보내기, 구글 드라이브 등 원하는 곳에 보관하세요',
                  style: AppText.body.copyWith(color: c.textSecondary),
                ),
                const SizedBox(height: AppSpace.lg),
                AppButton.primary(
                  label: '파일 만들어 보내기',
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
                  '가져오기',
                  style: AppText.title.copyWith(color: c.textPrimary),
                ),
                const SizedBox(height: AppSpace.sm),
                Text(
                  '새 폰에서 내보낸 파일을 고르면 그대로 복원돼요. 지금 폰에 있는 기록은 파일 내용으로 바뀌니 주의하세요',
                  style: AppText.body.copyWith(color: c.textSecondary),
                ),
                const SizedBox(height: AppSpace.lg),
                AppButton.secondary(
                  label: '파일 골라서 가져오기',
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
            '참고: 폰 자체 백업(구글 계정 백업, iCloud 백업)을 켜 두면 새 폰으로 옮길 때 기록이 자동으로 따라와요. '
            '안드로이드 자동 백업에는 사진이 빠지니, 사진까지 옮기려면 이 화면의 내보내기를 쓰세요',
            style: AppText.caption.copyWith(color: c.textTertiary),
          ),
        ],
      ),
    );
  }
}
