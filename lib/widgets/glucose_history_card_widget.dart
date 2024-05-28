import 'package:flutter/material.dart';
import 'package:goola/models/glucose.dart';
import 'package:intl/intl.dart';

class GlucoseHistoryCardWidget extends StatefulWidget {
  const GlucoseHistoryCardWidget(
    {
      super.key,
      required this.glucose,
      required this.index
    }
  );

  final Glucose glucose;
  final int index;

  @override
  State<GlucoseHistoryCardWidget> createState() => _GlucoseHistoryCardWidgetState();
}

class _GlucoseHistoryCardWidgetState extends State<GlucoseHistoryCardWidget> {
  @override
  Widget build(BuildContext context) {
    final time = DateFormat('HH:mm, dd MMMM yyyy').format(widget.glucose.createdTime);

    return Column(
      children: [
        Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.glucose.amount,
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
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
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
                      time,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  const SizedBox(height: 8,),
                  const Text(
                    'Before Meals',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}