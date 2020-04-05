import 'dart:io';
import 'package:challenge_3/src/bloc/bloc_charts.dart';
import 'package:challenge_3/src/charts/lineCharts.dart';
import 'package:challenge_3/src/helper/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/cupertino_flutter_typeahead.dart';

class ReportChartUI extends StatefulWidget {
  @override
  _ReportChartUIState createState() => _ReportChartUIState();
}

class _ReportChartUIState extends State<ReportChartUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("COVID-19 Charts"),
      ),
      body: BlocProvider<ChartsBloc>(
        child: Column(
          children: <Widget>[
            buildWidgetSearch(),
            Container(
              height: 300,
              child: BlocBuilder<ChartsBloc, ChartsState>(
                  builder: (context, state) {
                if (state is DataInit) {
                  return ChartsUI.withSampleData(
                    dataConfirmed: state.confirmed,
                    dataDeaths: state.deaths,
                  );
                } else {
                  return Center(
                    child: Platform.isAndroid
                        ? CircularProgressIndicator()
                        : CupertinoActivityIndicator(),
                  );
                }
              }),
            ),
          ],
        ),
        create: (BuildContext context) =>
            ChartsBloc()..add(InitData(idCountry: "ID")),
      ),
      drawer: Helper().drawer(context),
    );
  }

  Widget buildWidgetSearch() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: EdgeInsets.only(
          left: 12.0,
          top: 8.0,
          right: 12.0,
          bottom: 8.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          color: Colors.white,
        ),
        child: Row(
          children: <Widget>[
            Expanded(child: SearchCountries()),
            Icon(
              Icons.search,
              size: 16.0,
              color: Colors.black26,
            ),
          ],
        ),
      ),
    );
  }
}

class SearchCountries extends StatefulWidget {
  @override
  _SearchCountries createState() => _SearchCountries();
}

class _SearchCountries extends State<SearchCountries> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  CupertinoSuggestionsBoxController _suggestionsBoxController =
      CupertinoSuggestionsBoxController();
  ChartsBloc chartsBloc;

  List<String> getSuggestions(String query, List<String> countries) {
    List<String> matches = List();
    matches.addAll(countries);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartsBloc, ChartsState>(
      builder: (context, state) {
        chartsBloc = BlocProvider.of<ChartsBloc>(context);
        if (state is NewsLoading) {
          return Center(
            child: Platform.isAndroid
                ? CircularProgressIndicator()
                : CupertinoActivityIndicator(),
          );
        } else if (state is DataInit) {
          return Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(5),
              child: Column(
                children: <Widget>[
                  CupertinoTypeAheadFormField(
                    getImmediateSuggestions: true,
                    suggestionsBoxController: _suggestionsBoxController,
                    textFieldConfiguration: CupertinoTextFieldConfiguration(
                        controller: _typeAheadController,
                        placeholder: "Search Country"),
                    suggestionsCallback: (pattern) {
                      return Future.delayed(
                        Duration(seconds: 1),
                        () => getSuggestions(pattern, state.countries),
                      );
                    },
                    itemBuilder: (BuildContext context, String suggestion) {
                      return Material(
                        child: Container(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            suggestion,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    },
                    onSuggestionSelected: (String suggestion) {
                      chartsBloc
                        ..add(InitData(
                            idCountry: state.countryCode[
                                state.countries.indexOf(suggestion)]));
                      _typeAheadController.text = suggestion;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please select a city';
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container(
            child: Text("data"),
          );
        }
      },
    );
  }
}
