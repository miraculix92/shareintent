import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:shareintent/shareintent.dart';
import '../models/link_model.dart';

class LinkProvider {

  final _shareIntent = ShareIntent();
  StreamSubscription<String> _shareIntentSubscription;

  Future<LinkModel> getLink() async {
    LinkModel linkModel = LinkModel();

    _shareIntentSubscription = _shareIntent.onShareIntent.listen((String result) {linkModel.link = result;});
    if (linkModel.link = null)
      linkModel.link = await _shareIntent.getSharedContent();

    return linkModel;
  }

  // TODO: add exception
}