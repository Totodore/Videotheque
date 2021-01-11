import 'package:Videotheque/api/FireauthQueries.dart';
import 'package:Videotheque/api/FireconfigQueries.dart';
import 'package:Videotheque/api/FirestoreQueries.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/api/TmdbQueries.dart';
import 'package:Videotheque/utils/Singletons.dart';
import 'package:Videotheque/views/tv_view/episode_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SeasonController extends ChangeNotifier {
  BuildContext context;
  Map data;
  String heroTag;
  String tvId;
  String trailerKey;
  
  List details;
  Map<ElementsTypes, List> carrouselData = Map.fromIterables(ElementsTypes.values, List.generate(ElementsTypes.values.length, (index) => []));

  Map<ElementsTypes, States> objectsStates = Map.fromIterables(ElementsTypes.values, List.generate(ElementsTypes.values.length, (index) => States.Nothing));

  FireauthQueries fireauth = Singletons.instance<FireauthQueries>();
  FirestoreQueries firestore = Singletons.instance<FirestoreQueries>();
  FireconfigQueries fireconfig = Singletons.instance<FireconfigQueries>();
  TMDBQueries tmdbQueries = Singletons.instance<TMDBQueries>();

  SeasonController(this.context, this.data, this.heroTag, this.tvId) {
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
    List crew = results["crew"];
    List cast = results["cast"];
    if (crew != null) {
      crew.removeWhere((el) => el["poster_path"] == null && el["profile_path"] == null);
      carrouselData[ElementsTypes.CrewCarrousel] = crew;
    }
    if (cast != null) {
      cast.removeWhere((el) => el["poster_path"] == null && el["profile_path"] == null);
      carrouselData[ElementsTypes.CastingCarrousel] = cast;
    }
    objectsStates[ElementsTypes.CrewCarrousel] = crew != null && crew.length > 0 ? States.Added : States.Empty;
    objectsStates[ElementsTypes.CastingCarrousel] = cast != null && cast.length > 0 ? States.Added : States.Empty;
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
    showModalBottomSheet(
      context: context,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      barrierColor: Colors.black.withAlpha(1),
      builder: (context) => EpisodeView(carrouselData[ElementsTypes.EpisodesCarrousel][index], heroTag, tvId, data["season_number"].toString()),
    );
  }
}