import 'package:challenge_3/src/bloc/bloc_charts.dart';
import 'package:challenge_3/src/model/modelConfirmed.dart';
import 'package:challenge_3/src/model/modelDeaths.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_bloc/flutter_bloc.dart';

class ChartsUI extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  ChartsUI(this.seriesList, {this.animate});

  factory ChartsUI.withSampleData(
      {List<ModelConfirmed> dataConfirmed, List<ModelDeaths> dataDeaths}) {
    return ChartsUI(
      _createSampleData(dataConfirmed, dataDeaths),
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartsBloc, ChartsState>(
      builder: (context, state) {
        if (state is DataInit) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10, left: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Spread over time",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 300,
                  padding: EdgeInsets.all(10),
                  child: charts.TimeSeriesChart(
                    seriesList,
                    animate: animate,
                    defaultRenderer: charts.LineRendererConfig(),
                    customSeriesRenderers: [
                      charts.PointRendererConfig(
                          customRendererId: 'customPoint')
                    ],
                    dateTimeFactory: const charts.LocalDateTimeFactory(),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, bottom: 10),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(right: 5),
                        child: Icon(Icons.remove, color: Colors.red),
                      ),
                      Container(
                          padding: EdgeInsets.only(right: 5),
                          child: Text("Confirmed")),
                      Container(
                        padding: EdgeInsets.only(right: 5),
                        child: Icon(Icons.remove, color: Colors.grey),
                      ),
                      Text("Deaths")
                    ],
                  ),
                )
              ],
            ),
          );
        } else {
          return Container(
            child: Center(
              child: Text("data not available"),
            ),
          );
        }
      },
    );
  }

  static List<charts.Series<TimeSeriesSpread, DateTime>> _createSampleData(
      List<ModelConfirmed> dataConfirmed, List<ModelDeaths> dataDeaths) {
    List<TimeSeriesSpread> deathsData = dataDeaths
        .map((f) => TimeSeriesSpread(DateTime.parse(f.date), f.cases))
        .toList();

    List<TimeSeriesSpread> confirmedData = dataConfirmed
        .map((f) => TimeSeriesSpread(DateTime.parse(f.date), f.cases))
        .toList();

    List<TimeSeriesSpread> pointData = dataConfirmed
        .map((f) => TimeSeriesSpread(DateTime.parse(f.date), f.cases))
        .toList();

    return [
      charts.Series<TimeSeriesSpread, DateTime>(
        id: 'Deaths',
        colorFn: (_, __) => charts.MaterialPalette.gray.shadeDefault,
        domainFn: (TimeSeriesSpread sales, _) => sales.time,
        measureFn: (TimeSeriesSpread sales, _) => sales.sales,
        data: deathsData,
      ),
      charts.Series<TimeSeriesSpread, DateTime>(
        id: 'Confirmed',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (TimeSeriesSpread sales, _) => sales.time,
        measureFn: (TimeSeriesSpread sales, _) => sales.sales,
        data: confirmedData,
      ),
      charts.Series<TimeSeriesSpread, DateTime>(
          id: 'Point',
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (TimeSeriesSpread sales, _) => sales.time,
          measureFn: (TimeSeriesSpread sales, _) => sales.sales,
          data: pointData)
        ..setAttribute(charts.rendererIdKey, 'customPoint'),
    ];
  }
}

class TimeSeriesSpread {
  final DateTime time;
  final int sales;

  TimeSeriesSpread(this.time, this.sales);
}
