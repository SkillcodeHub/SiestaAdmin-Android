import 'package:flutter/material.dart';
import 'package:siestaamsapp/Model/Custom_Model/selectable_day.dart';
import 'package:siestaamsapp/Res/colors.dart';
import 'package:siestaamsapp/constants/string_res.dart';

class MonthDaysView extends StatefulWidget {
  static final days = 31;
  final dynamic enabledEntries;
  final num fontSize, containerHeight;
  final num? containerWidth;
  final FontWeight fontWeight;
  final Color? fontColor, backgroundColor;
  final bool isClickable;
  final ValueChanged<SelectableDay>? onDayClicked;

  MonthDaysView({
    this.fontSize = 12,
    this.fontWeight = FontWeight.bold,
    this.fontColor = Colors.white,
    this.backgroundColor,
    this.containerHeight = 30,
    this.isClickable = false,
    this.enabledEntries,
    this.containerWidth,
    this.onDayClicked,
    Key? key,
  }) : super(key: key);

  @override
  _MonthDaysViewState createState() => _MonthDaysViewState();
}

class _MonthDaysViewState extends State<MonthDaysView> {
  final containerDimension = 40.0;
  var columns;
  var rows;
  Map<int, TableColumnWidth>? widths;
  var index;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return getWithoutDimensionWidget(
          widget.containerWidth?.toInt() ?? constraints.maxWidth.toInt());
    });
  }

  Widget getWithoutDimensionWidget(num width) {
    columns = (width / containerDimension).floor();
    rows = (MonthDaysView.days / columns).ceil();
    widths = new Map<int, TableColumnWidth>();
    index = 0;
    for (num k = 0; k < columns; k++) {
      widths!.putIfAbsent(k.toInt(), () {
        return FixedColumnWidth(containerDimension);
      });
    }

    return Table(
      columnWidths: widths,
      children: [
        for (num i = 0; i < rows; i++)
          TableRow(children: [
            for (num j = 0; j < columns; j++, index++)
              index < MonthDaysView.days
                  ? getDay(context, '${index + 1}',
                      widget.enabledEntries?.contains(index) ?? false, index)
                  : Container(
                      height: 0,
                    ),
          ])
      ],
    );
  }

  Widget getDay(BuildContext context, String name, bool enabled, num dayValue) {
    return InkWell(
      onTap: widget.isClickable
          ? () {
              var day = SelectableDay(
                  name: name, dayValue: dayValue, isSelected: enabled);
              widget.onDayClicked!(day);
            }
          : null,
      child: Container(
        height: widget.containerHeight.toDouble(),
        alignment: Alignment.center,
        margin: EdgeInsets.all(3),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled
              ? (widget.backgroundColor ?? appSecondaryColor)
              : Theme.of(context).disabledColor,
        ),
        child: Text(
          name,
          style: Theme.of(context).textTheme.subtitle2?.copyWith(
                color: widget.fontColor,
                fontSize: widget.fontSize.toDouble(),
                fontWeight: widget.fontWeight,
              ),
        ),
      ),
    );
  }
}

class DayView extends StatefulWidget {
  final String name;
  final bool enabled, isClickable;
  final num containerHeight, fontSize;
  final FontWeight fontWeight;
  final Color fontColor;
  final Color? backgroundColor;
  final VoidCallback? onClick;

  DayView(
    this.name,
    this.enabled, {
    Key? key,
    this.isClickable = false,
    this.fontWeight = FontWeight.bold,
    this.fontColor = Colors.white,
    this.backgroundColor,
    this.fontSize = 12,
    this.onClick,
    this.containerHeight = 30,
  }) : super(key: key);

  @override
  _DayViewState createState() {
    return _DayViewState();
  }
}

class _DayViewState extends State<DayView> {
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
    return InkWell(
      onTap: widget.isClickable ? widget.onClick : null,
      child: Container(
        height: widget.containerHeight.toDouble(),
        alignment: Alignment.center,
        margin: EdgeInsets.all(3),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.enabled
              ? widget.backgroundColor ?? appSecondaryColor
              : Theme.of(context).disabledColor,
        ),
        child: Text(
          widget.name,
          style: Theme.of(context).textTheme.subtitle2?.copyWith(
                color: widget.fontColor,
                fontSize: widget.fontSize.toDouble(),
                fontWeight: widget.fontWeight,
              ),
        ),
      ),
    );
  }
}

class WeekDaysView extends StatelessWidget {
  final dynamic enabledEntries;
  final ValueChanged<SelectableDay>? onDayClicked;
  final bool isClickable;

  WeekDaysView({
    Key? key,
    this.enabledEntries,
    this.onDayClicked,
    this.isClickable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        getDayWidget(context, AppString.get(context).mo(),
            enabledEntries != null && enabledEntries!.contains(0), 0),
        getDayWidget(context, AppString.get(context).tu(),
            enabledEntries != null && enabledEntries!.contains(1), 1),
        getDayWidget(context, AppString.get(context).we(),
            enabledEntries != null && enabledEntries!.contains(2), 2),
        getDayWidget(context, AppString.get(context).th(),
            enabledEntries != null && enabledEntries!.contains(3), 3),
        getDayWidget(context, AppString.get(context).fr(),
            enabledEntries != null && enabledEntries!.contains(4), 4),
        getDayWidget(context, AppString.get(context).sa(),
            enabledEntries != null && enabledEntries!.contains(5), 5),
        getDayWidget(context, AppString.get(context).su(),
            enabledEntries != null && enabledEntries!.contains(6), 6),
      ],
    );
  }

  Widget getDayWidget(
    BuildContext context,
    String name,
    bool enabled,
    num dayValue, {
    num? fontSize,
    FontWeight? fontWeight,
    Color? fontColor,
    Color? backgroundColor,
    num? containerHeight,
    num? flex,
  }) {
    return Expanded(
      flex: flex?.toInt() ?? 1,
      child: InkWell(
        onTap: isClickable
            ? () {
                onDayClicked!(SelectableDay(
                    name: name, isSelected: enabled, dayValue: dayValue));
              }
            : null,
        child: Container(
          height: containerHeight?.toDouble() ?? 30,
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 3),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: enabled
                ? backgroundColor ?? appSecondaryColor
                : Theme.of(context).disabledColor,
          ),
          child: Text(
            name,
            style: Theme.of(context).textTheme.subtitle2?.copyWith(
                  color: fontColor ?? Colors.white,
                  fontSize: fontSize?.toDouble() ?? 12,
                  fontWeight: fontWeight ?? FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}
