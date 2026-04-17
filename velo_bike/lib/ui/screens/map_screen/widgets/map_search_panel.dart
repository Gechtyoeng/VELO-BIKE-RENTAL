import 'package:flutter/material.dart';

class MapSearchPanel extends StatelessWidget {
  final bool isExpanded;
  final TextEditingController controller;
  final VoidCallback onToggle;
  final VoidCallback onClear;
  final ValueChanged<String> onChanged;

  const MapSearchPanel({super.key, required this.isExpanded, required this.controller, required this.onToggle, required this.onClear, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
      width: isExpanded ? 480 : 56,
      height: 56,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.14), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        child: isExpanded
            ? Row(
                key: const ValueKey('expanded-search'),
                children: [
                  IconButton(onPressed: onToggle, icon: const Icon(Icons.search)),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(hintText: 'Search station', border: InputBorder.none, isDense: true),
                      onChanged: onChanged,
                    ),
                  ),
                  IconButton(onPressed: onClear, icon: const Icon(Icons.close)),
                ],
              )
            : IconButton(key: const ValueKey('collapsed-search'), onPressed: onToggle, icon: const Icon(Icons.search)),
      ),
    );
  }
}
