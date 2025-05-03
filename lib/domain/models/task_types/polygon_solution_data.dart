import 'package:label_pro_client/domain/models/polygon.dart';

class PolygonSolutionData {
  final List<Polygon> polygons;

  const PolygonSolutionData({
    required this.polygons,
  });

  Map<String, dynamic> toJson() {
    return {
      'polygons': polygons.map((poly) => poly.toJson()).toList(),
    };
  }
}
