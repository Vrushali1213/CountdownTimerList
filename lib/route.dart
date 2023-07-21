import 'package:countdowntimerlist/view/counterlist.dart';

class Routes {
  static generateRoute() {
    return {
      '/CounterListpage': (context) => const CounterListpage(),
    };
  }
}
