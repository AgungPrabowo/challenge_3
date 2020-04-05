import 'package:challenge_3/src/api/apiServices.dart';
import 'package:challenge_3/src/model/modelConfirmed.dart';
import 'package:challenge_3/src/model/modelCountries.dart';
import 'package:challenge_3/src/model/modelDeaths.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ChartsState {}

class NewsInitial extends ChartsState {}

class NewsLoading extends ChartsState {}

class DataInit extends ChartsState {
  List<String> countries;
  List<String> countryCode;
  List<ModelConfirmed> confirmed;
  List<ModelDeaths> deaths;
  DataInit(this.countries, this.countryCode, this.confirmed, this.deaths);

  DataInit copyWith(List<String> countries, List<String> countryCode,
          List<ModelConfirmed> confirmed, List<ModelDeaths> deaths) =>
      DataInit(countries, countryCode, confirmed, deaths);
}

abstract class ChartsEvent {}

class InitData extends ChartsEvent {
  final String idCountry;
  InitData({this.idCountry});
}

class ChartsBloc extends Bloc<ChartsEvent, ChartsState> {
  @override
  ChartsState get initialState => NewsInitial();

  @override
  Stream<ChartsState> mapEventToState(ChartsEvent event) async* {
    final ApiServices apiServices = ApiServices();
    if (event is InitData) {
      yield NewsLoading();
      List<ModelCountries> data = await apiServices.coronaCountries();
      List<ModelConfirmed> dataConfirmed =
          await apiServices.coronaConfirmed(event.idCountry);
      List<ModelDeaths> dataDeaths =
          await apiServices.coronaDeaths(event.idCountry);
      List<String> countries = data.map((f) => f.country).toSet().toList();
      List<String> countryCode =
          data.map((f) => f.countryCode).toSet().toList();
      yield DataInit(countries, countryCode, dataConfirmed, dataDeaths);
    }
  }
}
