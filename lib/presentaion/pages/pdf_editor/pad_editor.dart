import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart'; // For state management
import 'dart:math' as math;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'pdf_editor_service.dart';

class PDFEditorApp extends StatelessWidget {
  const PDFEditorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Editor',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ChangeNotifierProvider(create: (_) => PdfEditorNotifier(), child: const PdfEditorScreen()),
    );
  }
}

// Using ChangeNotifier to notify UI about PDF changes
class PdfEditorNotifier extends ChangeNotifier {
  final PdfEditorService _service = PdfEditorService();

  PdfEditorService get service => _service;

  List<Uint8List> get pageImages => _service.pageImages;
  List<EditablePdfItem> get editableItems => _service.editableItems;

  Future<void> loadPdf() async {
    await _service.loadPdfFromFile();
    notifyListeners();
  }

  Future<void> addImage(Uint8List imageBytes, int pageIndex, Rect position) async {
    _service.addImage(imageBytes, pageIndex, position);
    notifyListeners(); // Refresh UI to show the new item visually
  }

  Future<void> addText(String text, int pageIndex, Rect position) async {
    _service.addText(text, pageIndex, position);
    notifyListeners(); // Refresh UI to show the new item visually
  }

  void updateItemPosition(String id, Rect newPosition) {
    _service.updateItemPosition(id, newPosition);
    notifyListeners(); // Refresh UI to reflect the change
  }

  Future<String?> savePdf() async {
    final path = await _service.savePdf();
    // After saving, you might want to reload the PDF to show the actual saved state
    // For simplicity, we just save and notify.
    return path;
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}

// ... (imports and PdfEditorService as before, but without _renderPdfPages and _pageImages)

// In PdfEditorService:
// Remove _renderPdfPages() and _pageImages.
// You will pass the loaded PdfDocument to SfPdfViewer.

class PdfEditorScreen extends StatefulWidget {
  const PdfEditorScreen({super.key});

  @override
  State<PdfEditorScreen> createState() => _PdfEditorScreenState();
}

class _PdfEditorScreenState extends State<PdfEditorScreen> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final PdfEditorService _pdfEditorService = PdfEditorService(); // No ChangeNotifier needed for viewer directly
  PdfDocument? _currentPdfDocument; // Holds the currently loaded PDF

  // List to track editable items, similar to before
  List<EditablePdfItem> _editableItems = [];

  // Variables to help with coordinate mapping
  double _pdfViewWidth = 0; // Actual pixel width of the viewer area
  double _pdfViewHeight = 0; // Actual pixel height of the viewer area
  double _pdfPageWidthPoints = 0; // Native width of the current page in PDF points
  double _pdfPageHeightPoints = 0; // Native height of the current page in PDF points

  @override
  void initState() {
    super.initState();
    _pdfViewerController.addListener(_viewerListener);
  }

  void _viewerListener() {
    // Get current page dimensions and scale
    // This is where you'd retrieve information for coordinate mapping
    if (_pdfViewerController.pageCount > 0) {
      final int currentPage = _pdfViewerController.pageNumber - 1; // 0-indexed
      // SfPdfViewer doesn't directly expose the rendered pixel size of the page
      // It mainly gives you scroll position and zoom factor.
      // You'll need to infer the pixel dimensions from the viewer's size and zoom.
      // This is the trickiest part.
    }
    setState(() {
      // Rebuild to reflect any changes in position/scale of overlays
    });
  }

  // Helper to map Flutter pixels to PDF points
  Rect _mapFlutterRectToPdfRect(Rect flutterRect, int pageIndex) {
    // This is highly dependent on how SfPdfViewer renders and scales pages.
    // This is a conceptual mapping. You need to derive the actual scale.
    // If the PDF page is 612x792 points (Letter), and the viewer renders it
    // to, say, 800x1036 pixels for a given zoom level:
    // scaleX = 800 / 612; scaleY = 1036 / 792;

    // A simpler (but less robust) initial assumption:
    // 1 PDF point = 1 Flutter pixel at 100% zoom of SfPdfViewer
    // This is often not true, especially with different device DPIs.

    // You would need to calculate the current "effective" pixel dimensions
    // of the PDF page within the viewer.
    // Example: (Highly simplified and likely inaccurate without more data from SfPdfViewer)
    // double zoomFactor = _pdfViewerController.zoomFactor;
    // double pdfPageActualWidth = _currentPdfDocument!.pages[pageIndex].size.width;
    // double pdfPageActualHeight = _currentPdfDocument!.pages[pageIndex].size.height;

    // You would need to determine the pixel width and height of the PDF page
    // as it is rendered inside the SfPdfViewer.
    // For example, if you know SfPdfViewer displays the page with a width of `viewerWidth`
    // and height of `viewerHeight` at `1.0` zoom:
    // final double scaleFactorX = _pdfViewWidth / _pdfPageWidthPoints;
    // final double scaleFactorY = _pdfViewHeight / _pdfPageHeightPoints;

    // For now, let's just return the flutterRect as-is, assuming a 1:1 mapping for demonstration.
    // This part *needs* careful calibration with actual viewer dimensions.
    return flutterRect;
  }

