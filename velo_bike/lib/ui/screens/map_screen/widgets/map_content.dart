import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:velo_bike/ui/screens/main_navigation_screen.dart';
import 'package:velo_bike/ui/screens/map_screen/viewmodel/map_vm.dart';
import 'package:velo_bike/ui/screens/map_screen/widgets/search_suggestion_list.dart';
import 'package:velo_bike/ui/states/active_pass_state.dart';

import 'bike_map_view.dart';
import 'map_pass_panel.dart';
import 'map_search_panel.dart';

class MapContent extends StatefulWidget {
  final ValueChanged<int> onNavigate;
  const MapContent({super.key, required this.onNavigate});

  @override
  State<MapContent> createState() => _MapContentState();
}

class _MapContentState extends State<MapContent> {
  bool _isPassExpanded = false;
  bool _isSearchExpanded = false;

  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _togglePassPanel() {
    setState(() {
      _isPassExpanded = !_isPassExpanded;
      if (_isPassExpanded) _isSearchExpanded = false;
    });
  }

  void _toggleSearchPanel() {
    setState(() {
      _isSearchExpanded = !_isSearchExpanded;
      if (_isSearchExpanded) _isPassExpanded = false;
    });
  }

  void _closePanels() {
    FocusScope.of(context).unfocus();

    if (_isPassExpanded || _isSearchExpanded) {
      setState(() {
        _isPassExpanded = false;
        _isSearchExpanded = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MapViewModel>();

    if (vm.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (vm.error != null) {
      return Scaffold(body: Center(child: Text(vm.error!)));
    }

    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: _closePanels,
            behavior: HitTestBehavior.translucent,
            child: BikeMapView(stations: vm.stations, isStationAvailable: vm.isStationAvailable, onBackgroundTap: _closePanels, mapController: _mapController),
          ),
          SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: 12,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      MapSearchPanel(
                        isExpanded: _isSearchExpanded,
                        controller: _searchController,
                        onToggle: _toggleSearchPanel,
                        onClear: () {
                          _searchController.clear();
                          vm.clearSearch();
                          setState(() {});
                        },
                        onChanged: (value) {
                          vm.searchStations(value);
                          setState(() {});
                        },
                      ),
                      if (_isSearchExpanded && _searchController.text.trim().isNotEmpty)
                        SearchSuggestionList(
                          stations: vm.stations,
                          onSelect: (station) {
                            _searchController.text = station.name;

                            _mapController.move(LatLng(station.latitude, station.longitude), 16);

                            vm.searchStations(station.name);

                            setState(() {
                              _isSearchExpanded = false;
                            });

                            FocusScope.of(context).unfocus();
                          },
                        ),
                    ],
                  ),
                ),
                Positioned(
                  top: 84,
                  right: 16,
                  child: MapPassPanel(
                    isExpanded: _isPassExpanded,
                    activePass: context.watch<ActivePassNotifier>().activePass,
                    onToggle: _togglePassPanel,
                    onGetPassTap: () {
                      widget.onNavigate(0);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
