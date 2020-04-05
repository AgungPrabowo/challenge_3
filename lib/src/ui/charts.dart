import 'dart:io';
import 'package:challenge_3/src/bloc/bloc_charts.dart';
import 'package:challenge_3/src/charts/lineCharts.dart';
import 'package:challenge_3/src/helper/helper.dart';
import 'package:challenge_3/src/model/modelSummary.dart';
import 'package:flag/flag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/cupertino_flutter_typeahead.dart';

class ReportChartUI extends StatefulWidget {
  @override
  _ReportChartUIState createState() => _ReportChartUIState();
}

class _ReportChartUIState extends State<ReportChartUI> {
  Widget listTile(Countries country) {
    return ListTile(
      isThreeLine: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        child: Flags.getMiniFlag(country.countryCode, 60, 60),
      ),
      title: Text(
        country.country,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      subtitle: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                "Confirmed Cases",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(" : ${country.totalConfirmed}   "),
              Container(
                child: Text(" +${country.newConfirmed}"),
                color: Colors.grey[200],
              )
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                "Recovered Cases",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                child: Text(" : ${country.totalRecovered}   "),
              ),
              Container(
                child: Text(" +${country.newRecovered}"),
                color: Colors.grey[200],
              )
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                "Deaths Cases",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(" : ${country.totalDeaths}   "),
              Container(
                child: Text(" +${country.newDeaths}"),
                color: Colors.grey[200],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("COVID-19 Charts"),
      ),
      body: BlocProvider<ChartsBloc>(
        child: BlocBuilder<ChartsBloc, ChartsState>(builder: (context, state) {
          if (state is DataInit) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  buildWidgetSearch(),
                  Container(
                    padding: EdgeInsets.only(left: 5),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      state.country.date.substring(0, 10),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        child: listTile(state.country)),
                  ),
                  Container(
                    child: ChartsUI.withSampleData(
                      dataConfirmed: state.confirmed,
                      dataDeaths: state.deaths,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Platform.isAndroid
                  ? CircularProgressIndicator()
                  : CupertinoActivityIndicator(),
            );
          }
        }),
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
        if (state is DataInit) {
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
          return Container();
        }
      },
    );
  }
}
