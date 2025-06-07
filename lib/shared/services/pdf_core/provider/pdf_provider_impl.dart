import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:isar/isar.dart';
import 'package:snapfig/shared/services/ocr_core/ocr_core.dart';
import 'package:snapfig/shared/services/pdf_core/models/models.dart';
import 'package:snapfig/shared/services/pdf_core/provider/pdf_provider.dart';
import 'package:path/path.dart' as path_lib;
import 'package:pdfrx/pdfrx.dart';
import 'package:logging/logging.dart';
import 'dart:isolate';

class _PDFInfo {
  final int totalPages;
  final List<int>? thumbnail;

  _PDFInfo({required this.totalPages, this.thumbnail});
}

class PDFProviderImpl<OCR extends OCRProvider> extends PDFProvider {
  late final Isar _isar;
  final OCR _ocrProvider;
  final String _dbPath;
  final Set<Id> _processing = {};
  late final StreamSubscription<void> _databaseSubscription;
  List<PDFModel> _pdfs = [];
  final Logger _logger = Logger('PDFProviderImpl');

  @override
  List<BasePdf> get pdfs => _pdfs;

  PDFProviderImpl._({required OCR ocrProvider, required String dbPath})
    : _ocrProvider = ocrProvider,
      _dbPath = dbPath;

  // 데이터베이스를 로드하고 프로바이더를 반환합니다.
  static Future<PDFProviderImpl<OCR>> load<OCR extends OCRProvider>({
    required OCR ocrProvider,
    required String dbPath,
  }) async {
    final provider = PDFProviderImpl<OCR>._(
      ocrProvider: ocrProvider,
      dbPath: dbPath,
    );
    await provider._initDatabase();
    return provider;
  }

  // 데이터베이스 초기화
  Future<void> _initDatabase() async {
    _isar = await Isar.open([
      PDFModelSchema,
      PageModelSchema,
      LayoutModelSchema,
    ], directory: _dbPath);
    _listenDatabase();
  }

  void _listenDatabase() {
    final stream = _isar.pDFModels.watchLazy(fireImmediately: true);
    _databaseSubscription = stream.listen((_) async {
      _pdfs = await _getAllPdfs();
      _logger.info('PDFs are changed.');
      notifyListeners();
      // OCR 처리 대기 목록 처리
      final pendingPdfs = await _getPendingPdfs();
      for (final pdf in pendingPdfs) {
        if (!_processing.contains(pdf.id)) {
          _processing.add(pdf.id);
          _processPdfWithOcr(pdf);
        }
      }
    });
  }

  Future<List<PDFModel>> _getAllPdfs() async {
    return await _isar.pDFModels.where().sortByUpdatedAt().findAll();
  }

  Future<List<PDFModel>> _getPendingPdfs() async {
    return await _isar.pDFModels
        .filter()
        .statusEqualTo(PDFStatus.pending)
        .findAll();
  }

  // 주어진 PDF에 대한 OCR을 진행합니다. 이때 독립된 isolate로 변경이 되고,
  // 처리 결과는 주 스레드에서 처리됩니다.
  Future<void> _processPdfWithOcr(PDFModel pdf) async {
    await updatePDF(id: pdf.id, status: PDFStatus.processing);
    final receivePort = ReceivePort();
    await Isolate.spawn(_ocrProcess, [
      _ocrProvider,
      pdf.path,
      receivePort.sendPort,
    ]);
    receivePort.listen((ocrResult) async {
      try {
        await _updatePdfModelWithOcrResult(pdf, ocrResult);
      } catch (e) {
        await updatePDF(id: pdf.id, status: PDFStatus.failed);
        _logger.severe('OCR 처리 실패: $e');
      } finally {
        _processing.remove(pdf.id);
        receivePort.close();
      }
    });
  }

  /// Isolate에서 OCR 처리
  static void _ocrProcess(List args) async {
    final OCRProvider ocrProvider = args[0];
    final String pdfPath = args[1];
    final SendPort sendPort = args[2];
    try {
      final ocrResult = await ocrProvider.process(pdfPath);
      sendPort.send(ocrResult);
    } catch (e) {
      sendPort.send(null);
    }
  }

