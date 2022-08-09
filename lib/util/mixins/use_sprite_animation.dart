import 'dart:async';
import 'dart:ui';

import 'package:bonfire/base/game_component.dart';
import 'package:bonfire/objects/animated_object_once.dart';
import 'package:bonfire/util/extensions/extensions.dart';
import 'package:flame/components.dart';

///
/// Created by
///
/// ─▄▀─▄▀
/// ──▀──▀
/// █▀▀▀▀▀█▄
/// █░░░░░█─█
/// ▀▄▄▄▄▄▀▀
///
/// Rafaelbarbosatec
/// on 04/02/22
mixin UseSpriteAnimation on GameComponent {
  /// Animation that will be drawn on the screen.
  SpriteAnimation? animation;
  AnimatedObjectOnce? _fastAnimation;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (isVisible) {
      if (_fastAnimation != null) {
        _fastAnimation?.render(canvas);
      } else {
        animation?.getSprite().renderWithOpacity(
              canvas,
              this.position,
              this.size,
              opacity: opacity,
            );
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (this.isVisible) {
      _fastAnimation?.update(dt);
      animation?.update(dt);
    }
  }

  /// Method used to play animation once time
  Future playSpriteAnimationOnce(
    FutureOr<SpriteAnimation> animation, {
    VoidCallback? onFinish,
    VoidCallback? onStart,
  }) async {
    final anim = AnimatedObjectOnce(
      position: position,
      size: size,
      animation: animation,
      onStart: onStart,
      onFinish: () {
        onFinish?.call();
        _fastAnimation = null;
      },
    )
      ..isFlipHorizontal = isFlipHorizontal
      ..isFlipVertical = isFlipVertical
      ..opacity = opacity
      ..gameRef = gameRef;
    await anim.onLoad();
    _fastAnimation = anim;
  }
}