  // Helper to map PDF points to Flutter pixels for displaying overlays
  Rect _mapPdfRectToFlutterRect(Rect pdfRect, int pageIndex) {
    // This is the inverse of the above, to place the overlay correctly
    // Example: (Highly simplified and likely inaccurate)
    // final double scaleFactorX = _pdfViewWidth / _pdfPageWidthPoints;
    // final double scaleFactorY = _pdfViewHeight / _pdfPageHeightPoints;
    // return Rect.fromLTWH(
    //   pdfRect.left * scaleFactorX,
    //   pdfRect.top * scaleFactorY,
    //   pdfRect.width * scaleFactorX,
    //   pdfRect.height * scaleFactorY,
    // );
    return pdfRect; // For now, assume 1:1
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Editor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_open),
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['pdf'],
              );
              if (result != null && result.files.single.path != null) {
                File file = File(result.files.single.path!);
                Uint8List bytes = await file.readAsBytes();
                setState(() {
                  _currentPdfDocument = PdfDocument(inputBytes: bytes);
                  _editableItems.clear(); // Clear old items
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: () async {
              if (_currentPdfDocument != null && _currentPdfDocument!.pages.count > 0) {
                final Uint8List dummyImageBytes = (await NetworkAssetBundle(Uri.parse('https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png')).load(''))
                    .buffer.asUint8List();
                setState(() {
                  _editableItems.add(EditablePdfItem(
                    id: 'image_${DateTime.now().millisecondsSinceEpoch}',
                    position: Rect.fromLTWH(50, 50, 100, 100), // Initial PDF points
                    pageIndex: _pdfViewerController.pageNumber -1, // Current page
                    content: dummyImageBytes,
                    type: EditableItemType.image,
                  ));
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Load a PDF first!')),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.text_fields),
            onPressed: () {
              if (_currentPdfDocument != null && _currentPdfDocument!.pages.count > 0) {
                setState(() {
                  _editableItems.add(EditablePdfItem(
                    id: 'text_${DateTime.now().millisecondsSinceEpoch}',
                    position: Rect.fromLTWH(150, 150, 120, 20), // Initial PDF points
                    pageIndex: _pdfViewerController.pageNumber - 1, // Current page
                    content: 'Hello Flutter!',
                    type: EditableItemType.text,
                  ));
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Load a PDF first!')),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              if (_currentPdfDocument != null) {
                // Create a new document to apply changes cleanly
                final PdfDocument newDocument = PdfDocument(inputBytes: _currentPdfDocument!.saveSync());

                for (final item in _editableItems) {
                  final PdfPage page = newDocument.pages[item.pageIndex];
                  if (item.type == EditableItemType.image) {
                    final PdfBitmap image = PdfBitmap(item.content as Uint8List);
                    page.graphics.drawImage(image, item.position);
                  } else {
                    final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);
                    page.graphics.drawString(
                      item.content as String,
                      font,
                      brush: PdfSolidBrush(PdfColor(0, 0, 0)),
                      bounds: item.position,
                    );
                  }
                }

                List<int> bytes = newDocument.saveSync();
                newDocument.dispose();

                final directory = await getApplicationDocumentsDirectory();
                final file = File('${directory.path}/edited_document.pdf');
                await file.writeAsBytes(bytes);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('PDF saved to: ${file.path}')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No PDF to save.')),
                );
              }
            },
          ),
        ],
      ),
      body: _currentPdfDocument == null
          ? const Center(child: Text('Please load a PDF to start editing.'))
          : LayoutBuilder( // Use LayoutBuilder to get the size of the SfPdfViewer
        builder: (context, constraints) {
          // Store the current size of the viewer
          _pdfViewWidth = constraints.maxWidth;
          _pdfViewHeight = constraints.maxHeight;

          // Get current page dimensions in PDF points (conceptual, needs to be precise)
          if (_pdfViewerController.pageCount > 0 && _currentPdfDocument != null) {
            final int currentPageIndex = _pdfViewerController.pageNumber - 1;
            if (currentPageIndex < _currentPdfDocument!.pages.count) {
              _pdfPageWidthPoints = _currentPdfDocument!.pages[currentPageIndex].size.width;
              _pdfPageHeightPoints = _currentPdfDocument!.pages[currentPageIndex].size.height;
            }
          }

          return Stack(
            children: [
              SfPdfViewer.memory(
                _currentPdfDocument!.saveAsBytesSync(), // Pass the bytes of the current document
                controller: _pdfViewerController,
                // Listen to important events for mapping coordinates
                onPageChanged: (details) {
                  setState(() { /* update page-dependent items */ });
                },
                onZoomLevelChanged: (details) {
                  setState(() { /* update overlays based on zoom */ });
                },
                onDocumentLoaded: (details) {
                  // Initial page dimensions after document is loaded
                  if (_currentPdfDocument != null && _currentPdfDocument!.pages.count > 0) {
                    _pdfPageWidthPoints = _currentPdfDocument!.pages[0].size.width;
                    _pdfPageHeightPoints = _currentPdfDocument!.pages[0].size.height;
                  }
                  setState(() {}); // Refresh to potentially show overlays
                },
              ),

              // Overlay editable items on the current visible page
              ..._editableItems
                  .where((item) => item.pageIndex == _pdfViewerController.pageNumber - 1)
                  .map((item) {
                // Need to transform item.position (PDF points) to Flutter pixels
                // based on current viewer zoom and scroll. This is the hardest part.
                // For simplicity, let's use a placeholder.
                // You need to calculate the actual pixel position relative to the
                // top-left of the SfPdfViewer widget.
                // _pdfViewerController.scrollOffset has current scroll position.
                // _pdfViewerController.zoomFactor has current zoom.

                // This requires complex calculations involving:
                // 1. PDF page's native width/height (in points)
                // 2. SfPdfViewer's current zoom level
                // 3. SfPdfViewer's current scroll offset
                // 4. The actual pixel dimensions of the rendered PDF page within the viewer.

                // PLACEHOLDER for coordinate mapping:
                final double scaleX = _pdfViewWidth / _pdfPageWidthPoints; // Highly approximate
                final double scaleY = _pdfViewHeight / _pdfPageHeightPoints; // Highly approximate

                final double overlayLeft = (item.position.left * scaleX) - _pdfViewerController.scrollOffset.dx;
                final double overlayTop = (item.position.top * scaleY) - _pdfViewerController.scrollOffset.dy;
                final double overlayWidth = item.position.width * scaleX;
                final double overlayHeight = item.position.height * scaleY;


                return Positioned(
                  left: overlayLeft,
                  top: overlayTop,
                  child: DraggableResizableItem(
                    item: item,
                    onUpdate: (newFlutterRect) {
                      // Convert the new Flutter pixel rect back to PDF point rect
                      // This also requires the precise scale factors.
                      final double inverseScaleX = _pdfPageWidthPoints / _pdfViewWidth;
                      final double inverseScaleY = _pdfPageHeightPoints / _pdfViewHeight;

                      final Rect newPdfRect = Rect.fromLTWH(
                        (newFlutterRect.left + _pdfViewerController.scrollOffset.dx) * inverseScaleX,
                        (newFlutterRect.top + _pdfViewerController.scrollOffset.dy) * inverseScaleY,
                        newFlutterRect.width * inverseScaleX,
                        newFlutterRect.height * inverseScaleY,
                      );

                      final index = _editableItems.indexWhere((e) => e.id == item.id);
                      if (index != -1) {
                        setState(() {
                          _editableItems[index].position = newPdfRect;
                        });
                      }
                    },
                    // Pass the current *effective* zoom level for the overlay handles
                    // This needs to be the zoom factor of the interactive viewer, not the PDF points.
                    viewerScale: _pdfViewerController.zoomLevel, // Use SfPdfViewer's zoom
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pdfViewerController.removeListener(_viewerListener);
    _pdfViewerController.dispose();
    _currentPdfDocument?.dispose();
    super.dispose();
  }
}

// DraggableResizableItem remains mostly the same, but now it operates in
// Flutter pixel coordinates, and the onUpdate callback converts them to PDF points.
// Make sure viewerScale is correctly passed from the SfPdfViewer's zoomFactor.
// ... (DraggableResizableItem widget code as before)

// --- Draggable & Resizable Item Widget ---
class DraggableResizableItem extends StatefulWidget {
  final EditablePdfItem item;
  final Function(Rect newPosition) onUpdate;
  final double viewerScale; // Current scale of the InteractiveViewer

  const DraggableResizableItem({super.key, required this.item, required this.onUpdate, required this.viewerScale});

  @override
  State<DraggableResizableItem> createState() => _DraggableResizableItemState();
}

class _DraggableResizableItemState extends State<DraggableResizableItem> {
  late Rect _currentRect;

  @override
  void initState() {
    super.initState();
    _currentRect = widget.item.position;
  }

  // Update rect if the parent item changes (e.g., via undo/redo)
  @override
  void didUpdateWidget(covariant DraggableResizableItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.position != widget.item.position) {
      _currentRect = widget.item.position;
    }
  }

  void _onDrag(DragUpdateDetails details) {
    setState(() {
      _currentRect = Rect.fromLTWH(
        _currentRect.left + details.delta.dx / widget.viewerScale, // Scale delta by viewer scale
        _currentRect.top + details.delta.dy / widget.viewerScale,
        _currentRect.width,
        _currentRect.height,
      );
    });
    widget.onUpdate(_currentRect);
  }

  void _onResize(DragUpdateDetails details, String handle) {
    setState(() {
      double newLeft = _currentRect.left;
      double newTop = _currentRect.top;
      double newWidth = _currentRect.width;
      double newHeight = _currentRect.height;

      final double deltaX = details.delta.dx / widget.viewerScale;
      final double deltaY = details.delta.dy / widget.viewerScale;

      switch (handle) {
        case 'topLeft':
          newLeft += deltaX;
          newTop += deltaY;
          newWidth -= deltaX;
          newHeight -= deltaY;
          break;
        case 'topRight':
          newTop += deltaY;
          newWidth += deltaX;
          newHeight -= deltaY;
          break;
        case 'bottomLeft':
          newLeft += deltaX;
          newWidth -= deltaX;
          newHeight += deltaY;
          break;
        case 'bottomRight':
          newWidth += deltaX;
          newHeight += deltaY;
          break;
      }

      // Ensure minimum size
      newWidth = math.max(newWidth, 20.0);
      newHeight = math.max(newHeight, 20.0);

      _currentRect = Rect.fromLTWH(newLeft, newTop, newWidth, newHeight);
    });
    widget.onUpdate(_currentRect);
  }

  @override
  Widget build(BuildContext context) {
    // Determine the content based on item type
    Widget contentWidget;
    if (widget.item.type == EditableItemType.image) {
      contentWidget = Image.memory(widget.item.content as Uint8List, fit: BoxFit.contain);
    } else {
      contentWidget = Text(
        widget.item.content as String,
        style: const TextStyle(fontSize: 12, color: Colors.blue), // Base font size
        maxLines: 1, // Or adjust as needed for multiline text
        overflow: TextOverflow.clip,
      );
    }

    // Size of the resize handles, scaled with the viewer zoom level
    final double handleSize = 16.0 / widget.viewerScale;

    return GestureDetector(
      onPanUpdate: _onDrag, // Drags the entire item
      child: Stack(
        children: [
          // The actual content (image or text)
          Container(
            width: _currentRect.width,
            height: _currentRect.height,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 1.0 / widget.viewerScale), // Scale border thickness
            ),
            child: contentWidget,
          ),
          // Resize handles (positioned relative to the item's current Rect)
          _buildResizeHandle(Alignment.topLeft, 'topLeft', handleSize),
          _buildResizeHandle(Alignment.topRight, 'topRight', handleSize),
          _buildResizeHandle(Alignment.bottomLeft, 'bottomLeft', handleSize),
          _buildResizeHandle(Alignment.bottomRight, 'bottomRight', handleSize),
        ],
      ),
    );
  }

  Widget _buildResizeHandle(Alignment alignment, String handleName, double handleSize) {
    double left = 0, top = 0;
    if (alignment == Alignment.topLeft) {
      left = -handleSize / 2;
      top = -handleSize / 2;
    } else if (alignment == Alignment.topRight) {
      left = _currentRect.width - handleSize / 2;
      top = -handleSize / 2;
    } else if (alignment == Alignment.bottomLeft) {
      left = -handleSize / 2;
      top = _currentRect.height - handleSize / 2;
    } else if (alignment == Alignment.bottomRight) {
      left = _currentRect.width - handleSize / 2;
      top = _currentRect.height - handleSize / 2;
    }

    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onPanUpdate: (details) => _onResize(details, handleName),
        child: Container(
          width: handleSize,
          height: handleSize,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.8),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1.0 / widget.viewerScale),
          ),
        ),
      ),
    );
  }
}
