import 'package:Videotheque/models/api/api_search_tv_model.dart';
import 'package:Videotheque/views/tv/tv_view.dart';
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
        child: Icon(Icons.tv, color: TvView.baseColor),
        backgroundColor: Colors.transparent,
      ),
      labelStyle: TextStyle(color: Colors.black),
      label: Text(data.name ?? data.original_name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      onPressed: () => onClick("tv", data),
    ),
  );
}