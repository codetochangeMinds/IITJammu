import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';
import 'package:quiver/iterables.dart';

import 'package:iitjammu/urls.dart';

class NavData{
  String text;
  String href;
  List<NavData> children;
  NavData(this.text, this.href, this.children);
}

class ImageWithDescription{
  String src;
  String description;
  ImageWithDescription(this.src, this.description);
}

class NewsSection{
  String title;
  List<String> news;
  List<String> hrefs;

  NewsSection(this.title, this.news, this.hrefs);
}

class WebIndexPage{
  static Response response;
  static Document document;
  static init() async{
    response = await http.get(URLS.index);
    document = parser.parse(response.body);
  }

  static List<Object> getNavigation(){
    List<NavData> nav = [];
    var root = WebIndexPage.document.querySelector("#superfish-1");
    var depth1 = root.querySelectorAll("li.sf-depth-1");
    for(var d1 in depth1){
      List<NavData> children = [];
      var depth2 = d1.querySelectorAll("a.sf-depth-2");
      for(var d2 in depth2){
        children.add(NavData(d2.text, d2.attributes['href'], []));
      }

      var d1a = d1.querySelector("a.sf-depth-1");
      nav.add(NavData(d1a.text.trim(), d1a.attributes['href'].trim(), children));
    }
    return nav;
  }

  static String getLogo(){
    return WebIndexPage.document.querySelector("a.logo>img").attributes['src'];
  }

  static List<ImageWithDescription> getSlideShow(){
    List<ImageWithDescription> links = [];
    var imgs = WebIndexPage.document.querySelector("#page-header").querySelectorAll("img");
    var desc = WebIndexPage.document.querySelector("#page-header").querySelectorAll("span.field-content");

    for(var pair in zip([imgs, desc])){
      links.add(ImageWithDescription(pair[0].attributes['src'].trim(), pair[1].text.trim()));
    }    
    return links;
  }

  static List<NewsSection> getNews(){
    List<NewsSection> allnews = [];
    var sections = WebIndexPage.document.querySelector(".gt-newsblocksection").querySelectorAll("section");
    sections.forEach((section){
      String title = section.querySelector("h2").text.trim();
      var news = section.querySelectorAll("li").map((f) => f.text.trim()).toList();
      var hrefs = section.querySelectorAll("li").map((f) => f.querySelectorAll("a").length != 0 ? f.querySelector("a").attributes['href'].trim() : 'nolink').toList();
      // if(title != "Quick Links")
      allnews.add(NewsSection(title, news, hrefs));
    });
    return allnews;
  }
}

