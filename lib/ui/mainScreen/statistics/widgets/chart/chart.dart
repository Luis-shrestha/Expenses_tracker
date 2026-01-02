import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CustomChart extends StatelessWidget {
  final List<Map<String, dynamic>> chartData;

  // Constructor accepts dynamic income data
  const CustomChart({Key? key, required this.chartData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(
            height: 250,
            child: PieChart(
              PieChartData(
                sections: getSections(),
                centerSpaceRadius: 50,
                sectionsSpace: 1,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: chartData.map((data) {
              return buildLegend(
                data['title'] as String,
                data['color'] as Color,
                data['percentage'] as double,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> getSections() {
    return chartData.map((data) {
      double percentage = data['percentage'] as double;
      return PieChartSectionData(
        color: data['color'] as Color,
        value: percentage, // Ensure percentage is treated as a double
        title: '${percentage.toStringAsFixed(2)}%', // Format the percentage to 2 decimal places
        radius: 50 + percentage / 5, // Radius is still based on the percentage
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }


  Widget buildLegend(String title, Color color, double percentage) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(
          '$title: ${percentage.toStringAsFixed(2)}%', // Limit to 2 decimal places
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

}
