import 'package:flutter/material.dart';
import 'package:montoring_app/styles.dart';

class EditCard extends StatelessWidget {
  final String title;
  final String img;

  const EditCard({super.key, required this.title, required this.img});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      width: 150,
      height: 150,
      decoration: BoxDecoration(
          color: CustomColors.secondaryColor,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              Icon(
                Icons.edit,
                color: Colors.white,
              )
            ],
          ),
          Flexible(child: Image.asset(img))
        ],
      ),
    );
  }
}
