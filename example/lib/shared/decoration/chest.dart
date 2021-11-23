import 'package:bonfire/bonfire.dart';
import 'package:bonfire/util/vector2rect.dart';
import 'package:example/manual_map/dungeon_map.dart';
import 'package:example/shared/decoration/potion_life.dart';
import 'package:example/shared/util/common_sprite_sheet.dart';
import 'package:flutter/widgets.dart';

class Chest extends GameDecoration with TapGesture {
  bool _observedPlayer = false;

  late TextPaint _textConfig;
  Chest(Vector2 position)
      : super.withAnimation(
          CommonSpriteSheet.chestAnimated,
          width: DungeonMap.tileSize * 0.6,
          height: DungeonMap.tileSize * 0.6,
          position: position,
        ) {
    _textConfig = TextPaint(
      style: TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: width / 2,
      ),
    );
  }

  @override
  void update(double dt) {
    if (gameRef.player != null) {
      this.seeComponent(
        gameRef.player!,
        observed: (player) {
          if (!_observedPlayer) {
            _observedPlayer = true;
            _showEmote();
          }
        },
        notObserved: () {
          _observedPlayer = false;
        },
        radiusVision: DungeonMap.tileSize,
      );
    }
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (_observedPlayer) {
      _textConfig.render(
        canvas,
        'Touch me !!',
        Vector2(position.left - width / 1.5, position.center.dy - (height + 5)),
      );
    }
  }

  @override
  void onTap() {
    if (_observedPlayer) {
      _addPotions();
      removeFromParent();
    }
  }

  @override
  void onTapCancel() {}

  void _addPotions() {
    gameRef.add(
      PotionLife(
        Vector2(
          position.translate(width * 2, 0).left,
          position.top - height * 2,
        ),
        30,
      ),
    );

    gameRef.add(
      PotionLife(
        Vector2(
          position.translate(width * 2, 0).left,
          position.top + height * 2,
        ),
        30,
      ),
    );

    _addSmokeExplosion(position.translate(width * 2, 0));
    _addSmokeExplosion(position.translate(width * 2, height * 2));
  }

  void _addSmokeExplosion(Vector2Rect position) {
    gameRef.add(
      AnimatedObjectOnce(
        animation: CommonSpriteSheet.smokeExplosion,
        position: position,
      ),
    );
  }

  void _showEmote() {
    gameRef.add(
      AnimatedFollowerObject(
        animation: CommonSpriteSheet.emote,
        target: this,
        positionFromTarget: Rect.fromLTWH(18, -6, 16, 16).toVector2Rect(),
      ),
    );
  }

  @override
  void onTapDown(int pointer, Offset position) {}

  @override
  void onTapUp(int pointer, Offset position) {}
}
