import 'package:expense_tracker/configs/palette.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlySpendingChart extends StatelessWidget {
  final List<double> weeklyExpenses; // 4 weeks

  const MonthlySpendingChart({
    super.key,
    required this.weeklyExpenses,
  });

  @override
  Widget build(BuildContext context) {
    final double maxYValue = (weeklyExpenses.isEmpty)
        ? 10
        : (weeklyExpenses.reduce((a, b) => a > b ? a : b)) + 50;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxYValue,
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        gridData: const FlGridData(show: false),
        barGroups: _buildBarGroups(),
      ),
      duration: const Duration(milliseconds: 350),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
    enabled: false,
    touchTooltipData: BarTouchTooltipData(
      getTooltipColor: (group) => Colors.transparent,
      tooltipPadding: EdgeInsets.zero,
      tooltipMargin: 8,
      getTooltipItem: (group, groupIndex, rod, rodIndex) {
        return BarTooltipItem(
          rod.toY.round().toString(),
          TextStyle(
            color: Palette.secondaryColor,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    ),
  );

  Widget getTitles(double value, TitleMeta meta) {
    const weeks = ["Week 1", "Week 2", "Week 3", "Week 4"];
    final style = TextStyle(
      color: Colors.blue.shade700,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Text(
        weeks[value.toInt()],
        style: style,
      ),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: getTitles,
      ),
    ),
    leftTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
  );

  FlBorderData get borderData => FlBorderData(show: false);

  LinearGradient get _barsGradient => LinearGradient(
    colors: [
      Colors.blue.shade700,
      Colors.cyan,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(4, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: weeklyExpenses[index],
            gradient: _barsGradient,
            width: 18,
            borderRadius: BorderRadius.circular(8),
          )
        ],
        showingTooltipIndicators: [0],
      );
    });
  }
}
