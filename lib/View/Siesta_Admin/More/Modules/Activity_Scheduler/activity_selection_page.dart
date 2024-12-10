import 'package:flutter/material.dart';
import 'package:siestaamsapp/Model/Dashboard_model/AddTask_Model/getActivitiesList_model.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/Utils/utils.dart' as Util;
import 'package:siestaamsapp/Utils/utils.dart';
import 'package:siestaamsapp/constants/string_res.dart';

class ActivitySelectionPage extends StatefulWidget {
  final Map<num, Activities> selection;
  final List<Activities> activitiesList;

  const ActivitySelectionPage({
    super.key,
    required this.selection,
    required this.activitiesList,
  });

  @override
  State<ActivitySelectionPage> createState() => _ActivitySelectionPageState();
}

class _ActivitySelectionPageState extends State<ActivitySelectionPage> {
  List<Activities>? _activeList;
  bool showFilterView = false;
  late TextEditingController _searchController;
  Set<num>? selection;

  @override
  void initState() {
    super.initState();
    print(widget.activitiesList.length);
    selection = {};
    widget.activitiesList.sort((a, b) =>
        (a.activityNameTranslation ?? a.activityName)!
            .compareTo(b.activityNameTranslation ?? b.activityName.toString()));
    _activeList = [];
    _reloadData(false);
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchController.addListener(() {
        onSearchChanged(_searchController.text);
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: appPrimaryColor,
        title: Text(
          AppString.get(context).activities(),
          style: TextStyle(fontSize: headerFontSize, color: Colors.white),
        ),
        titleSpacing: 0,
        actions: [
          openFilter(),
          IconButton(
              onPressed: resetData,
              icon: Icon(Icons.refresh, color: Colors.white)),
        ],
        bottom: Util.getAppbarBottomSearchView(
          label:
              '${AppString.get(context).activity()} ${AppString.get(context).name()}',
          showFilterView: showFilterView,
          searchController: _searchController,
          onSearchChanged: onSearchChanged,
        ),
      ),
      floatingActionButton: widgetFAB(context),
      body: Container(
        color: Colors.grey.shade200,
        width: double.maxFinite,
        height: double.maxFinite,
        child: widgetBody(context),
      ),
    );
  }

  Widget widgetBody(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 48),
        itemCount: _activeList!.length,
        itemBuilder: (context, index) {
          final activity = _activeList![index];
          return Card(
            child: ListTile(
              horizontalTitleGap: 0,
              minLeadingWidth: 0,
              title: Row(
                children: [
                  Checkbox(
                      value: selection!.contains(activity.activityId),
                      onChanged: widget.selection
                              .containsKey(activity.activityId!.toInt())
                          ? null
                          : (value) {
                              toggleSelection(activity);
                            }),
                  Flexible(
                    child: Text(activity.activityNameTranslation ??
                        activity.activityName ??
                        "-"),
                  ),
                ],
              ),
              enabled:
                  !widget.selection.containsKey(activity.activityId!.toInt()),
              onTap: () {
                toggleSelection(activity);
              },
            ),
          );
        });
  }

  Widget widgetFAB(BuildContext context) {
    return FloatingActionButton.small(
      backgroundColor: appSecondaryColor,
      onPressed: () {
        if (selection!.isEmpty) {
          Util.showSnackMessage(
              context, AppString.get(context).selectAtleastOneActivity());
          return;
        }
        List<Activities> selectedList = [];
        for (num i = 0, j = widget.activitiesList.length; i < j; i++) {
          if (selection!
              .contains(widget.activitiesList[i.toInt()].activityId)) {
            selectedList.add(widget.activitiesList[i.toInt()]);
          }
        }
        Navigator.of(context).pop(selectedList);
      },
      child: Icon(Icons.check),
    );
  }

  Widget openFilter() {
    return IconButton(
      icon: Icon(
        Icons.search,
        color: showFilterView ? appSecondaryColor : Colors.white,
      ),
      onPressed: () {
        setState(() {
          showFilterView = !showFilterView;
          if (!showFilterView) _searchController.clear();
        });
      },
    );
  }

  void toggleSelection(Activities activity) {
    setState(() {
      if (selection!.contains(activity.activityId)) {
        selection!.remove(activity.activityId);
      } else {
        selection!.add(activity.activityId!.toInt());
      }
    });
  }

  void _reloadData(bool refresh) {
    if (refresh) {
      setState(() {
        _activeList!.clear();
        _activeList!.addAll(widget.activitiesList);
      });
    } else {
      _activeList!.clear();
      _activeList!.addAll(widget.activitiesList);
    }
  }

  void resetData() {
    setState(() {
      selection!.clear();
    });
  }

  void onSearchChanged(String value) {
    if (value == null || value.length == 0) {
      _reloadData(true);
      return;
    }
    setState(() {
      _activeList!.clear();
      widget.activitiesList.forEach((element) {
        if ((element.activityNameTranslation != null &&
                element.activityNameTranslation!
                    .toLowerCase()
                    .contains(value.toLowerCase())) ||
            (element.activityName != null &&
                element.activityName!
                    .toLowerCase()
                    .contains(value.toLowerCase()))) {
          _activeList!.add(element);
        }
      });
    });
  }
}
