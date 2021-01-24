import 'package:Videotheque/models/api/ApiSearchTvModel.dart';
import 'package:Videotheque/views/tv_view/tv_view.dart';
import 'package:flutter/material.dart';

class KnownForTvComponent extends StatelessWidget {

  final ApiSearchTvModel data;
  final Function onClick;
  final int index;

  KnownForTvComponent(this.data, this.onClick, this.index);

  @override
  Widget build(BuildContext context) => Theme(
    data: Theme.of(context).copyWith(splashColor: TvView.splashColor),
    child: ActionChip(
      avatar: CircleAvatar(
        child: Icon(Icons.movie, color: TvView.baseColor),
        backgroundColor: Colors.transparent,
      ),
      labelStyle: TextStyle(color: Colors.black),
      label: Text(data.name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      onPressed: () => onClick(index),
    ),
  );
}