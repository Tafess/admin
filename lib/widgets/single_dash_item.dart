import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SingleDashItem extends StatelessWidget {
  final String title, subtitle;
  final void Function()? onPressed;
  const SingleDashItem(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Card(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 24,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 18, color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
