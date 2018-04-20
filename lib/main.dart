import 'package:flutter/material.dart';
import 'package:kary/image/demo_image.dart';
import 'package:kary/layout/multi/main_layout_multi.dart';
import 'package:kary/layout/single/main_layout_single.dart';
import 'package:kary/route/routes.dart';
import 'package:kary/text/demo_text.dart';
import 'package:kary/news/news.dart';
import 'package:kary/more/card.dart';
import 'package:kary/more/delaytext.dart';
import 'package:kary/more/cardview.dart';
import 'package:kary/more/mylayout.dart';

void main() => runApp(new Kary());


class Kary extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(primaryColor: Colors.blue),
      home: new KaryMain(),
      routes: <String, WidgetBuilder>{
        RoutePath.home: (BuildContext context) => new IndexPage(),
        RoutePath.mylayout: (BuildContext context) => new MyLayout(),
        RoutePath.image: (BuildContext context) => new DemoImage(),
        RoutePath.text: (BuildContext context) => new DemoText(),
        RoutePath.news: (BuildContext context) => new News(),
        RoutePath.card: (BuildContext context) => new Cards(),
        RoutePath.cardview: (BuildContext context) => new CardView(),
        RoutePath.delaytext: (BuildContext context) => new DelayText(),
        RoutePath.layoutSingle: (BuildContext context) => new MainLayoutSingle(),
        RoutePath.layoutMulti: (BuildContext context) => new MainLayoutMulti()
      },
    );
  }
}


class KaryMain extends StatefulWidget {

  @override
  State createState() => new KaryMainState();
}

class KaryMainState extends State<KaryMain> {

  final _biggerFont = const TextStyle(fontSize: 18.0);

  Choice _selectedChoice = choices[0]; // The app's "state".
  void _select(Choice choice) {
    setState(() { // Causes the app to rebuild with the new _selectedChoice.
      _selectedChoice = choice;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double systemTopPadding = MediaQuery.of(context).padding.top;
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('kary '),
        actions: <Widget>[
          new IconButton( // action button
            icon: new Icon(choices[0].icon),
            onPressed: () { _select(choices[0]); },
          ),
          new IconButton( // action button
            icon: new Icon(choices[1].icon),
            onPressed: () { _select(choices[1]); },
          ),
          new IconButton( // action button
            icon: new Icon(choices[2].icon),
            onPressed: () { _select(choices[2]); },
          ),
          new PopupMenuButton<Choice>( // overflow menu
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return choices.skip(3).map((Choice choice) {
                return new PopupMenuItem<Choice>(
                  value: choice,
                  child: new Text(choice.title),
                );
              }).toList();
            },
          ),
        ],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new DrawerHeader(
              child: const Text(''),
              decoration: new FlutterLogoDecoration(
                margin: new EdgeInsets.fromLTRB(12.0, 12.0 + systemTopPadding, 12.0, 12.0),
                style:  FlutterLogoStyle.horizontal,
                lightColor: Colors.lightBlue.shade400,
                darkColor: Colors.blue.shade900,
                textColor: const Color(0xFF9E9E9E),
              ),
            ),
            new ListTile(
                title: new Text('Widget - Text',style: _biggerFont ),
                onTap: () {
                  Navigator.of(context).pop(); // Dismiss the drawer.
                  _pushPage(context, new RouteEntry(
                      'Widget - Text', RoutePath.text));
                }
            ),
            new ListTile(
                title: new Text('Widget - MyLayout',style: _biggerFont ),
                onTap: () {
                  Navigator.of(context).pop(); // Dismiss the drawer.
                  _pushPage(context, new RouteEntry(
                      'Widget - MyLayout', RoutePath.mylayout));
                }
            ),
            new ListTile(
                title: new Text('Widget - DelayText',style: _biggerFont ),
                onTap: () {
                  Navigator.of(context).pop(); // Dismiss the drawer.
                  _pushPage(context, new RouteEntry(
                      'Widget - DelayText', RoutePath.delaytext));
                }
            ),
            new ListTile(
                title: new Text('Widget - CardView',style: _biggerFont ),
                onTap: () {
                  Navigator.of(context).pop(); // Dismiss the drawer.
                  _pushPage(context, new RouteEntry(
                      'Widget - CardView', RoutePath.cardview));
                }
            ),
            new ListTile(
                title: new Text('Widget - Card',style: _biggerFont ),
                onTap: () {
                  Navigator.of(context).pop(); // Dismiss the drawer.
                  _pushPage(context, new RouteEntry(
                      'Widget - Card', RoutePath.card));
                }
            ),
            new ListTile(
                title: new Text('Widget - Image' , style: _biggerFont,),
                onTap: () {
                  Navigator.of(context).pop(); // Dismiss the drawer.
                  _pushPage(context, new RouteEntry(
                      'Widget - Image', RoutePath.image));
                }
            ),
            new ListTile(
                title: new Text('Widget - News',style: _biggerFont ),
                onTap: () {
                  Navigator.of(context).pop(); // Dismiss the drawer.
                  _pushPage(context, new RouteEntry(
                      'Widget - News', RoutePath.news));
                }
            ),
            new ListTile(
                title: new Text('Layout - Single Child',style: _biggerFont ),
                onTap: () {
                  Navigator.of(context).pop(); // Dismiss the drawer.
                  _pushPage(context, new RouteEntry(
                      'Layout - Single Child', RoutePath.layoutSingle));
                }
            ),
            const Divider(),
            new ListTile(
                title: new Text('Layout - Multi Child' , style: _biggerFont,),
                onTap: () {
                  Navigator.of(context).pop(); // Dismiss the drawer.
                  _pushPage(context, new RouteEntry(
                      'Layout - Multi Child', RoutePath.layoutMulti));
                }
            ),
          ],
        ),
      ),
      body: new IndexPage(),
    );
  }

  _pushPage(BuildContext context, RouteEntry entry) {
    var routePath = entry.routePath;
    if (routePath != null) {
      Navigator.of(context).pushNamed(routePath);
    }
  }

}



