import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/utils/chart_axis.dart';

void main() {
  test('picks round intervals of 1, 2 or 5 times a power of ten', () {
    expect(ChartAxis.niceInterval(173000000), 50000000);
    expect(ChartAxis.niceInterval(7000000), 2000000);
    expect(ChartAxis.niceInterval(4), 1);
    expect(ChartAxis.niceInterval(0), 1);
  });

  test('splits the range into the given number of steps', () {
    expect(ChartAxis.niceInterval(50, steps: 5), 10);
    expect(ChartAxis.niceInterval(3.17, steps: 5), 1);
  });
}
