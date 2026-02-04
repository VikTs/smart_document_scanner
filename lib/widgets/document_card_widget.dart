import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:smart_documents_scanner/core/utils/date_utils.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_bloc.dart';
import 'package:smart_documents_scanner/screens/document_details_screen.dart';

class DocumentCardWidget extends StatelessWidget {
  final Document document;
  const DocumentCardWidget({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<DocumentsBloc>(),
            child: DocumentDetailsScreen(document: document),
          ),
        ),
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Image.memory(
                document.file,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("document_types.${document.type.name}".tr()),
                  Text(
                    "${'documents.document_card.date_label'.tr()} ${formatDate(document.createdAt, format: "dd/MM/yyyy hh:mm")}",
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
              Spacer(),
              const Icon(Icons.open_in_new, size: 14)
            ],
          ),
        ),
      ),
    );
  }
}
