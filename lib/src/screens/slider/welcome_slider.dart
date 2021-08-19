
import 'package:flutter/material.dart';
import 'package:flutter_chat/src/business/shared_preference_data.dart';
import 'package:flutter_chat/src/business/user_auto.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:shared_preferences/shared_preferences.dart';
class WelcomeSlider extends StatefulWidget {
  static const routeName = '/WelcomeSlider';
  final SharedPreferences prefs;
  final List<WalkThrough>pages=[
    WalkThrough(
      image: AssetImage("images/ic_launcher_round.png",),
      title: "Welcome in app",
      description:
      "You're going to go great things with My Event!\nSwipe to see how.",
    ),
    WalkThrough(
      image: AssetImage("images/note.gif"),
      title: "Its Yours.\n Use It",
      description: "Use Firebase for user management.",
    ),
    WalkThrough(
      image: AssetImage("images/chat.gif"),
      title: "Make Connections",
      description:
      "You can send messages to other Collegues",
    ),
  ];
  WelcomeSlider({this.prefs});
  @override
  _WalkthroughScreenState createState() => _WalkthroughScreenState();
}

class _WalkthroughScreenState extends State<WelcomeSlider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Swiper.children(
        autoplay:false,
        index:0,
        loop:false,
        pagination:new SwiperPagination(
          margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 40.0),
          builder: new DotSwiperPaginationBuilder( color: Colors.grey,
              activeColor: Colors.orange.shade900,
              size: 6.5,
              activeSize: 10.0),
        ),
        control: SwiperControl(
          iconPrevious: null,
          iconNext: null,
        ),
        children: _getPages(context),
      ),
    );
  }
  List<Widget>_getPages(BuildContext context){
    List<Widget> widgets=[];
    for(int i=0; i<widget.pages.length;i++){
      WalkThrough page=widget.pages[i];
      widgets.add(
          new Container(
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top:10.0),
                  child: Image(image:page.image,height: 250.0,
                  ),
                ),
                Text('MOBIEVENT',style: TextStyle(color: Colors.black,fontSize:30.0,fontWeight: FontWeight.bold),textAlign: TextAlign.center,textScaleFactor: 1.2,),
                Container(
                  margin: EdgeInsets.all(20.0),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.orange.shade900.withOpacity(0.1),
                  ),
                  child:
                  Column(
                    children: <Widget>[
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 50.0, right: 15.0, left: 15.0),
                        child: Text(
                          page.title,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.orange.shade900,
                            decoration: TextDecoration.none,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700,
                            fontFamily: "OpenSans",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(100.0, 0.0, 100.0, 0.0),
                        child: SizedBox(
                            height: 30.0,
                            child: Divider(
                              color: Colors.orange.shade900,
                              thickness: 2.0,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          page.description,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.orange.shade900,
                            decoration: TextDecoration.none,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w300,
                            fontFamily: "OpenSans",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: page.extraWidget,
                      ),
                    ],
                  ),

                )
              ],
            ),
          )
      );
    }
    widgets.add(
        new Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding:
                  const EdgeInsets.only(top: 50.0, right: 15.0, left: 15.0),
                  child: Text(
                    "MOBIEVENT",
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.orange.shade900,
                      decoration: TextDecoration.none,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: "OpenSans",
                    ),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(top: 50.0, right: 15.0, left: 15.0),
                  child: Text(
                    "Welcome!",
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.orange.shade900,
                      decoration: TextDecoration.none,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: "OpenSans",
                    ),
                  ),
                ),
                Image(image: AssetImage("images/one.jpg")),

                FlatButton(
                  padding: EdgeInsets.fromLTRB(120, 20, 120, 20),
                  child: Text('Get Started',textScaleFactor: 1.1,style: TextStyle(fontSize: 20.0),),

                  textColor: Colors.white,

                  onPressed: () {
                    SharedPreferenceData.addBoolFirstScreenSee();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  splashColor: Colors.black12,

                  color: Colors.orange.shade900,
                ),
              ],
            ),
          ),
        )
    );
    return widgets;
  }

}
class WalkThrough {
  ImageProvider image;
  String title;
  String description;
  Widget extraWidget;

  WalkThrough({this.image, this.title, this.description, this.extraWidget}) {
    if (extraWidget == null) {
      extraWidget = new Container();
    }
  }
}