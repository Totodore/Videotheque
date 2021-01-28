import 'package:Videotheque/Globals.dart';
import 'package:Videotheque/models/api/ApiSearchMovieModel.dart';
import 'package:flutter/material.dart';

class KnownForMovieComponent extends StatelessWidget {

  final ApiSearchMovieModel data;
  final Function onClick;
  final int index;
  KnownForMovieComponent(this.data, this.onClick, this.index);

  @override
  Widget build(BuildContext context) => Theme(
    data: Theme.of(context).copyWith(splashColor: GlobalsColor.darkGreenDisabled),
    child: ActionChip(
      avatar: CircleAvatar(
        child: Icon(Icons.movie, color: GlobalsColor.darkGreen),
        backgroundColor: Colors.transparent,
      ),
      labelStyle: TextStyle(color: Colors.black),
      label: Text(data.title ?? data.original_title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      onPressed: () => onClick("movie", data),
    ),
  );
}