import 'dart:async';

/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  return runApp(_ChartApp());
}

class _ChartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          ThemeData(brightness: Brightness.light, primarySwatch: Colors.blue),
      home: Scrolling(),
    );
  }
}

/// Renders the chart with default trackball sample.
class Scrolling extends StatefulWidget {
  /// Creates the chart with default trackball sample.
  const Scrolling();

  @override
  _ScrollingState createState() => _ScrollingState();
}

/// State class the chart with default trackball.
class _ScrollingState extends State<Scrolling> {
  _ScrollingState();

  late List<OrdinalData> chartData;

  double axisVisibleMin = 1, axisVisibleMax = 5;

  late SelectionBehavior selectionBehavior;

  int? selectedPointIndex;

  bool isLoad = false;

  @override
  void initState() {
    _initializeVariables();
    selectionBehavior = SelectionBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
            child: Container(
                height: 500,
                width: 320,
                child: _buildInfiniteScrollingChart())));
  }

  void _initializeVariables() {
    chartData = <OrdinalData>[
      OrdinalData(0, 5),
      OrdinalData(1, 25),
      OrdinalData(2, 100),
      OrdinalData(3, 75),
      OrdinalData(4, 33),
      OrdinalData(5, 80),
      OrdinalData(6, 21),
      OrdinalData(7, 77),
      OrdinalData(8, 8),
      OrdinalData(9, 12),
      OrdinalData(10, 42),
      OrdinalData(11, 70),
      OrdinalData(12, 77),
      OrdinalData(13, 55),
      OrdinalData(14, 19),
      OrdinalData(15, 66),
      OrdinalData(16, 27),
    ];
  }

  /// Returns the cartesian chart with default trackball.
  SfCartesianChart _buildInfiniteScrollingChart() {
    return SfCartesianChart(
      onSelectionChanged: (args) {
        print(args.viewportPointIndex);
        if (!isLoad) {
          selectedPointIndex = args.viewportPointIndex;
        } else {
          selectedPointIndex = args.pointIndex;
        }

        setState(() {
          axisVisibleMin = selectedPointIndex! - 2.toDouble();
          axisVisibleMax = selectedPointIndex! + 2.toDouble();
        });
      },
      backgroundColor: Colors.white,
      plotAreaBorderWidth: 0,
      primaryXAxis: NumericAxis(
          visibleMinimum: axisVisibleMin,
          visibleMaximum: axisVisibleMax,
          interval: 2,
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          majorGridLines: MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(color: Colors.transparent)),
      series: getSeries(),
      onPlotAreaSwipe: (ChartSwipeDirection direction) =>
          performSwipe(direction),
    );
  }

  List<ChartSeries<OrdinalData, num>> getSeries() {
    return <ChartSeries<OrdinalData, num>>[
      ColumnSeries<OrdinalData, num>(
        dataSource: chartData,
        selectionBehavior: selectionBehavior,
        xValueMapper: (OrdinalData sales, _) => sales.x,
        yValueMapper: (OrdinalData sales, _) => sales.y,
      ),
    ];
  }

  void performSwipe(ChartSwipeDirection direction) {
    if (direction == ChartSwipeDirection.end &&
        (axisVisibleMax + 5.toDouble()) < chartData.length) {
      isLoad = true;
      setState(() {
        axisVisibleMin = axisVisibleMin + 5.toDouble();
        axisVisibleMax = axisVisibleMax + 5.toDouble();
      });
      Future.delayed(const Duration(milliseconds: 1000), () {
        selectionBehavior.selectDataPoints((axisVisibleMin.toInt()) + 2);
      });
    } else if (direction == ChartSwipeDirection.start &&
        (axisVisibleMin - 5.toDouble()) >= 0) {
      setState(() {
        axisVisibleMin = axisVisibleMin - 5.toDouble();
        axisVisibleMax = axisVisibleMax - 5.toDouble();
        Future.delayed(const Duration(milliseconds: 1000), () {
          selectionBehavior.selectDataPoints((axisVisibleMin.toInt()) + 2);
        });
      });
    }
  }
}

class OrdinalData {
  final double x;
  final int y;

  OrdinalData(this.x, this.y);
}
