import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

class PdfWithPager extends StatefulWidget {
  const PdfWithPager({super.key});

  @override
  State<PdfWithPager> createState() => _PdfWithPagerState();
}

class _PdfWithPagerState extends State<PdfWithPager> {
  final PdfViewerController _controller = PdfViewerController();
  int _currentPage = 1;
  int _totalPages = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Listen for page changes
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller?.pageNumber ?? 1;

        // Once pageCount becomes > 0, consider PDF loaded
        if (_controller.pageCount > 0 && _isLoading) {
          _totalPages = _controller.pageCount;
          _isLoading = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("pdfrx PDF Viewer")),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                // PDF Viewer
                Expanded(
                  child: PdfViewer.uri(
                    Uri.parse(
                      "https://kptcl.aitalkx.com/appapi/dms/Query/DownloadMongoFileStream?fileId=acc10d5d-70a4-4119-bf18-87cb1af4b8ff",
                    ),
                    controller: _controller,
                    useProgressiveLoading: true,
                    preferRangeAccess: true,
                  ),
                ),

                // Pager UI (visible after totalPages is known)
                if (_totalPages > 0)
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed:
                              _currentPage > 1
                                  ? () {
                                    _controller.goToPage(
                                      pageNumber: (_currentPage - 1).clamp(
                                        1,
                                        _totalPages,
                                      ),
                                    );
                                  }
                                  : null,
                        ),
                        Text("$_currentPage / $_totalPages"),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed:
                              _currentPage < _totalPages
                                  ? () {
                                    _controller.goToPage(
                                      pageNumber: (_currentPage + 1).clamp(
                                        1,
                                        _totalPages,
                                      ),
                                    );
                                  }
                                  : null,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Loading spinner overlay
          if (_isLoading)
            Container(
              color: Colors.white, // or any color you want

              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
