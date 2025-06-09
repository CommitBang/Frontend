class BoundingBox {
  final double x0;
  final double y0;
  final double x1;
  final double y1;

  const BoundingBox({
    required this.x0,
    required this.y0,
    required this.x1,
    required this.y1,
  });

  Map<String, dynamic> toJson() {
    return {
      'x0': x0,
      'y0': y0,
      'x1': x1,
      'y1': y1,
    };
  }

  factory BoundingBox.fromJson(Map<String, dynamic> json) {
    return BoundingBox(
      x0: (json['x0'] as num).toDouble(),
      y0: (json['y0'] as num).toDouble(),
      x1: (json['x1'] as num).toDouble(),
      y1: (json['y1'] as num).toDouble(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BoundingBox &&
        other.x0 == x0 &&
        other.y0 == y0 &&
        other.x1 == x1 &&
        other.y1 == y1;
  }

  @override
  int get hashCode => Object.hash(x0, y0, x1, y1);
}