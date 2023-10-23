import 'package:flutter/material.dart';
import 'package:street_calle/utils/constant/app_colors.dart';

class CustomButton extends StatefulWidget {
  final String label;
  VoidCallback? onTap;

  CustomButton(this.label, this.onTap, {super.key});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> with SingleTickerProviderStateMixin{

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {

    super.initState();


    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);

    _controller.addListener(() {
      setState(() {});
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });

  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {


    return GestureDetector(
      onTap: () {
        _controller.forward();
        Future.delayed(const Duration(milliseconds: 200), () {
          _controller.reverse();
          widget.onTap?.call();
        });
      },
      child: Transform.scale(
        scale: _scaleAnimation.value,
        child: Container(
          width: double.infinity,
          height: 42,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xff87BCBF),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }


}



class CustomButtonDarkBg extends StatefulWidget {
  final String label;
  VoidCallback? onTap;

  CustomButtonDarkBg(this.label, this.onTap, {super.key});

  @override
  _CustomButtonDarkBgState createState() => _CustomButtonDarkBgState();
}

class _CustomButtonDarkBgState extends State<CustomButtonDarkBg> with SingleTickerProviderStateMixin{

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {

    super.initState();


    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);

    _controller.addListener(() {
      setState(() {});
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });

  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {


    return GestureDetector(
      onTap: () {
        _controller.forward();
        Future.delayed(const Duration(milliseconds: 200), () {
          _controller.reverse();
          widget.onTap?.call();
        });
      },
      child: Transform.scale(
        scale: _scaleAnimation.value,
        child: Container(
          width: double.infinity,
          height: 42,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 4,
            ),
            color: AppColors.textColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }


}
