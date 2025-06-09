abstract class Summarizer {
  Future<String> summarizeText(String text);
  Future<String> summarizeFigure(String pdfPath, String xref);
}
