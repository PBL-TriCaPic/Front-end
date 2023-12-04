import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void screenTransitionAnimation(BuildContext context, Function screenTransFunc) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    pageBuilder: (context, animation, secondAnimation) {
      return Center(
        child: _LottieAnimation(onAinimCompleted: () {
          // アニメーションを再生する（後述）
          screenTransFunc();
        }),
      );
    },
  );
}

class _LottieAnimation extends StatefulWidget {
  const _LottieAnimation({Key? key, required this.onAinimCompleted})
      : super(key: key);
  final Function onAinimCompleted;

  @override
  State<_LottieAnimation> createState() => _LottieAnimationState();
}

class _LottieAnimationState extends State<_LottieAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  final _audio = AudioPlayer();
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this)
      ..value = 0
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        print(status);
        if (status == AnimationStatus.completed) {
          widget.onAinimCompleted();
        }
      });
    _audio.play(AssetSource('Capsule_digging.mp3'));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: <Widget>[
        const SizedBox(height: 100),
        Lottie.asset(
          'assets/Capsule_Filling_Animation.json',
          controller: _controller,
          onLoaded: (composition) {
            setState(() {
              _controller.duration = composition.duration;
            });
            _controller.forward();
          },
          // backgroundColor パラメータで背景色を指定
          //backgroundColor: Colors.white,
        ),
      ]),
    );
  }
}
