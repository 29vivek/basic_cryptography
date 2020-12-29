import 'package:charts_flutter/flutter.dart' as charts;

class AxisTheme {
  static charts.NumericAxisSpec numericAxisSpec() {
    return charts.NumericAxisSpec(
      renderSpec: charts.SmallTickRendererSpec(
        labelStyle: charts.TextStyleSpec(
          color: charts.MaterialPalette.gray.shade500,
        ),
      ),
      showAxisLine: true,
    );
  }

  static charts.AxisSpec<String> domainSpec() {
    return charts.AxisSpec<String>(
      renderSpec: charts.SmallTickRendererSpec(
        labelStyle: charts.TextStyleSpec(
          color: charts.MaterialPalette.gray.shade500,
        ),
      ),
    );
  }
}