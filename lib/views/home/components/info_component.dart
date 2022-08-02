import 'package:Videotheque/models/fireconfig_infos.dart';
import 'package:flutter/material.dart';

import '../../../globals.dart';

class InfoComponent extends StatelessWidget {
  final FireconfigInfos data;
  final Function onDismiss;

  InfoComponent(this.data, this.onDismiss); 

  @override
  Widget build(BuildContext context) {
    final widget = Card(
      color: GlobalsColor.green,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
        child: Column(children: [
          Text(data.content ?? "",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15.5,
              color: Colors.white
            ),
            textAlign: TextAlign.justify,
          ),
          data.link != null && data.link_content != null ? ButtonBar(
            alignment: MainAxisAlignment.end,
            children: [
              RaisedButton(
                padding: EdgeInsets.symmetric(horizontal: 10),
                color: Colors.white,
                child: Text(this.data.link_content),
                elevation: 2,
                highlightElevation: 3,
                onPressed: () => onDismiss(data, true)
              )
            ],
          ) : Padding(padding: EdgeInsets.only(bottom: 10),)
        ]),
      ),
    );
    return data.dismissible != null && data.dismissible ? Dismissible(
      key: GlobalKey(),
      onDismissed: (_) => onDismiss(data), 
      child: widget
    ) : widget;
  }
}