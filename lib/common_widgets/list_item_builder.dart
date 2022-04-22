import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/common_widgets/empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  const ListItemsBuilder(
      {Key? key, required this.snapshot, required this.itemBuilder})
      : super(key: key);
  final AsyncSnapshot<List> snapshot;
  final ItemWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List items = snapshot.data!;
      if (items.isNotEmpty) {
        return _buildList(items);
      } else {
        return EmptyContent();
      }
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: 'Something went wrong',
        message: 'Can\'t load jobs right now',
      );
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildList(List items) {
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => itemBuilder(context, items[index]));
  }
}
