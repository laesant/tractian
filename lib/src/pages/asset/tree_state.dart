class TreeState {
  final Map<String, bool> _expanded = <String, bool>{};
  bool _allNodesExpanded = false;

  bool isNodeExpanded(String key) {
    return _expanded[key] ?? _allNodesExpanded;
  }

  void toggleNodeExpanded(String key) {
    _expanded[key] = !isNodeExpanded(key);
  }

  void expandAll() {
    _allNodesExpanded = true;
    _expanded.clear();
  }

  void collapseAll() {
    _allNodesExpanded = false;
    _expanded.clear();
  }

  void expandNode(String key) {
    _expanded[key] = true;
  }

  void collapseNode(String key) {
    _expanded[key] = false;
  }
}
