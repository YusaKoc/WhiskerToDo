import 'package:flutter/material.dart';

import '../screens/StartScreen.dart';
import '../screens/TodayPage.dart';

class today {
  int mesaj_id;
  String mesajtoday;

  today(this.mesaj_id, this.mesajtoday,);

}

class monthly {
  int monthly_id;
  String monthlymesaj;

  monthly(this.monthly_id, this.monthlymesaj);
}

class yearly {
  int yearly_id;
  String yearly_mesaj;

  yearly(this.yearly_id, this.yearly_mesaj);
}


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Gelen RouteSettings'e göre hangi sayfaya yönlendirme yapılacağını belirle
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/today':
        return MaterialPageRoute(builder: (_) => TodayPage());
    // Diğer sayfalar için gerekirse case'ler ekleyebilirsiniz
      default:
      // Tanımlanmayan bir sayfa istenirse buraya yönlendirme yapılabilir
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('Bu sayfa mevcut değil: ${settings.name}'),
            ),
          );
        });
    }
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
