import 'package:Videotheque/services/FireauthQueries.dart';
import 'package:Videotheque/services/FireconfigQueries.dart';
import 'package:Videotheque/services/FirestoreQueries.dart';
import 'package:Videotheque/Globals.dart';
import 'package:Videotheque/services/TmdbQueries.dart';
import 'package:Videotheque/utils/Singletons.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class EpisodeController extends ChangeNotifier {
  BuildContext context;
  Map data; 
  String heroTag;
  String tvId;
  String seasonNumber;
  String trailerKey;
  
  List details = [];
  Map<ElementsTypes, List> carrouselData = Map.fromIterables(ElementsTypes.values, List.generate(ElementsTypes.values.length, (index) => []));

  Map<ElementsTypes, States> objectsStates = Map.fromIterables(ElementsTypes.values, List.generate(ElementsTypes.values.length, (index) => States.Nothing));

  EpisodeController(this.context, this.data, this.heroTag, this.tvId, this.seasonNumber) {
    fetchDetails();
    fetchCredits();
    fetchTrailers();
  }

  FireauthQueries fireauth = Singletons.instance<FireauthQueries>();
  FirestoreQueries firestore = Singletons.instance<FirestoreQueries>();
  FireconfigQueries fireconfig = Singletons.instance<FireconfigQueries>();
  TMDBQueries tmdbQueries = Singletons.instance<TMDBQueries>();

  void fetchDetails() {
    objectsStates[ElementsTypes.InfoTags] = States.Loading;
    details = [
      data["vote_average"] != null && data["vote_average"] > 0 ? "${data["vote_average"]} ★" : null,
      data["air_date"] != null ? "Sortie le ${DateFormat('dd/MM/yyyy').format(DateTime.parse(data["air_date"]))}" : null,
    ];
    details.removeWhere((element) => element == null);
    objectsStates[ElementsTypes.InfoTags] = details.length > 0 ? States.Added : States.Empty;
  }

  void fetchCredits() async {
    objectsStates[ElementsTypes.CastingCarrousel] = States.Loading;
    objectsStates[ElementsTypes.CrewCarrousel] = States.Loading;
    notifyListeners();
    Map results = await tmdbQueries.getTvEpisodesCredits(tvId, seasonNumber, data["episode_number"].toString());
    List crew = results["crew"];
    List cast = results["cast"];
    List guests = results["guest_stars"];
    if (crew != null) {
      crew.removeWhere((el) => el["poster_path"] == null && el["profile_path"] == null);
      carrouselData[ElementsTypes.CrewCarrousel] = crew;
    }
    if (cast != null) {
      cast.removeWhere((el) => el["poster_path"] == null && el["profile_path"] == null);
      carrouselData[ElementsTypes.CastingCarrousel] = cast;
    }
    if (guests != null) {
      guests.removeWhere((el) => el["poster_path"] == null && el["profile_path"] == null);
      carrouselData[ElementsTypes.GuestsCarrousel] = guests;
    }
    objectsStates[ElementsTypes.CrewCarrousel] = crew != null && crew.length > 0 ? States.Added : States.Empty;
    objectsStates[ElementsTypes.CastingCarrousel] = cast != null && cast.length > 0 ? States.Added : States.Empty;
    objectsStates[ElementsTypes.GuestsCarrousel] = guests != null && guests.length > 0 ? States.Added : States.Empty;
    notifyListeners();
  }

  void fetchTrailers() async {
    objectsStates[ElementsTypes.YoutubeTrailer] = States.Loading;
    notifyListeners();
    List results = (await tmdbQueries.getTvEpisodesVideos(tvId, seasonNumber, data["episode_number"].toString()))["results"];
    
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
}