import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';
import 'package:snapfig/shared/services/ocr_core/ocr_core.dart';
import 'package:snapfig/shared/services/pdf_core/models/models.dart';
import 'package:snapfig/shared/services/pdf_core/provider/pdf_provider.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:logging/logging.dart';
import 'dart:isolate';

class PDFProviderImpl<OCR extends OCRProvider> extends PDFProvider {
  late final Isar _isar;
  final OCR _ocrProvider;
  final Logger _logger = Logger('PDFProviderImpl');
  final Set<Id> _processing = {};

  List<PDFModel> _pdfs = [];

  @override
  List<BasePdf> get pdfs => _pdfs;

  PDFProviderImpl({required OCR ocrProvider}) : _ocrProvider = ocrProvider {
    _initDatabase();
  }

  // 데이터베이스 초기화
  Future<void> _initDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open([
      PDFModelSchema,
      PageModelSchema,
      LayoutModelSchema,
    ], directory: dir.path);
    _listenDatabase();
  }

  void _listenDatabase() {
    final stream = _isar.pDFModels.watchLazy();
    stream.listen((_) async {
      _pdfs = await _isar.pDFModels.where().findAll();
      _logger.info('PDFs are changed.');
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
    await Isolate.spawn(_ocrProcess, [_ocrProvider, pdf, receivePort.sendPort]);
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
    final PDFModel pdf = args[1];
    final SendPort sendPort = args[2];
    try {
      final ocrResult = await ocrProvider.process(pdf);
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
    throw UnimplementedError();
  }

  @override
  Future<void> addPDF(String filePath) async {
    final pdfInfo = await PdfDocument.openFile(filePath);
    try {
      final pdf = PDFModel.create(
        name: pdfInfo.sourceName,
        path: filePath,
        createdAt: DateTime.now(),
        totalPages: pdfInfo.pages.length,
        status: PDFStatus.pending,
      );
      await _isar.writeTxn(() async {
        await _isar.pDFModels.put(pdf);
      });
    } catch (e) {
      _logger.severe('Failed to add PDF: $e');
    } finally {
      await pdfInfo.dispose();
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
  }) async {
    await _isar.writeTxn(() async {
      try {
        final pdf = await _isar.pDFModels.get(id);
        if (pdf == null) {
          _logger.severe('PDF not found: $id');
          return;
        }
        pdf.update(name: name, updatedAt: updatedAt, status: status);
        await _isar.pDFModels.put(pdf);
      } catch (e) {
        _logger.severe('Failed to update PDF: $e');
      }
    });
  }

  @override
  Future<List<BasePdf>> queryPDFs({String? keyword, PDFStatus? status}) async {
    var query = _isar.pDFModels
        .filter()
        .optional(keyword != null, (q) => q.nameContains(keyword!))
        .optional(status != null, (q) => q.statusEqualTo(status!));
    return await query.findAll();
  }
}
