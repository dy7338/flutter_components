import 'dart:math';
import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  //评分
  final double rating;

  //满分
  final double maxRating;

  //星星要显示的个数
  final int count;

  //星星大小
  final double size;

  //星星的颜色
  final Color unSelectColor;
  final Widget unSelectImage;
  final Color selectColor;
  final Widget selectImage;

  //图标？
  // final Icon icon;

  StarRating({
    super.key,
    this.rating = 0,
    this.maxRating = 10,
    this.count = 5,
    this.size = 25,
    this.unSelectColor = Colors.grey,
    this.selectColor = Colors.red,
    Widget? unSelectImage,
    Widget? selectImage,
  })  : unSelectImage = unSelectImage ??
      Icon(Icons.star_border, size: size, color: unSelectColor),
        selectImage =
            selectImage ?? Icon(Icons.star, size: size, color: selectColor);

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildChildren(buildUnSelectIcon),
        buildChildren(buildSelectIcon),
      ],
    );
  }

  //抽取build
  Widget buildChildren(Function fun) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: fun(),
    );
  }

  //创建未选中的
  List<Widget> buildUnSelectIcon() {
    return List.generate(widget.count, (index) {
      return widget.unSelectImage;
    });
  }

  //选中的
  List<Widget> buildSelectIcon() {
    List<Widget> result = [];

    final star = widget.selectImage;

    //先看有几个满分的
    // 一个星占几分
    double oneStarValue = widget.maxRating / widget.count;
    int fullCount = min((widget.rating / oneStarValue).floor(), widget.count);
    for (var i = 0; i < fullCount; i++) {
      result.add(star);
    }

    if (widget.rating < widget.maxRating) {
      //小数部分有多少
      double leftWidth =
          ((widget.rating / oneStarValue) - fullCount) * widget.size;
      result.add(ClipRect(
        clipper: ClipStar(leftWidth),
        child: star,
      ));
    }

    return result;
  }
}

//自定义矩形裁剪
class ClipStar extends CustomClipper<Rect> {
  double width;

  ClipStar(this.width);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, width, size.height);
  }

  @override
  bool shouldReclip(ClipStar oldClipper) {
    return oldClipper.width != width;
  }
}
