import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:label_pro_client/domain/models/label.dart';
import 'package:label_pro_client/domain/models/polygon.dart';
import 'package:label_pro_client/features/tagging/tasks/polygon/bloc/polygon_task_cubit.dart';

import '../utils/polygon_utils.dart';

class MultiPolygonEditorWidget extends StatefulWidget {
  final String imageUrl;
  final List<Polygon> polygons;
  final void Function(List<Polygon> updated)? onChanged;
  final void Function(int activePolygonIndex)? onSetActivePolygon;
  final int? activePolygonIndex;

  const MultiPolygonEditorWidget({
    required this.imageUrl,
    required this.polygons,
    this.activePolygonIndex,
    this.onSetActivePolygon,
    this.onChanged,
    super.key,
  });

  @override
  State<MultiPolygonEditorWidget> createState() => _MultiPolygonEditorWidgetState();
}

class _MultiPolygonEditorWidgetState extends State<MultiPolygonEditorWidget> {
  late List<Polygon> polygons;
  int? draggingPointIndex;
  int? draggingPolygonIndex;
  Offset? _lastPanPosition;
  static const double pointRadius = 4;
  static const double midpointRadius = 3;

  @override
  void initState() {
    super.initState();
    polygons = widget.polygons;
  }

  @override
  void didUpdateWidget(covariant MultiPolygonEditorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.polygons.length != polygons.length) {
      setState(() {
        polygons = widget.polygons;
      });
    }
  }

  List<Offset> get activePoints =>
      widget.activePolygonIndex != null ? polygons[widget.activePolygonIndex!].points : [];

  void _updatePolygon() {
    if (widget.onChanged != null) {
      widget.onChanged!(List.from(polygons));
    }
  }

  bool _isPointInsidePolygon(Offset point, List<Offset> polygon) {
    int intersectCount = 0;
    for (int j = 0; j < polygon.length; j++) {
      Offset a = polygon[j];
      Offset b = polygon[(j + 1) % polygon.length];

      if (((a.dy > point.dy) != (b.dy > point.dy)) &&
          (point.dx < (b.dx - a.dx) * (point.dy - a.dy) / (b.dy - a.dy + 0.00001) + a.dx)) {
        intersectCount++;
      }
    }
    return (intersectCount % 2) == 1;
  }

  int? _hitTestPoint(Offset localPos) {
    if (widget.activePolygonIndex == null) return null;
    final points = activePoints;
    for (int i = 0; i < points.length; i++) {
      if ((points[i] - localPos).distance <= pointRadius + 2) {
        return i;
      }
    }
    return null;
  }

  int? _hitTestActivePolygon(Offset point) {
    final activePolygonIndex = widget.activePolygonIndex;
    if (activePolygonIndex == null) {
      return null;
    }
    if (_isPointInsidePolygon(point, polygons[activePolygonIndex].points)) {
      return activePolygonIndex;
    }
    return null;
  }

  int? _hitTestMidpoint(Offset localPos) {
    final activePolygonIndex = widget.activePolygonIndex;
    if (activePolygonIndex == null) return null;
    final points = activePoints;
    for (int i = 0; i < points.length; i++) {
      final next = (i + 1) % points.length;
      final midpoint = (points[i] + points[next]) / 2;
      if ((midpoint - localPos).distance <= midpointRadius + 2) {
        return i;
      }
    }
    return null;
  }

  void _addPointBetween(int index) {
    final activePolygonIndex = widget.activePolygonIndex;
    final points = activePoints;
    final next = (index + 1) % points.length;
    final midpoint = (points[index] + points[next]) / 2;

    setState(() {
      polygons[activePolygonIndex!] = Polygon(
        label: polygons[activePolygonIndex].label,
        points: [
          ...points.sublist(0, next),
          midpoint,
          ...points.sublist(next),
        ],
      );
    });
    _updatePolygon();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<PolygonTaskCubit>().state;
    final imageSize = state.size;
    return LayoutBuilder(builder: (context, c) {
      return FittedBox(
        child: SizedBox(
          width: imageSize.width,
          height: imageSize.height,
          child: GestureDetector(
            supportedDevices: {
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
            },
            onTapDown: (details) {
              final local = details.localPosition;
              final insertIndex = _hitTestMidpoint(local);
              if (insertIndex != null) {
                _addPointBetween(insertIndex);
                return;
              }
              for (int i = 0; i < polygons.length; i++) {
                if (polygons[i].points.any((p) => (p - local).distance < 10)) {
                  widget.onSetActivePolygon?.call(i);
                  return;
                }
              }

              if (_hitTestActivePolygon(local) != null) {
                return;
              }

              // TODO(dev): maybe change
              if (state.selectedClassId == 0) {
                return;
              }

              setState(() {
                polygons = [
                  ...polygons,
                  Polygon(
                    points: [
                      Offset(local.dx, local.dy),
                      Offset(local.dx + 20, local.dy + 20),
                    ],
                    label: state.availableLabels.firstWhere((e) => e.id == state.selectedClassId),
                  ),
                ];
              });
              widget.onChanged?.call(polygons);
            },
            onPanStart: (details) {
              draggingPointIndex = _hitTestPoint(details.localPosition);
              draggingPolygonIndex = _hitTestActivePolygon(details.localPosition);
              _lastPanPosition = details.localPosition;
            },
            onPanUpdate: (details) {
              final activePolygonIndex = widget.activePolygonIndex;
              if (activePolygonIndex == null) return;

              final currentPos = details.localPosition;

              if (draggingPointIndex != null) {
                setState(() {
                  final pts = [...activePoints];
                  pts[draggingPointIndex!] = currentPos;
                  polygons[activePolygonIndex] = Polygon(
                    label: polygons[activePolygonIndex].label,
                    points: pts,
                  );
                });
                _updatePolygon();
              } else if (draggingPolygonIndex != null && _lastPanPosition != null) {
                final delta = currentPos - _lastPanPosition!;
                setState(() {
                  final polygon = polygons[draggingPolygonIndex!];
                  final movedPoints = polygon.points.map((p) => p + delta).toList();
                  polygons[draggingPolygonIndex!] = Polygon(
                    label: polygon.label,
                    points: movedPoints,
                  );
                });
                _updatePolygon();
              }

              _lastPanPosition = currentPos;
            },
            onPanEnd: (_) => draggingPointIndex = null,
            child: ClipRect(
              child: CustomPaint(
                foregroundPainter: MultiPolygonPainter(
                  polygons: polygons,
                  labels: state.availableLabels,
                  activeIndex: widget.activePolygonIndex,
                ),
                child: Image.network(
                  widget.imageUrl,
                  height: imageSize.height,
                  width: imageSize.width,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class MultiPolygonPainter extends CustomPainter {
  final List<Polygon> polygons;
  final List<Label> labels;
  final int? activeIndex;

  MultiPolygonPainter({
    required this.polygons,
    required this.labels,
    this.activeIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < polygons.length; i++) {
      final polygon = polygons[i];
      final isActive = i == activeIndex;
      final color = getPolygonColor(
        avalibleLabels: labels,
        currentLabel: polygon.label,
      );

      final path = Path();
      final points = polygon.points;
      if (points.isNotEmpty) {
        path.moveTo(points[0].dx, points[0].dy);
        for (var j = 1; j < points.length; j++) {
          path.lineTo(points[j].dx, points[j].dy);
        }
        path.close();
      }

      final borderPaint = Paint()
        ..color = color
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;
      final insidePaint = Paint()
        ..color = color.withValues(alpha: 0.3)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.fill;

      if (isActive) {
        canvas.drawPath(path, insidePaint);
      }
      canvas.drawPath(path, borderPaint);

      for (var p in points) {
        canvas.drawCircle(p, 4, Paint()..color = isActive ? Colors.blue : Colors.grey);
      }

      if (isActive) {
        for (int j = 0; j < points.length; j++) {
          final next = (j + 1) % points.length;
          final midpoint = (points[j] + points[next]) / 2;
          canvas.drawCircle(midpoint, 3, Paint()..color = Colors.grey);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
