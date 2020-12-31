import 'package:Ahteeg/helpers/axis_themes.dart';
import 'package:Ahteeg/models/timed_output.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Visualizer extends StatelessWidget {
  final List<TimedOutput> results;
  final String timeChartTitle;
  final String scoreChartTitle;
  final List<Color> colors;

  const Visualizer({Key key, @required this.results, this.timeChartTitle, this.scoreChartTitle, this.colors}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<charts.Series<TimedOutput, String>> timeSeries = timeChartTitle != null ? [
      charts.Series(
        id: "Time",
        data: results,
        domainFn: (TimedOutput output, _) => output.title,
        measureFn: (TimedOutput output, _) => output.duration,
        colorFn: (_, i) => colors != null ? charts.ColorUtil.fromDartColor(colors[i]) : null,
      ),
    ] : null;
    
    List<charts.Series<TimedOutput, String>> scoreSeries = scoreChartTitle != null ? [
      charts.Series(
        id: "Score",
        data: results,
        domainFn: (TimedOutput output, _) => output.title,
        measureFn: (TimedOutput output, _) => output.score,
        colorFn: (_, i) => colors != null ? charts.ColorUtil.fromDartColor(colors[i]) : null,
      ),
    ] : null;


    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        if(timeSeries != null) // indicator to whether visualize results or not 
          Container(
            height: 400,
            child: Card(
              elevation: 0.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(timeChartTitle, style: Theme.of(context).textTheme.bodyText1),
                    Expanded(
                      child: charts.BarChart(
                        timeSeries, 
                        animate: true, 
                        domainAxis: AxisTheme.domainSpec(),
                        primaryMeasureAxis: AxisTheme.numericAxisSpec(),
                      )
                    )
                  ],
                ),
              ),
            ),
          ),
        if(scoreSeries != null) // indicator to whether visualize results or not 
          Container(
            height: 400,
            child: Card(
              elevation: 0.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(scoreChartTitle, style: Theme.of(context).textTheme.bodyText1),
                    Expanded(
                      child: charts.BarChart(
                        scoreSeries, 
                        animate: true, 
                        domainAxis: AxisTheme.domainSpec(),
                        primaryMeasureAxis: AxisTheme.numericAxisSpec(),
                      )
                    )
                  ],
                ),
              ),
            ),
          ),
        ...List.generate(results.length, (i) => ListTile(title: Text(results[i].title), subtitle: Text(results[i].output), onLongPress: () { Clipboard.setData(ClipboardData(text: results[i].output)); })),
      ]
    );
  }
}