class RouteEntry {

  String title;

  String routePath;

  RouteEntry(this.title, this.routePath);


}


class PageEntry {
  String title;

  Widget widget;

  String desc;

  PageEntry(this.title, this.widget, this.desc);


}

class Choice {
  const Choice({ this.title, this.icon });
  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'search', icon: Icons.search),
  const Choice(title: 'filter_list', icon: Icons.filter_list),
  const Choice(title: 'games ', icon: Icons.games ),
  const Choice(title: 'Bus', icon: Icons.directions_bus),
  const Choice(title: 'Train', icon: Icons.directions_railway),
  const Choice(title: 'Walk', icon: Icons.directions_walk),
];


class IndexPage extends StatelessWidget{

  void _openDrawer() {}

  @override
  Widget build(BuildContext context) {
    Widget titleSection = new Container(
      padding: const EdgeInsets.all(32.0),
      child: new Row(
        children: [
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: new Text(
                    'Oeschinen Lake Campground',
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                new Text(
                  'Kandersteg, Switxerland',
                  style: new TextStyle(
                    color: Colors.grey[500],
                  )
                )
              ],
            ),
          ),
          new Icon(
            Icons.star,
            color: Colors.red[500],
          ),
          new Text('41'),
        ],
      ),
    );

    Column buildButtonColumn(IconData icon, String label){
      Color color = Theme.of(context).primaryColor;

      return new Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Icon(icon, color: color),
          new Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: new Text(
              label,
              style: new TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ],
      );
    }

    Widget buttonSection = new Container(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildButtonColumn(Icons.call, 'CALL'),
          buildButtonColumn(Icons.near_me, 'ROUTE'),
          buildButtonColumn(Icons.share, 'SHARE'),
        ],
      ),
    );

    Widget textSection = new Container(
      padding: const EdgeInsets.all(32.0),
      child: new Text(
        '''
Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese Alps. Situated 1,578 meters above sea level, it is one of the larger Alpine Lakes. A gondola ride from Kandersteg, followed by a half-hour walk through pastures and pine forest, leads you to the lake, which warms to 20 degrees Celsius in the summer. Activities enjoyed here include rowing, and riding the summer toboggan run.
        ''',
        softWrap: true,
      ),
    );

    return new MaterialApp(
      title: 'Flutter Demo',
      home: new Scaffold(
        // appBar: new AppBar(
        //   title: new Text('Top Lakes'),
        // ),
        body: new ListView(
          children: [
            new Image.asset(
              'assets/images/lake.jpg',
              width: 600.0,
              height: 240.0,
              fit: BoxFit.cover,
            ),
            titleSection,
            buttonSection,
            textSection,
          ],
        ),
      ),
    );
  }

}





// class IndexPage extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//     return new Container(
//       child: const Text('kary : app made in flutter'),
//       alignment: Alignment.center,
//     );
//   }

//   void _openDrawer() {

//   }
// }