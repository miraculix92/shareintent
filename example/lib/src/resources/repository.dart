import 'dart:async';
import 'link_provider.dart';
import '../models/link_model.dart';

class Repository {
  final linkProvider = LinkProvider();

  Future<LinkModel> getLink() => linkProvider.getLink();
}