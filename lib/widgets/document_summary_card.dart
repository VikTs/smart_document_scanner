import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/core/utils/date_utils.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';
import 'package:smart_documents_scanner/models/document_type.dart';

class DocumentSummaryCard extends StatelessWidget {
  final Document document;

  const DocumentSummaryCard({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    if (document.type == DocumentType.unknown) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: const UnknownDocumentBanner(),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Padding(padding: const EdgeInsets.all(16), child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (document.type == DocumentType.receipt) {
      return Column(
        children: [
          SummaryRow(
            icon: Icons.description,
            label: "document_details.items.document_type".tr(),
            value: "document_types.${document.type.name}".tr(),
          ),
          SummaryRow(
            icon: Icons.store,
            label: "document_details.items.merchant".tr(),
            value: document.placeType != null
                ? 'places.${document.placeType}'.tr()
                : '-',
          ),
          SummaryRow(
            icon: Icons.calendar_today,
            label: "document_details.items.date".tr(),
            value: document.documentDate != null
                ? formatDate(document.documentDate!)
                : '-',
          ),
          SummaryRow(
            icon: Icons.attach_money,
            label: "document_details.items.total".tr(),
            value: document.totalAmount != null
                ? "${document.totalAmount?.toStringAsFixed(2)} ${document.currency ?? ''}"
                : "-",
            isBold: true,
          ),
        ],
      );
    }

    if (document.type == DocumentType.idDocument) {
      return Column(
        children: [
          SummaryRow(
            icon: Icons.description,
            label: "document_details.items.document_type".tr(),
            value: "document_types.${document.type.name}".tr(),
          ),
          SummaryRow(
            icon: Icons.event,
            label: 'document_details.items.expiration_date'.tr(),
            value: document.expirationDate != null
                ? formatDate(document.expirationDate!)
                : "-",
          ),
        ],
      );
    }

    return Column(
      children: [
        SummaryRow(
          icon: Icons.description,
          label: "document_details.items.document_type".tr(),
          value: "document_types.${document.type.name}".tr(),
        ),
      ],
    );
  }
}

class SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isBold;

  const SummaryRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class UnknownDocumentBanner extends StatelessWidget {
  const UnknownDocumentBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'document_details.unknown_document_banner_title'.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.orange,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'document_details.unknown_document_banner_message'.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.orange,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
