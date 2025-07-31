import 'package:flutter/material.dart';
import 'package:omni_video_player/omni_video_player.dart';
import 'package:omni_video_player/omni_video_player/models/omni_video_speed.dart';
import 'package:omni_video_player/omni_video_player/theme/omni_video_player_theme.dart';

class PlaybackSpeedMenuButton extends StatefulWidget {
  final OmniVideoSpeed currentSpeed;
  final void Function(OmniVideoSpeed selectedSpeed) onSpeedSelected;

  const PlaybackSpeedMenuButton({
    super.key,
    required this.currentSpeed,
    required this.onSpeedSelected,
  });

  @override
  State<PlaybackSpeedMenuButton> createState() =>
      _PlaybackSpeedMenuButtonState();
}

class _PlaybackSpeedMenuButtonState extends State<PlaybackSpeedMenuButton> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  late OmniVideoSpeed selectedSpeed;

  List<OmniVideoSpeed> availableSpeeds = OmniVideoSpeed.values;

  @override
  void initState() {
    super.initState();
    selectedSpeed = widget.currentSpeed;
  }

  void _toggleMenu() {
    if (_overlayEntry == null) {
      _showMenu();
    } else {
      _removeMenu();
    }
  }

  void _showMenu() {
    final RenderBox buttonBox = context.findRenderObject()! as RenderBox;
    final position = buttonBox.localToGlobal(Offset.zero);
    final theme = OmniVideoPlayerTheme.of(context)!;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: _removeMenu,
                behavior: HitTestBehavior.translucent,
                child: Container(),
              ),
            ),
            Positioned(
              left: position.dx,
              top: position.dy - _menuHeight(),
              width: 100,
              child: CompositedTransformFollower(
                link: _layerLink,
                offset: Offset(-30, -_menuHeight()),
                child: _buildMenu(theme),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  double _menuHeight() => availableSpeeds.length * 48.0 + 16;

  void _removeMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Widget _buildMenu(OmniVideoPlayerThemeData theme) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      color: theme.colors.menuBackground,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        shrinkWrap: true,
        children: availableSpeeds.map((speed) {
          final isSelected = speed == selectedSpeed;
          return InkWell(
            onTap: () {
              setState(() => selectedSpeed = speed);
              widget.onSpeedSelected(speed);
              _removeMenu();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    speed.speedString,
                    style: TextStyle(
                      color: isSelected
                          ? theme.colors.menuTextSelected
                          : theme.colors.menuText,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      theme.icons.qualitySelectedCheck,
                      color: theme.colors.menuIconSelected,
                      size: 18,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    _removeMenu();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = OmniVideoPlayerTheme.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: CompositedTransformTarget(
        link: _layerLink,
        child: GestureDetector(
          onTap: _toggleMenu,
          child: Icon(
            Icons.speed,
            color: theme.colors.icon,
          ),
        ),
      ),
    );
  }
}
