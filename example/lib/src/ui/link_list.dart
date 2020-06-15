import 'package:flutter/material.dart';
import '../models/link_model.dart';
import '../blocs/link_bloc.dart';

class LinkList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bloc.getNewLink();
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
      ),
      body: StreamBuilder(
        stream: bloc.newLink,
        builder: (context, AsyncSnapshot<LinkModel> snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildList(AsyncSnapshot<LinkModel> snapshot) {
    return ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Text(
              snapshot.data.link
          );
        }
    );
  }
}