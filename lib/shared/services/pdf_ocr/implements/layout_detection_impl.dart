import 'dart:io';
import 'package:logging/logging.dart';
import 'package:snapfig/shared/services/pdf_ocr/interfaces/layout_model.dart';
import 'package:ultralytics_yolo/yolo.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import '../interfaces/layout_detection.dart';

class LayoutDetectionProcessImpl extends LayoutDetectionProcess {
  final _logger = Logger('LayoutDetectionProcessImpl');

  // 플랫폼별 모델 파일명 상수화
  static const String _modelName = 'doclaynet';
  static const String _androidAssetModel =
      'assets/models/yolov8n-doclaynet_float32.tflite';
  static const String _iosAssetModel =
      'assets/models/yolov11n-doclaynet.mlmodel';

  // 레이아웃 모델에 들어갈 이미지 넓이
  static const double _layoutWidth = 640;

  LayoutDetectionProcessImpl({
    required super.imgBitmap,
    required super.imgSize,
  });

  @override
  Future<LayoutDetectionResult> detect() async {
    try {
      await _prepareModelIfNeeded();
      _logger.info('Resizing image...');
      final resizedImg = _resizedImg();
      _logger.info('Predicting layout detection...');
      final result = await LayoutDetectionProcess.yolo!.predict(resizedImg);
      _logger.info('Layout detected.');
      return LayoutDetectionResult(
        layouts:
            (result['boxes'] as List<Map<String, dynamic>>)
                .map(_convertLayoutData)
                .toList(),
        isSuccess: true,
      );
    } catch (e, stack) {
      _logger.severe('Layout detection failed: $e', e, stack);
      return LayoutDetectionResult(layouts: [], isSuccess: false);
    }
  }

  Uint8List _resizedImg() {
    final resizedSize = _getResizedSize();
    final img = decodeImage(imgBitmap);
    if (img == null) {
      throw LayoutDetectionError('Failed to decode image');
    }
    final resizedImg = copyResize(
      img,
      width: resizedSize.width.toInt(),
      height: resizedSize.height.toInt(),
      interpolation: Interpolation.linear,
    );

    return encodePng(resizedImg);
  }

  Size _getResizedSize() {
    final ratio = imgSize.width / imgSize.height;
    Size resizedSize;
    if (_layoutWidth / ratio < _layoutWidth) {
      resizedSize = Size(_layoutWidth, _layoutWidth / ratio);
    } else {
      resizedSize = Size(_layoutWidth * ratio, _layoutWidth);
    }
    return resizedSize;
  }

  Future<void> _prepareModelIfNeeded() async {
    if (LayoutDetectionProcess.yolo != null) return;
    _logger.info('Loading layout detection model...');
    final modelPath = await _ensureModelFileExists();
    await _initYolo(modelPath);
    _logger.info('Layout detection model loaded');
  }

  Future<String> _ensureModelFileExists() async {
    final internalModelName = _getModelNameForPlatform();
    final assetModelPath = _getAssetModelPathForPlatform();
    final dir = Directory.systemTemp;
    if (!await dir.exists()) {
      await dir.create();
    }
    final internalFile = File('${dir.path}/$internalModelName');
    if (!await internalFile.exists()) {
      _logger.info(
        'Model not found in internal storage. Copying from assets...',
      );
      final byteData = await rootBundle.load(assetModelPath);
      await internalFile.writeAsBytes(byteData.buffer.asUint8List());
      _logger.info('Model copied to internal storage: ${internalFile.path}');
    }
    return internalFile.path;
  }

  String _getModelNameForPlatform() {
    if (Platform.isAndroid) {
      return '$_modelName.tflite';
    } else if (Platform.isIOS) {
      return '$_modelName.mlmodel';
    } else {
      throw Exception('Unsupported platform');
    }
  }

  String _getAssetModelPathForPlatform() {
    if (Platform.isAndroid) {
      return _androidAssetModel;
    } else if (Platform.isIOS) {
      return _iosAssetModel;
    } else {
      throw Exception('Unsupported platform');
    }
  }

  Future<void> _initYolo(String modelPath) async {
    if (!await _isModelUsable(modelPath)) {
      throw LayoutDetectionError('No model found at $modelPath');
    }
    LayoutDetectionProcess.yolo = YOLO(
      modelPath: modelPath,
      task: YOLOTask.detect,
    );
    try {
      await LayoutDetectionProcess.yolo!.loadModel();
    } catch (e) {
      throw LayoutDetectionError('Failed to load layout detection model: $e');
    }
  }

  Future<bool> _isModelUsable(String modelPath) async {
    final exists = (await YOLO.checkModelExists(modelPath))['exists'] == true;
    return exists;
  }

  LayoutData _convertLayoutData(Map<String, dynamic> result) {
    return LayoutData(
      id: result['index'],
      type: _convertLayoutType(result['cls']),
      confidence: result['confidence'],
      coordinate: _convertCoordinate(result['bbox']),
    );
  }

  LayoutType _convertLayoutType(String type) {
    switch (type) {
      case 'Caption':
        return LayoutType.caption;
      case 'Footnote':
        return LayoutType.footnote;
      case 'Title':
        return LayoutType.title;
      case 'Formula':
        return LayoutType.formula;
      case 'List-item':
        return LayoutType.listItem;
      case 'Page-footer':
        return LayoutType.pageFooter;
      case 'Page-header':
        return LayoutType.pageHeader;
      case 'Picture':
        return LayoutType.picture;
      case 'Section-header':
        return LayoutType.sectionHeader;
      case 'Table':
        return LayoutType.table;
      case 'Text':
        return LayoutType.text;
      default:
        return LayoutType.unknown;
    }
  }

  Rect _convertCoordinate(List<Object?> box) {
    final resizedSize = _getResizedSize();
    final scaleX = imgSize.width / resizedSize.width;
    final scaleY = imgSize.height / resizedSize.height;

    final x = (box[0] as num).toDouble() * scaleX;
    final y = (box[1] as num).toDouble() * scaleY;
    final w = (box[2] as num).toDouble() * scaleX;
    final h = (box[3] as num).toDouble() * scaleY;

    return Rect.fromLTWH(
      x.toDouble(),
      y.toDouble(),
      w.toDouble(),
      h.toDouble(),
    );
  }
}
