class ModelNews {
  Location location;
  String updatedDateTime;
  List<News> news;

  ModelNews({this.location, this.updatedDateTime, this.news});

  ModelNews.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    updatedDateTime = json['updatedDateTime'];
    if (json['news'] != null) {
      news = List<News>();
      json['news'].forEach((v) {
        news.add(News.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    data['updatedDateTime'] = this.updatedDateTime;
    if (this.news != null) {
      data['news'] = this.news.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Location {
  double long;
  String countryOrRegion;
  Null provinceOrState;
  Null county;
  String isoCode;
  double lat;

  Location(
      {this.long,
      this.countryOrRegion,
      this.provinceOrState,
      this.county,
      this.isoCode,
      this.lat});

  Location.fromJson(Map<String, dynamic> json) {
    long = json['long'];
    countryOrRegion = json['countryOrRegion'];
    provinceOrState = json['provinceOrState'];
    county = json['county'];
    isoCode = json['isoCode'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['long'] = this.long;
    data['countryOrRegion'] = this.countryOrRegion;
    data['provinceOrState'] = this.provinceOrState;
    data['county'] = this.county;
    data['isoCode'] = this.isoCode;
    data['lat'] = this.lat;
    return data;
  }
}

class News {
  String path;
  String title;
  String excerpt;
  int heat;
  List<String> tags;
  String type;
  String webUrl;
  String ampWebUrl;
  String cdnAmpWebUrl;
  String publishedDateTime;
  Null updatedDateTime;
  Provider provider;
  List<Images> images;
  String locale;
  List<String> categories;
  List<String> topics;

  News(
      {this.path,
      this.title,
      this.excerpt,
      this.heat,
      this.tags,
      this.type,
      this.webUrl,
      this.ampWebUrl,
      this.cdnAmpWebUrl,
      this.publishedDateTime,
      this.updatedDateTime,
      this.provider,
      this.images,
      this.locale,
      this.categories,
      this.topics});

  News.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    title = json['title'];
    excerpt = json['excerpt'];
    heat = json['heat'];
    tags = json['tags'].cast<String>();
    type = json['type'];
    webUrl = json['webUrl'];
    ampWebUrl = json['ampWebUrl'];
    cdnAmpWebUrl = json['cdnAmpWebUrl'];
    publishedDateTime = json['publishedDateTime'];
    updatedDateTime = json['updatedDateTime'];
    provider =
        json['provider'] != null ? Provider.fromJson(json['provider']) : null;
    if (json['images'] != null) {
      images = List<Images>();
      json['images'].forEach((v) {
        images.add(Images.fromJson(v));
      });
    }
    locale = json['locale'];
    categories = json['categories'].cast<String>();
    topics = json['topics'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['path'] = this.path;
    data['title'] = this.title;
    data['excerpt'] = this.excerpt;
    data['heat'] = this.heat;
    data['tags'] = this.tags;
    data['type'] = this.type;
    data['webUrl'] = this.webUrl;
    data['ampWebUrl'] = this.ampWebUrl;
    data['cdnAmpWebUrl'] = this.cdnAmpWebUrl;
    data['publishedDateTime'] = this.publishedDateTime;
    data['updatedDateTime'] = this.updatedDateTime;
    if (this.provider != null) {
      data['provider'] = this.provider.toJson();
    }
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    data['locale'] = this.locale;
    data['categories'] = this.categories;
    data['topics'] = this.topics;
    return data;
  }
}

class Provider {
  String name;
  String domain;
  Null images;
  Null publishers;
  Null authors;

  Provider(
      {this.name, this.domain, this.images, this.publishers, this.authors});

  Provider.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    domain = json['domain'];
    images = json['images'];
    publishers = json['publishers'];
    authors = json['authors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['domain'] = this.domain;
    data['images'] = this.images;
    data['publishers'] = this.publishers;
    data['authors'] = this.authors;
    return data;
  }
}

class Images {
  String url;
  int width;
  int height;
  String title;
  Null attribution;

  Images({this.url, this.width, this.height, this.title, this.attribution});

  Images.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    width = json['width'];
    height = json['height'];
    title = json['title'];
    attribution = json['attribution'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['url'] = this.url;
    data['width'] = this.width;
    data['height'] = this.height;
    data['title'] = this.title;
    data['attribution'] = this.attribution;
    return data;
  }
}
