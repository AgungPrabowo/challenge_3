import 'dart:io';
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
        if (state is NewsLoading) {
          return Center(
            child: Platform.isAndroid
                ? CircularProgressIndicator()
                : CupertinoActivityIndicator(),
          );
        } else if (state is DataInit) {
          return charts.TimeSeriesChart(
            seriesList,
            animate: animate,
            defaultRenderer: charts.LineRendererConfig(),
            customSeriesRenderers: [
              charts.PointRendererConfig(customRendererId: 'customPoint')
            ],
            dateTimeFactory: const charts.LocalDateTimeFactory(),
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
        id: 'Desktop',
        colorFn: (_, __) => charts.MaterialPalette.gray.shadeDefault,
        domainFn: (TimeSeriesSpread sales, _) => sales.time,
        measureFn: (TimeSeriesSpread sales, _) => sales.sales,
        data: deathsData,
      ),
      charts.Series<TimeSeriesSpread, DateTime>(
        id: 'Tablet',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (TimeSeriesSpread sales, _) => sales.time,
        measureFn: (TimeSeriesSpread sales, _) => sales.sales,
        data: confirmedData,
      ),
      charts.Series<TimeSeriesSpread, DateTime>(
          id: 'Mobile',
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
