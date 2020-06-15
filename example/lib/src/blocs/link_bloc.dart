import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/link_model.dart';

class LinkBloc {
  final _repository = Repository();
  final _linkFetcher = PublishSubject<LinkModel>();

  // TODO: update legacy, move away from Observables

  Observable<LinkModel> get newLink => _linkFetcher.stream;

  getNewLink() async {
    LinkModel linkModel = await _repository.getLink();
    _linkFetcher.sink.add(linkModel);
  }

  dispose() {
    _linkFetcher.close();
  }
}

final bloc = LinkBloc();