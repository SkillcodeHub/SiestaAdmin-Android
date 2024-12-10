import 'package:flutter/material.dart';

class ExpansionEntry {
  final Widget parent;
  num priority;
  final List<ExpansionEntry> children;

  ExpansionEntry(
    this.parent, {
    this.children = const <ExpansionEntry>[],
    this.priority = 0,
  });
}

class ExpandedItem extends StatelessWidget {
  final ExpansionEntry? entry;
  final Color? backgroundColor;
  final bool? initiallyExpanded;
  final Widget? leading;
  final void Function(bool)? onExpansionChanged;
  final Widget? subtitle;
  final Widget? trailing;

  ExpandedItem(
    this.entry, {
    this.backgroundColor,
    this.initiallyExpanded = false,
    this.leading,
    this.onExpansionChanged,
    this.subtitle,
    this.trailing,
  });

  Widget _buildTiles(ExpansionEntry root) {
    if (root.children.isEmpty) return ListTile(title: root.parent);
    return ExpansionTile(
      backgroundColor: backgroundColor,
      initiallyExpanded: initiallyExpanded ?? false,
      leading: leading,
      onExpansionChanged: onExpansionChanged,
      subtitle: subtitle,
      trailing: trailing,
      key: PageStorageKey<ExpansionEntry>(root),
      title: root.parent,
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry!);
  }
}
