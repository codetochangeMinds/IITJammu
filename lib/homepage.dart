import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:iitjammu/parser.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage>{

  @override
  Widget build(BuildContext context) {
    List<ImageWithDescription> imgs = WebIndexPage.getSlideShow();
    List<NewsSection> allnews = WebIndexPage.getNews();

    return Container(
      padding: EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CarouselWithIndicator(imgs),
            ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              itemCount: allnews.length,
              itemBuilder: (context, i){
                return Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          allnews[i].title,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 24.0),
                        ),
                      ),
                      Divider(),
                      ListView.builder(
                        itemCount: allnews[i].news.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context2, j){
                          return ListTile(
                            title: Text(allnews[i].news[j]),
                            onTap: (){
                              final snackBar = SnackBar(content: Text('Not Implemented. Need Contribution.😔'));
                              Scaffold.of(context).showSnackBar(snackBar);
                            },
                          );
                        } 
                      )
                    ],
                  ),
                );}, 
            )],
        ),
      ),
    );
  }
}


List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }
  return result;
}

class CarouselWithIndicator extends StatefulWidget {
  final List<ImageWithDescription> imgs;
  CarouselWithIndicator(this.imgs);

  @override
  _CarouselWithIndicatorState createState() => _CarouselWithIndicatorState(this.imgs);
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;
  final List<ImageWithDescription> imgs;
  List child;

  _CarouselWithIndicatorState(this.imgs){
    child = map<Widget>(
      this.imgs,
      (index, img) {
        return Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Stack(children: <Widget>[
              Image.network(img.src, fit: BoxFit.fitHeight, height: 400.0,),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color.fromARGB(200, 0, 0, 0), Color.fromARGB(0, 0, 0, 0)],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Text(
                    img.description,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ]),
          ),
        );
      },
    ).toList();
  }


  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CarouselSlider(
        items: child,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 2.0,
        onPageChanged: (index) {
          setState(() {
            _current = index;
          });
        },
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: map<Widget>(
          this.imgs,
          (index, url) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? Color.fromRGBO(0, 0, 0, 0.9)
                      : Color.fromRGBO(0, 0, 0, 0.4)),
            );
          },
        ),
      ),
    ]);
  }
}
