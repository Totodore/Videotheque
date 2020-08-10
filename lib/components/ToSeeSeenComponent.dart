import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ToSeeSeenComponent extends StatelessWidget {
  final Function _toSeeTap;
  final Function _seenTap;
  final bool _isToSee;
  final bool _isSeen;
  final Color _baseColor;
  final String _toSeeStr;
  final String _seenStr;

  ToSeeSeenComponent(this._toSeeTap, this._seenTap, this._isToSee, this._isSeen, this._baseColor, this._toSeeStr, this._seenStr);

  @override
  Widget build(BuildContext context) => ButtonBar(
    buttonAlignedDropdown: true,
    alignment: MainAxisAlignment.spaceEvenly,
    mainAxisSize: MainAxisSize.max,
    layoutBehavior: ButtonBarLayoutBehavior.padded,
    children: <Widget>[
      RaisedButton.icon(
        label: Text(_toSeeStr),
        icon: Icon(_isToSee ? CommunityMaterialIcons.eye_check_outline : CommunityMaterialIcons.eye_plus_outline, 
          color: _isToSee ? Colors.white : _baseColor),
        color: _isToSee ? _baseColor : Colors.white.withOpacity(0.9),
        textColor: _isToSee ? Colors.white : _baseColor,
        onPressed: _toSeeTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: _baseColor, width: 1.2),
        ),
        highlightElevation: 3,
        splashColor: _isToSee ? Colors.white.withAlpha(100) : _baseColor.withAlpha(100),
      ),
      RaisedButton.icon(
        label: Text(_seenStr),
        icon: Icon(_isSeen ? CommunityMaterialIcons.eye_check : CommunityMaterialIcons.eye_plus, 
          color: _isSeen ? Colors.white : _baseColor),
        textColor: _isSeen ? Colors.white : _baseColor,
        color: _isSeen ? _baseColor : Colors.white.withOpacity(0.9),
        onPressed: _seenTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: _baseColor, width: 1.2),
        ),
        highlightElevation: 3,
        splashColor: _isSeen ? Colors.white.withAlpha(100) : _baseColor.withAlpha(100),
      ),
    ],
  );
}