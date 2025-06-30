import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart'; // For PDF creation/editing
import 'package:pdf_render/pdf_render.dart' as pdf_render; // For rendering PDF pages to images
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart'; // To generate unique IDs for items

// Represents an editable item on the PDF (image or text)
class EditablePdfItem {
  String id; // Unique ID for tracking
  Rect position; // Position and size on the PDF page (in PDF points)
  int pageIndex; // Which page the item is on
  dynamic content; // Actual content (Uint8List for image, String for text)
  EditableItemType type;

  EditablePdfItem({required this.id, required this.position, required this.pageIndex, required this.content, required this.type});
}

enum EditableItemType { image, text }

class PdfEditorService {
  PdfDocument? _document; // Syncfusion PDF document for data manipulation
  PdfDocument? _initialDocument; // To keep a pristine copy for rendering
  PdfDocument? _viewDocument; // Document for the viewer
  List<Uint8List> _pageImages = []; // To render PDF pages as images for UI
  List<EditablePdfItem> _editableItems = []; // Track items added by user
  PdfDocument? _originalPdfDocument; // Holds the original loaded PDF

  // For rendering pages to images
  pdf_render.PdfDocument? _pdfRenderDocument; // Document from pdf_render
  final _uuid = const Uuid(); // For generating unique IDs

  List<Uint8List> get pageImages => _pageImages;
  List<EditablePdfItem> get editableItems => _editableItems;

  // --- PDF Loading ---
  Future<void> loadPdfFromFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      Uint8List bytes = await file.readAsBytes();
      await loadPdfFromBytes(bytes);
    }
  }

  Future<void> loadPdfFromBytes(Uint8List bytes) async {
    // Dispose previous documents
    _document?.dispose();
    _initialDocument?.dispose();
    _pdfRenderDocument?.dispose();

    _originalPdfDocument = PdfDocument(inputBytes: bytes); // Syncfusion Document
    _pdfRenderDocument = await pdf_render.PdfDocument.openData(bytes); // Pdf_render Document

    _editableItems.clear(); // Clear existing items

    await _renderPdfPages();
  }

  // Helper to render PDF pages as images for the Flutter UI using pdf_render
  Future<void> _renderPdfPages() async {
    _pageImages.clear();
    if (_pdfRenderDocument == null) return;

    for (int i = 0; i < _pdfRenderDocument!.pageCount; i++) {
      final pdf_render.PdfPage page = await _pdfRenderDocument!.getPage(i + 1); // pages are 1-indexed
      final pdf_render.PdfPageImage image = await page.render();
      _pageImages.add(image.pixels); // Get Uint8List from PdfPageImage
      // await page.close(); // Close the page after rendering
    }
    // Notify UI to rebuild
  }

  // --- Adding Content ---
  void addImage(Uint8List imageBytes, int pageIndex, Rect position) {
    // No need to check _document here, as we only manipulate _editableItems
    // and draw them on a new document when saving.
    final String id = _uuid.v4();
    _editableItems.add(
      EditablePdfItem(id: id, position: position, pageIndex: pageIndex, content: imageBytes, type: EditableItemType.image),
    );
    // The UI will handle displaying this item immediately.
  }

  void addText(String text, int pageIndex, Rect position) {
    final String id = _uuid.v4();
    _editableItems.add(
      EditablePdfItem(id: id, position: position, pageIndex: pageIndex, content: text, type: EditableItemType.text),
    );
    // The UI will handle displaying this item immediately.
  }

  // --- Updating Content (for interactive resizing) ---
  void updateItemPosition(String id, Rect newPosition) {
    final index = _editableItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      _editableItems[index].position = newPosition;
      // In a real app, you might want to trigger a UI update here
    }
  }

  // --- Saving PDF ---
  Future<String?> savePdf() async {
    if (_originalPdfDocument == null) return null;

    // Create a new Syncfusion PdfDocument from the original bytes
    // to ensure all original content is preserved.
    final PdfDocument documentToSave = PdfDocument(inputBytes: _originalPdfDocument!.saveSync());

    for (final item in _editableItems) {
      // Ensure the page exists in the documentToSave. If adding pages is allowed,
      // you might need to add them here.
      if (item.pageIndex >= documentToSave.pages.count) {
        // Handle case where item is on a page that doesn't exist yet
        // For simplicity, we'll just skip it or add pages as needed.
        // For this example, assume items are only on existing pages.
        continue;
      }
      final PdfPage page = documentToSave.pages[item.pageIndex];
      if (item.type == EditableItemType.image) {
        final PdfBitmap image = PdfBitmap(item.content as Uint8List);
        page.graphics.drawImage(image, item.position);
      } else {
        // You might want to define font properties more flexibly
        // based on the item, e.g., allow user to pick font size/color.
        final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);
        page.graphics.drawString(item.content as String, font, brush: PdfSolidBrush(PdfColor(0, 0, 0)), bounds: item.position);
      }
    }

    List<int> bytes = documentToSave.saveSync();
    documentToSave.dispose(); // Dispose the temporary document

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/edited_document.pdf');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  // --- Cleanup ---
  void dispose() {
    _document?.dispose();
    _initialDocument?.dispose();
    _pdfRenderDocument?.dispose(); // Dispose the pdf_render document
    _pageImages.clear();
    _editableItems.clear();
  }
}
