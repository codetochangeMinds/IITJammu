import 'package:flutter/material.dart';
import 'package:iitjammu/homepage.dart';
import 'package:iitjammu/parser.dart';

void main() async{
  runApp(MyApp());
}

class ProgressBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IIT Jammu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainWindow(),
      
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainWindow extends StatefulWidget {
  MainWindow({Key key}) : super(key: key);
  @override
  _MainWindowState createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
  String title = "Home";
  Widget page = HomePage();
  bool isloaded = false;

  Future<void> fetch() async {
    await WebIndexPage.init();
    setState(() {
      this.page = HomePage();
      this.isloaded = true;
    });
  }

  @override
  initState() {
    super.initState();
    this.fetch();
  }

  @override
  Widget build(BuildContext context) {
    List<NavData> nav = !this.isloaded? [] : WebIndexPage.getNavigation();

    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            new DrawerHeader(
              child:  !this.isloaded? ProgressBarWidget() : new Image.network(WebIndexPage.getLogo())),
            new Expanded(
              child: !this.isloaded? ProgressBarWidget(): new ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: nav.length,
                itemBuilder: (context,i){
                  return nav[i].children.length == 0? new ListTile(
                    title: Text(nav[i].text),
                    onTap: (){
                      setState(() {
                        Navigator.pop(context);
                        final snackBar = SnackBar(content: Text('Not Implemented. Need Contribution.😔'));
                        Scaffold.of(context).showSnackBar(snackBar);
                        // this.title = nav[i].text;
                      });
                    }
                  ): new ExpansionTile(
                    title: Text(nav[i].text),
                    children: <Widget>[
                      new ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: nav[i].children.length,
                        itemBuilder: (context, j){
                          return new ListTile(
                            title: Text(nav[i].children[j].text),
                            onTap: (){
                              setState(() {
                                Navigator.pop(context);
                                final snackBar = SnackBar(content: Text('Not Implemented. Need Contribution.😔'));
                                Scaffold.of(context).showSnackBar(snackBar);
                                // this.title = nav[i].children[j].text;
                              });
                            },
                          );
                        })
                    ]);
                },
              ),
            ),
          ],
        ),
      ),
      body: !this.isloaded? ProgressBarWidget() : this.page
    );
  }
}
