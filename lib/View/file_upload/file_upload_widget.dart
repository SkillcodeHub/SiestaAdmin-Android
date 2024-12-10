import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siestaamsapp/Utils/utils.dart' as Util;
import 'package:siestaamsapp/Utils/utils.dart';
import 'package:siestaamsapp/View/file_upload/bloc/file_upload_bloc.dart';
import 'package:siestaamsapp/View/file_upload/bloc/upload_model.dart';
import 'package:siestaamsapp/constants/string_res.dart';
import 'package:timeago/timeago.dart' as timeago;

class FileUploadsList extends StatefulWidget {
  // static const String routeName = '/uploads_list';

  FileUploadsList({Key? key}) : super(key: key);

  @override
  _FileUploadsListState createState() {
    return _FileUploadsListState();
  }
}

class _FileUploadsListState extends State<FileUploadsList> {
  late StreamSubscription _subscription;
  bool sortAtoZ = true;

  @override
  void initState() {
    super.initState();

    _subscription = BlocProvider.of<FileUploadBloc>(context)
        .monitorProgress
        .listen((event) {
      print(
          'Task Id: ${event.taskId}, Status: ${event.status.description}, Progress:${event.progress}');
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: BackButton(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          AppString.get(context).uploads(),
          style: TextStyle(fontSize: headerFontSize, color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.sort, color: Colors.white),
            onPressed: () => toggleSort(sortAtoZ),
            tooltip: AppString.get(context).sort(),
          ),
          IconButton(
            icon: Icon(Icons.delete_sweep, color: Colors.white),
            tooltip: AppString.get(context).removeCompleted(),
            onPressed: () => BlocProvider.of<FileUploadBloc>(context)
                .add(RemoveCompletedUploadsEvent()),
          ),
        ],
      ),
      body: Container(
        color: Colors.grey.shade200,
        child: BlocBuilder<FileUploadBloc, FileUploadState>(
            builder: (context, state) {
          print('state update ${state.toString()}');
          if (state is IdleState) {
            return Util.getEmptyDataView(context,
                error: AppString.get(context).noPendingUploads(),
                callback: () {},
                showRetryButton: false);
          } else {
            FileUploadRunningState cState = state as FileUploadRunningState;
            num length1 = cState.getPendingUploads.length;
            num length2 = cState.getPausedUploads.length;
            num count = length1 + length2;
            print('length1: $length1, length2:$length2');
            cState.getPendingUploads.sort((a, b) =>
                sortAtoZ ? a.time.compareTo(b.time) : b.time.compareTo(a.time));
            cState.getPausedUploads.sort((a, b) =>
                sortAtoZ ? a.time.compareTo(b.time) : b.time.compareTo(a.time));
            return ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: count.toInt(),
              itemBuilder: (context, index) {
                if (index > length1 - 1) {
                  return _ItemView(cState.getPausedUploads[index],
                      isPaused: false);
                }
                return _ItemView(cState.getPendingUploads[index],
                    isPaused: false);
              },
            );
          }
        }),
      ),
    );
  }

  void toggleSort(bool status) {
    setState(() {
      sortAtoZ = !status;
    });
  }
}

class _ItemView extends StatefulWidget {
  final UploadModel item;
  final bool isPaused;

  _ItemView(this.item, {Key? key, required this.isPaused}) : super(key: key);

  @override
  _ItemViewState createState() => _ItemViewState();
}

class _ItemViewState extends State<_ItemView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 4,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              child: Row(children: [
                Text(
                  UploadModel.getUploadModuleName(widget.item.module),
                  style:
                      TextStyle(fontSize: headerFontSize, color: Colors.black),
                ),
                Text(
                  '${timeago.format(DateTime.now().subtract(DateTime.now().difference(widget.item.time)), locale: 'en_short')} ago',
                  style: TextStyle(color: Colors.grey.shade600),
                )
              ]),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'TaskId: ${widget.item.uploadId}',
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
            Stack(
              children: [
                Container(
                  height: 100,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(8),
                  child: LayoutBuilder(
                    builder: (context, constraint) {
                      num count = 3, listCount = widget.item.files.length;
                      return ListView.builder(
                        itemCount: count.toInt(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          if (index >= widget.item.files.length) {
                            return Container(
                              width: constraint.maxWidth / count,
                              height: 100,
                            );
                          } else {
                            return Container(
                              padding: EdgeInsets.all(5),
                              child: Container(
                                child: Stack(
                                  children: <Widget>[
                                    Positioned.fill(
                                      child: Container(
                                        child: Image.file(
                                          widget.item.files[index],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    if (index == 2 && listCount > 3)
                                      Positioned.fill(
                                        child: Container(
                                          alignment: Alignment.center,
                                          color: Colors.black.withOpacity(0.5),
                                          child: Text('+${listCount - 3}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5
                                                  ?.copyWith(
                                                      color: Colors.white)),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                              width: constraint.maxWidth / count,
                              height: 100,
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
                Positioned.fill(
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    value: widget.item.progress == 100
                        ? 0
                        : widget.item.progress.toDouble() / 100,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(left: 8),
              alignment: Alignment.centerRight,
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                        '${widget.item.subTitle}',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      flex: 1),
                  SizedBox(width: 5),
                  if (widget.item.isSuccessFullyUploaded)
                    Container(
                      height: Theme.of(context).buttonTheme.height,
                      width: Theme.of(context).buttonTheme.minWidth,
                      alignment: Alignment.center,
                      child: Icon(Icons.cloud_done),
                    ),
                  if (widget.item.uploadError != null)
                    Container(
                      height: Theme.of(context).buttonTheme.height,
                      width: Theme.of(context).buttonTheme.minWidth,
                      alignment: Alignment.center,
                      child: Icon(Icons.error),
                    ),
                  if (widget.item.isUploading)
                    TextButton(
                      child: Text(
                        AppString.get(context).cancel(),
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () =>
                          BlocProvider.of<FileUploadBloc>(context).add(
                        RemoveFromUploadEvent(widget.item),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
