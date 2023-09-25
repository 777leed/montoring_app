import 'package:flutter/material.dart';

class categorieButton extends StatefulWidget {
  final String text;
  final Icon icon;
  final Color color;
  final Function onTap;
  const categorieButton(
      {super.key,
      required this.text,
      required this.icon,
      required this.color,
      required this.onTap});

  @override
  State<categorieButton> createState() => _categorieButtonState();
}

class _categorieButtonState extends State<categorieButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            widget.onTap();
          },
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8),
            width: 150,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
                color: widget.color),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(widget.text,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.white)),
                widget.icon
              ],
            ),
          ),
        ),
      ],
    );
  }
}
