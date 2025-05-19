import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_tools/blocs/blattler_cubit.dart';
import 'package:resq_tools/utils/extensions.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class BlattlerScreen extends StatefulWidget {
  const BlattlerScreen({super.key});

  @override
  State<BlattlerScreen> createState() => _BlattlerScreenState();
}

class _BlattlerScreenState extends State<BlattlerScreen> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final TextEditingController _searchController = TextEditingController();
  late PdfTextSearchResult _searchResult;
  bool _isSearching = false;
  bool _didWarmUp = false;
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _searchResult = PdfTextSearchResult();
    _searchResult.addListener(_onSearchResultChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n?.blattler_title ?? 'Blattler'),
            if (_currentQuery.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 4),
                child: Text(
                  '${context.l10n?.blattler_search_phrase ?? 'Suche'}'
                  ': $_currentQuery',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _openSearchDialog(context);
            },
          ),
          if (_searchResult.hasResult) ...[
            IconButton(
              icon: const Icon(Icons.navigate_before),
              onPressed:
                  _searchResult.hasResult
                      ? () => _searchResult.previousInstance()
                      : null,
            ),
            IconButton(
              icon: const Icon(Icons.navigate_next),
              onPressed:
                  _searchResult.hasResult
                      ? () => _searchResult.nextInstance()
                      : null,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Center(
                child: Text(
                  '${_searchResult.currentInstanceIndex + 1} / ${_searchResult.totalInstanceCount}',
                ),
              ),
            ),
          ],
        ],
        bottom:
            _isSearching
                ? const PreferredSize(
                  preferredSize: Size.fromHeight(4),
                  child: LinearProgressIndicator(),
                )
                : null,
      ),
      body: BlocBuilder<BlattlerCubit, BlattlerState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Stack(
            children: [
              SfPdfViewer.asset(
                'assets/blattler.pdf',
                controller: _pdfViewerController,
                onDocumentLoaded: _onDocumentLoaded,
              ),
              if (_isSearching)
                const Center(child: CircularProgressIndicator()),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchResult.removeListener(_onSearchResultChanged);
    super.dispose();
  }

  void _onSearchResultChanged() {
    setState(() {
      _isSearching = false;
    });
  }

  void _performSearch(String query) {
    setState(() {
      _isSearching = true;
      _currentQuery = query;
    });
    _searchResult = _pdfViewerController.searchText(query);
    _searchResult.addListener(_onSearchResultChanged);
  }

  void _startSearchAndClose(BuildContext dialogContext) {
    Navigator.of(dialogContext).pop();
    _performSearch(_searchController.text.trim());
  }

  void _onDocumentLoaded(PdfDocumentLoadedDetails details) {
    if (!_didWarmUp) {
      _didWarmUp = true;
      _pdfViewerController.searchText('___dummyString123456789___');
    }
  }

  void _openSearchDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(context.l10n?.blattler_search_header ?? 'Search in PDF'),
          content: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: context.l10n?.blattler_search_words ?? 'Search',
            ),
            onSubmitted: (_) => _startSearchAndClose(dialogContext),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(context.l10n?.blattler_cancel ?? 'Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text(context.l10n?.blattler_search ?? 'Search'),
              onPressed: () => _startSearchAndClose(dialogContext),
            ),
          ],
        );
      },
    );
  }
}
