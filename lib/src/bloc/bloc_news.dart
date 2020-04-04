import 'package:challenge_3/src/api/apiServices.dart';
import 'package:challenge_3/src/model/modelCountries.dart';
import 'package:challenge_3/src/model/modelNews.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class DataInit extends NewsState {
  List<String> countries;
  List<String> countryCode;
  ModelNews news;
  DataInit(this.countries, this.news, this.countryCode);

  DataInit copyWith(
          List<String> countries, ModelNews news, List<String> countryCode) =>
      DataInit(countries, news, countryCode);
}

class DataNews extends NewsState {
  ModelNews news;
  DataNews(this.news);

  DataNews copyWith(ModelNews news) => DataNews(news);
}

abstract class NewsEvent {}

class InitData extends NewsEvent {
  final String idCountry;
  InitData({this.idCountry});
}

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  @override
  NewsState get initialState => NewsInitial();

  @override
  Stream<NewsState> mapEventToState(NewsEvent event) async* {
    final ApiServices apiServices = ApiServices();
    if (event is InitData) {
      yield NewsLoading();
      List<ModelCountries> data = await apiServices.coronaCountries();
      ModelNews news = await apiServices.coronaNews(event.idCountry);
      List<String> countries = data.map((f) => f.country).toSet().toList();
      List<String> countryCode =
          data.map((f) => f.countryCode).toSet().toList();
      yield DataInit(countries, news, countryCode);
    }
  }
}
