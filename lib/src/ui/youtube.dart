import 'package:challenge_3/src/api/apiServices.dart';
import 'package:challenge_3/src/helper/helper.dart';
import 'package:challenge_3/src/model/modelYoutube.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeUI extends StatefulWidget {
  @override
  _YoutubeUIState createState() => _YoutubeUIState();
}

class _YoutubeUIState extends State<YoutubeUI> {
  ApiServices _apiServices = ApiServices();
  Future<ModelYoutube> _youtube;

  @override
  void initState() {
    _youtube = _apiServices.coronaYoutube("10");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("COVID-19 Youtube WHO"),
      ),
      body: FutureBuilder(
        future: _youtube,
        builder: (BuildContext context, AsyncSnapshot<ModelYoutube> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('Tidak ada Event');
            case ConnectionState.active:
              return Text('');
            case ConnectionState.waiting:
              return Container(
                  height: 200.0,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  alignment: Alignment.bottomCenter,
                  child: Center(child: CircularProgressIndicator()));
            case ConnectionState.done:
              final List<YoutubePlayerController> _controllers =
                  snapshot.data.items
                      .map<YoutubePlayerController>(
                        (data) => YoutubePlayerController(
                          initialVideoId: data.id.videoId,
                          flags: YoutubePlayerFlags(
                            autoPlay: false,
                          ),
                        ),
                      )
                      .toList();
              return ListView.builder(
                itemCount: snapshot.data.items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              child: YoutubePlayer(
                                key: ObjectKey(_controllers[index]),
                                controller: _controllers[index],
                                actionsPadding: EdgeInsets.only(left: 16.0),
                                bottomActions: [
                                  CurrentPosition(),
                                  SizedBox(width: 10.0),
                                  ProgressBar(isExpanded: true),
                                  SizedBox(width: 10.0),
                                  RemainingDuration(),
                                  FullScreenButton(),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              right: 15,
                              child: Container(
                                width: 300,
                                color: Colors.black54,
                                padding: EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 20,
                                ),
                                child: Text(
                                  snapshot.data.items[index].snippet.title,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            default:
              return Container(
                child: Center(
                  child: Text("Data not availabe"),
                ),
              );
          }
        },
      ),
      drawer: Helper().drawer(context),
    );
  }
}
