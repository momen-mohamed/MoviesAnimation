import 'dart:ui';

import 'package:flutter/material.dart';
import '../model/detail.dart';

final imagesList = [
  "assets/images/goodboys.jpg",
  "assets/images/joker.jpg",
  "assets/images/hustle.jpg"
];

class MoviesPage extends StatefulWidget {
  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  int currentPage = 0;
  PageController _pageController;
  PageController _pageController2;
  bool initial = true;
  double height;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(
      initialPage: currentPage,
      keepPage: true,
      viewportFraction: 0.7,
    );
    _pageController2 = PageController(
      initialPage: currentPage,
      keepPage: true,
      viewportFraction: 1.0,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
    _pageController2.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    // adding listener to first pageController (_pageController) in order to use it to control the position of the page view in the background.
    if (initial) {
      _pageController.addListener(() {
        _pageController2.position.jumpToWithoutSettling(
            _pageController.page * MediaQuery.of(context).size.width);
      });
    }
    initial = false;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            child: PageView.builder(
              pageSnapping: true,
              scrollDirection: Axis.horizontal,
              reverse: false,
              controller: _pageController2,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (ctx, index) {
                return AnimatedBuilder(
                  animation: _pageController2,
                  builder: (ctx, child) {
                    double value = 1;

                    if (_pageController.position.haveDimensions) {
                      // to check if page controller position is available

                      value = _pageController.page -
                          index; // determine the value which will be used to scale and translate page view children
                      value = (1 - value.abs() * 0.8).clamp(0.0,
                          1.0); // clamp is used to maintain value between 0 and 1
                      return Transform.translate(
                        offset: index < _pageController.page
                            ? Offset(450 - value * 450, 0)
                            : Offset(0, 0),
                        child: child,
                      );
                    } else {
                      // this part is executed when the at first time the application launch because position of page view is still not available
                      return Transform.scale(
                        alignment: Alignment.bottomCenter,
                        scale: index == 0 ? value : value * 0.9,
                        child: child,
                      );
                    }
                    return child;
                  },
                  child: Image.asset(
                    imagesList[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
              itemCount: 3,
            ),
          ),
          Container(
            child: PageView.builder(
              itemBuilder: (context, index) {
                return itemBuilder(index);
              },
              controller: _pageController,
              itemCount: 3,
              pageSnapping: true,
              physics: ClampingScrollPhysics(),
            ),
          ),
        ],
      ),
    );
  }

  // cards items at the bottom of the page
  Widget itemBuilder(index) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedBuilder(
        animation: _pageController,
        child: Container(
          margin: index != 2 ? const EdgeInsets.only(right: 10) : null,
          height: height * 0.65,
          child: Material(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            child: LayoutBuilder(
              builder: (ctx, cons) => Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20.0, left: 20, right: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: cons.maxHeight * 0.5,
                        width: double.infinity,
                        child: Image.asset(
                          imagesList[index],
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: cons.maxHeight * 0.02,
                  ),
                  Container(
                    child: Text(
                      detailsList[index].title,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: cons.maxHeight * 0.05,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        categoryShip('Action'),
                        categoryShip('Drama'),
                        categoryShip('History'),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: cons.maxHeight * 0.03,
                  ),
                  ratingBox(detailsList[index].rating),
                  SizedBox(
                    height: cons.maxHeight * 0.07,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      height: cons.maxHeight * 0.07,
                      constraints: BoxConstraints(maxHeight: 40),
                      width: double.infinity,
                      child: RaisedButton(
                        animationDuration: Duration(milliseconds: 800),
                        splashColor: Colors.grey,
                        child: Text(
                          'BUY TICKET',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {},
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        builder: (ctx, child) {
          double value = 1;
          double opacityValue = 1;
          if (_pageController.position.haveDimensions) {
            value = _pageController.page - index;
            value = (1 - value.abs() * 0.1).clamp(0.0, 1.0);
            return Transform.scale(
              alignment: Alignment.bottomCenter,
              scale: value,
              child: child,
            );
          } else {
            return Transform.scale(
              alignment: Alignment.bottomCenter,
              scale: index == 0 ? value : value * 0.9,
              child: child,
            );
          }
        },
      ),
    );
  }

  // the rating part found inside the movie card
  Container ratingBox(int rating) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            '9.0',
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 13),
          ),
          SizedBox(
            width: 5,
          ),
          ratingIcon(rating, 1),
          ratingIcon(rating, 2),
          ratingIcon(rating, 3),
          ratingIcon(rating, 4),
          ratingIcon(rating, 5),
        ],
      ),
    );
  }

  Icon ratingIcon(int rating, int value) {
    return Icon(
      rating >= value ? Icons.star : Icons.star_border,
      size: 16,
      color: rating >= value ? Colors.deepOrange : Colors.grey,
    );
  }

  // rounded rectangle which contains the category of the movie.
  Expanded categoryShip(String title) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          height: 30,
          child: Text(title),
        ),
      ),
    );
  }
}
