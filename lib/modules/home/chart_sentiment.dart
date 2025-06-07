import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SentimentChartCard extends StatelessWidget {
  final int positive;
  final int neutral;
  final int negative;

  const SentimentChartCard({Key? key, required this.positive, required this.neutral, required this.negative})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final total = positive + neutral + negative;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child:
            total == 0
                ? const Center(child: Text('Belum ada data sentimen'))
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Analisis Sentimen Feedback',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              titleStyle: TextStyle(color: Colors.white),
                              value: positive.toDouble(),
                              color: Colors.green,
                              title: '${((positive / total) * 100).toStringAsFixed(1)}%',
                              radius: 50,
                            ),
                            PieChartSectionData(
                              titleStyle: TextStyle(color: Colors.white),
                              value: neutral.toDouble(),
                              color: Colors.grey,
                              title: '${((neutral / total) * 100).toStringAsFixed(1)}%',
                              radius: 50,
                            ),
                            PieChartSectionData(
                              titleStyle: TextStyle(color: Colors.white),
                              value: negative.toDouble(),
                              color: Colors.red,
                              title: '${((negative / total) * 100).toStringAsFixed(1)}%',
                              radius: 50,
                            ),
                          ],
                          sectionsSpace: 2,
                          centerSpaceRadius: 30,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        _SentimentLegend(color: Colors.green, label: 'Positif'),
                        _SentimentLegend(color: Colors.grey, label: 'Netral'),
                        _SentimentLegend(color: Colors.red, label: 'Negatif'),
                      ],
                    ),
                  ],
                ),
      ),
    );
  }
}

class _SentimentLegend extends StatelessWidget {
  final Color color;
  final String label;

  const _SentimentLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
          margin: const EdgeInsets.only(right: 6),
        ),
        Text(label),
      ],
    );
  }
}