  // OCR 결과를 데이터베이스에 저장합니다.
  Future<void> _updatePdfModelWithOcrResult(
    PDFModel pdf,
    OCRResult? ocrResult,
  ) async {
    if (ocrResult == null) throw Exception('OCR 결과 없음');

    try {
      await _isar.writeTxn(() async {
        // 1. PDF 제목 업데이트 (OCR 결과에 제목이 있으면)
        if (ocrResult.title.isNotEmpty) {
          pdf.update(name: ocrResult.title);
        }

        // 2. 페이지별 데이터 저장
        for (final pageDetail in ocrResult.pages) {
          // 페이지 모델 생성
          final pageModel = PageModel(
            pageIndex: pageDetail.pageIndex,
            fullText: pageDetail.fullText,
            width: 0, // TODO: 실제 페이지 크기를 가져와야 함
            height: 0, // TODO: 실제 페이지 크기를 가져와야 함
          );

          await _isar.pageModels.put(pageModel);

          // 페이지와 PDF 연결
          pageModel.pdf.value = pdf;
          await pageModel.pdf.save();
          pdf.pages.add(pageModel);

          // 3. 레이아웃 데이터 저장
          for (final layout in pageDetail.layouts) {
            LayoutModel layoutModel;

            if (layout is TextLayout) {
              layoutModel = LayoutModel(
                type: LayoutType.text,
                content: layout.text,
                text: layout.text,
                latex: null,
                figureId: null,
                figureNumber: null,
                caption: null,
                referencedFigureId: null,
                referenceText: null,
                top: layout.boundingBox[1],
                left: layout.boundingBox[0],
                width: layout.boundingBox[2] - layout.boundingBox[0],
                height: layout.boundingBox[3] - layout.boundingBox[1],
              );
            } else if (layout is FigureLayoutItem) {
              layoutModel = LayoutModel(
                type: LayoutType.figure,
                content: layout.caption,
                text: null,
                latex: null,
                figureId: layout.figureId,
                figureNumber: layout.figureNumber,
                caption: layout.caption,
                referencedFigureId: null,
                referenceText: null,
                top: layout.boundingBox[1],
                left: layout.boundingBox[0],
                width: layout.boundingBox[2] - layout.boundingBox[0],
                height: layout.boundingBox[3] - layout.boundingBox[1],
              );
            } else if (layout is FigureReferenceLayout) {
              layoutModel = LayoutModel(
                type: LayoutType.figureReference,
                content: layout.referenceText,
                text: layout.referenceText,
                latex: null,
                figureId: null,
                figureNumber: layout.figureNumber,
                caption: null,
                referencedFigureId: layout.referencedFigureId,
                referenceText: layout.referenceText,
                top: layout.boundingBox[1],
                left: layout.boundingBox[0],
                width: layout.boundingBox[2] - layout.boundingBox[0],
                height: layout.boundingBox[3] - layout.boundingBox[1],
              );
            } else {
              continue; // 알 수 없는 레이아웃 타입은 건너뜀
            }

            await _isar.layoutModels.put(layoutModel);

            // 레이아웃과 페이지 연결
            layoutModel.page.value = pageModel;
            await layoutModel.page.save();
            pageModel.layouts.add(layoutModel);
          }

          await pageModel.layouts.save();
        }

        // 4. PDF와 페이지 관계 저장
        await pdf.pages.save();
        await _isar.pDFModels.put(pdf);
      });

      // 5. PDF 상태를 완료로 업데이트 (updatePDF 메서드 사용)
      await updatePDF(
        id: pdf.id,
        status: PDFStatus.completed,
        updatedAt: DateTime.now(),
      );

      _logger.info('PDF OCR 결과 저장 완료: ${pdf.name}');
    } catch (e) {
      _logger.severe('OCR 결과 저장 중 오류 발생: $e');
      // 오류 발생 시 상태를 failed로 업데이트
      await updatePDF(
        id: pdf.id,
        status: PDFStatus.failed,
        updatedAt: DateTime.now(),
      );
      rethrow;
    }
  }

  Future<_PDFInfo> _getPDFInfo(String filePath) async {
    final data = await PdfDocument.openFile(filePath);
    try {
      final thumbnail = await renderPageToPngBytes(data.pages.first);
      return _PDFInfo(totalPages: data.pages.length, thumbnail: thumbnail);
    } catch (e) {
      _logger.severe('Failed to get PDF info: $e');
      return _PDFInfo(totalPages: 0, thumbnail: null);
    } finally {
      await data.dispose();
    }
  }

  Future<Uint8List?> renderPageToPngBytes(PdfPage page) async {
    final thumbnailData = await page.render(
      width: page.width.toInt(),
      height: page.height.toInt(),
    );
    final thumbnailImg = await thumbnailData?.createImage();
    final thumbnailBytes = await thumbnailImg?.toByteData(
      format: ImageByteFormat.png,
    );
    return thumbnailBytes?.buffer.asUint8List();
  }

  @override
  Future<void> addPDF(String filePath) async {
    try {
      final pdf = PDFModel.create(
        name: path_lib.basenameWithoutExtension(filePath),
        path: filePath,
        createdAt: DateTime.now(),
        totalPages: 0,
        status: PDFStatus.pending,
        thumbnail: null,
      );
      await _isar.writeTxn(() async {
        await _isar.pDFModels.put(pdf);
      });
      final pdfInfo = await _getPDFInfo(filePath);
      await updatePDF(
        id: pdf.id,
        thumbnail: pdfInfo.thumbnail,
        totalPages: pdfInfo.totalPages,
      );
    } catch (e) {
      _logger.severe('Failed to add PDF: $e');
    }
  }

  @override
  Future<void> deletePDF(List<BasePdf> pdfs) async {
    await _isar.writeTxn(() async {
      await _isar.pDFModels.deleteAll(pdfs.map((e) => e.id).toList());
    });
  }

  @override
  Future<void> updatePDF({
    required Id id,
    String? name,
    DateTime? updatedAt,
    PDFStatus? status,
    List<int>? thumbnail,
    int? totalPages,
  }) async {
    await _isar.writeTxn(() async {
      try {
        final pdf = await _isar.pDFModels.get(id);
        if (pdf == null) {
          _logger.severe('PDF not found: $id');
          return;
        }
        pdf.update(
          name: name,
          updatedAt: updatedAt,
          status: status,
          thumbnail: thumbnail,
          totalPages: totalPages,
        );
        await _isar.pDFModels.put(pdf);
      } catch (e) {
        _logger.severe('Failed to update PDF: $e');
      }
    });
  }

  @override
  Future<List<BasePdf>> queryPDFs({
    String? keyword,
    PDFStatus? status,
    int? limit,
  }) async {
    var query = _isar.pDFModels
        .filter()
        .optional(keyword != null, (q) => q.nameContains(keyword!))
        .optional(status != null, (q) => q.statusEqualTo(status!))
        .sortByUpdatedAt()
        .optional(limit != null, (q) => q.limit(limit!));
    return await query.findAll();
  }

  @override
  Future<BasePdf?> getPDF(String path) async {
    return await _isar.pDFModels.filter().pathEqualTo(path).findFirst();
  }

  @override
  void dispose() {
    _databaseSubscription.cancel();
    _isar.close();
    super.dispose();
  }
}
