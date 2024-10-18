import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomerCard extends StatelessWidget {
  final String text;
  final String title;
  final String? image;
  final String action;

  const CustomerCard({
    super.key,
    required this.title,
    required this.text,
    required this.action,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).colorScheme.primary,
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 10),
                      blurRadius: 99,
                      spreadRadius: 2,
                      color: const Color(0xFF31C967).withOpacity(0.5),
                    ),
                  ],
                ),
                child: Text(
                  action,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ],
          ),
          // Check if image is not null or empty
          if (image != null && image!.isNotEmpty)
            Image.asset(
              image!,
              height: 50,
              width: 50,
            )
          else
            Container(), // Empty container if no image is provided
        ],
      ),
    );
  }
}
