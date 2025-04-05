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
          title: const Text('Suche'),
          content: TextField(
            controller: _searchController,
            decoration: const InputDecoration(hintText: 'Suchbegriff eingeben'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Abbrechen'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Suchen'),
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

