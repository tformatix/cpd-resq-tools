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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n?.blattler_title ?? 'Blattler'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _openSearchDialog(context);
            },
          )
        ],
      ),
      body: BlocBuilder<BlattlerCubit, BlattlerState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SfPdfViewer.asset(
            'assets/blattler.pdf',
            controller: _pdfViewerController,
          );
        },
      ),
    );
  }

  void _openSearchDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title:  Text(context.l10n?.blattler_search_header ?? 'Search in PDF'),
          content: TextField(
            controller: _searchController,
            decoration:  InputDecoration(hintText: context.l10n?.blattler_search_words ?? 'Search'),
          ),
          actions: <Widget>[
            TextButton(
              child:  Text(context.l10n?.blattler_cancel ?? 'Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text(context.l10n?.blattler_search ?? 'Search'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _pdfViewerController.searchText(_searchController.text);
              },
            ),
          ],
        );
      },
    );
  }
}

