import 'package:Videotheque/services/fireauth_queries.dart';
import 'package:Videotheque/services/fireconfig_queries.dart';
import 'package:Videotheque/services/firestore_queries.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/services/tmdb_queries.dart';
import 'package:Videotheque/utils/singletons.dart';
import 'package:Videotheque/utils/utils.dart';
import 'package:Videotheque/views/tv/episode_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Tv_controller.dart';

class SeasonController extends ChangeNotifier {
  BuildContext context;
  Map data;
  String heroTag;
  String tvId;
  String trailerKey;
  TvController tvController;
  
  List details;
  Map<ElementsTypes, List> carrouselData = Map.fromIterables(ElementsTypes.values, List.filled(ElementsTypes.values.length, null));

  Map<ElementsTypes, States> objectsStates = Map.fromIterables(ElementsTypes.values, List.generate(ElementsTypes.values.length, (index) => States.Nothing));

  FireauthQueries fireauth = Singletons.instance<FireauthQueries>();
  FirestoreQueries firestore = Singletons.instance<FirestoreQueries>();
  FireconfigQueries fireconfig = Singletons.instance<FireconfigQueries>();
  TMDBQueries tmdbQueries = Singletons.instance<TMDBQueries>();

  SeasonController(this.context, this.data, this.heroTag, this.tvId, this.tvController) {
    fetchDetails();
    fetchEpisodes();
    fetchCredits();
    fetchTrailers();
  }

  void fetchDetails() async {
    objectsStates[ElementsTypes.InfoTags] = States.Loading;
    details = [
      data["episode_count"] != null ? "${data["episode_count"]} épisodes" : null,
      data["air_date"] != null ? "Sortie le ${DateFormat('dd/MM/yyyy').format(DateTime.parse(data["air_date"]))}" : null,
    ];
    details.removeWhere((element) => element == null);
    objectsStates[ElementsTypes.InfoTags] = details.length > 0 ? States.Added : States.Empty;
  }
  
  void fetchEpisodes() async {
    objectsStates[ElementsTypes.EpisodesCarrousel] = States.Loading;
    notifyListeners();
    Map results = await tmdbQueries.getTvSeason(tvId, data["season_number"].toString());
    List episodes = List.from(results["episodes"]);
    for (Map episode in episodes) episode["poster_path"] = data["poster_path"]; 
    carrouselData[ElementsTypes.EpisodesCarrousel] = results["episodes"];
    objectsStates[ElementsTypes.EpisodesCarrousel] = results["episodes"].length > 0 ? States.Added : States.Empty;
    notifyListeners();
  }

  void fetchCredits() async {
    objectsStates[ElementsTypes.CastingCarrousel] = States.Loading;
    objectsStates[ElementsTypes.CrewCarrousel] = States.Loading;
    notifyListeners();
    Map results = await tmdbQueries.getTvSeasonCredits(tvId, data["season_number"].toString());
    carrouselData[ElementsTypes.CrewCarrousel] ??= results["crew"];
    carrouselData[ElementsTypes.CastingCarrousel] ??= results["cast"];
    objectsStates[ElementsTypes.CrewCarrousel] = ((results["crew"] as List)?.isNotEmpty ?? false) ? States.Added : States.Empty;
    objectsStates[ElementsTypes.CastingCarrousel] = ((results["cast"] as List)?.isNotEmpty ?? false) ? States.Added : States.Empty;
    notifyListeners();
  }

  void fetchTrailers() async {
    objectsStates[ElementsTypes.YoutubeTrailer] = States.Loading;
    notifyListeners();
    List results = (await tmdbQueries.getTvSeasonVideos(tvId, data["season_number"].toString()))["results"];

    for (Map trailer in results) {
      if (trailer["site"] == "YouTube") {
        trailerKey = trailer["key"];
        break;
      }
    }
    objectsStates[ElementsTypes.YoutubeTrailer] = trailerKey != null ? States.Added : States.Empty;
    notifyListeners();
  }

  bool dispElement(ElementsTypes element) {
    if (objectsStates[element] == States.Loading || objectsStates[element] == States.Added)
      return true;
    else return false;
  }

  void showEpisodeEl(int index, String heroTag) {
    var view = EpisodeView(carrouselData[ElementsTypes.EpisodesCarrousel][index], heroTag, tvId, data["season_number"].toString());
    showSnappingSheet(context, view);
  }

  bool get hasImg => data["poster_path"]?.toString()?.isNotEmpty ?? false;
}