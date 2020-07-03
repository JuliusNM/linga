import 'package:flame/sprite.dart';
import 'package:linga/components/fly.dart';
import 'package:linga/linga-game.dart';
import 'dart:ui';

class HungryFly extends Fly {
  HungryFly(LingaGame game, double x, double y) : super(game) {
    flyRect = Rect.fromLTWH(x, y, game.tileSize * 1.65, game.tileSize * 1.65);
    flyingSprite = List();
    flyingSprite.add(Sprite('flies/hungry-fly-1.png'));
    flyingSprite.add(Sprite('flies/hungry-fly-2.png'));
    deadSprite = Sprite('flies/hungry-fly-dead.png');
  }
}