import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/router.dart';
import '../../app/theme.dart';
import '../../app/widgets/app_button.dart';
import '../../domain/image_prep.dart';

/// CAM-01 카메라: 촬영 / 앨범. 권한은 사용 시점에 OS가 요청.
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final _picker = ImagePicker();
  bool _busy = false;
  String? _error;

  Future<void> _pick(ImageSource source) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final x = await _picker.pickImage(source: source, imageQuality: 92);
      if (x == null) return;
      final raw = await x.readAsBytes();
      final jpeg = await prepareForIdentification(raw); // 1024px, EXIF 제거
      final path = await savePhotoLocally(jpeg);
      if (!mounted) return;
      context.push(AppRoutes.identify, extra: path);
    } catch (e) {
      setState(() => _error = '사진을 가져오지 못했어요. 권한을 확인하거나 다른 사진으로 시도해 보세요');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final bottomPad =
        AppSize.tabBarHeight +
        AppSize.cameraButtonOverlap +
        AppSpace.lg +
        MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpace.screenH,
            AppSpace.lg,
            AppSpace.screenH,
            bottomPad,
          ),
          children: [
            Text('식별', style: AppText.headline.copyWith(color: c.textPrimary)),
            const SizedBox(height: AppSpace.xs),
            Text(
              '잎 전체가 나오게 찍어 주세요',
              style: AppText.caption.copyWith(color: c.textSecondary),
            ),
            const SizedBox(height: AppSpace.section),
            Center(
              child: Container(
                width: AppSize.emptyIllustration * 1.5,
                height: AppSize.emptyIllustration * 1.5,
                decoration: BoxDecoration(
                  color: c.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: c.outline),
                ),
                child: Icon(
                  Icons.center_focus_weak_rounded,
                  size: AppSize.emptyIllustration * 0.6,
                  color: c.textTertiary,
                ),
              ),
            ),
            const SizedBox(height: AppSpace.xl),
            Text(
              '밝은 곳에서, 잎이 화면의 절반 이상 차게',
              style: AppText.body.copyWith(color: c.textSecondary),
              textAlign: TextAlign.center,
            ),
            Text(
              '꽃이 있으면 꽃도 함께 찍으면 더 정확해요',
              style: AppText.caption.copyWith(color: c.textTertiary),
              textAlign: TextAlign.center,
            ),
            if (_error != null) ...[
              const SizedBox(height: AppSpace.md),
              Text(
                _error!,
                style: AppText.caption.copyWith(color: c.error),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: AppSpace.section),
            AppButton.primary(
              label: _busy ? '준비 중…' : '사진 찍기',
              icon: Icons.photo_camera_rounded,
              onPressed: _busy ? null : () => _pick(ImageSource.camera),
            ),
            const SizedBox(height: AppSpace.md),
            AppButton.secondary(
              label: '앨범에서 고르기',
              icon: Icons.photo_library_outlined,
              onPressed: _busy ? null : () => _pick(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }
}
