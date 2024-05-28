import 'package:flutter/material.dart';
import 'package:goola/databases/glucose_database.dart';
import 'package:goola/models/glucose.dart';
import 'package:goola/pages/add_edit_glucose_page.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class GlucoseDetailPage extends StatefulWidget {
  const GlucoseDetailPage({super.key, required this.id});
  final int id;

  @override
  State<GlucoseDetailPage> createState() => _GlucoseDetailPageState();
}

class _GlucoseDetailPageState extends State<GlucoseDetailPage> {
  late Glucose _glucose;
  var _isLoading = false;

  Future<void> _refreshNotes() async {
    setState(() {
      _isLoading = true;
    });

    _glucose = await GlucoseDatabase.instance.getGlucoseById(widget.id);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Glucose Detail',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [_buildEditButton(), _buildDeleteButton()],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                _buildCreatedTime(),
                _buildGlucoseAmount(),
              ],
            ),
    );
  }

  Container _buildCreatedTime() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFEED55),
        border: Border.all(
          color: const Color(0xFF0F1511),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF0F1511),
            spreadRadius: 0,
            blurRadius: 0,
            offset: Offset(2, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        DateFormat('HH:mm, dd MMMM yyyy').format(_glucose.createdTime),
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Container _buildGlucoseAmount() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFF0F1511),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF0F1511),
            spreadRadius: 0,
            blurRadius: 0,
            offset: Offset(2, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        children: [
          Image.asset(
            'assets/images/img_peak_glucose.png',
            width: 56,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _glucose.amount,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F1511),
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
                softWrap: true,
              ),
              const Text(
                'mg/dL',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton() {
    return IconButton(
        onPressed: () async {
          if (_isLoading) return;
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddEditGlucosePage(
                        glucose: _glucose,
                      )));
          _refreshNotes();
        },
        icon: const Icon(Iconsax.edit));
  }

  Widget _buildDeleteButton() {
    return IconButton(
        onPressed: () async {
          if (_isLoading) return;
          await GlucoseDatabase.instance.deleteGlucoseById(widget.id);
          Navigator.pop(context);
        },
        icon: const Icon(Iconsax.trash));
  }
}
