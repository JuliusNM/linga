import 'package:flame/sprite.dart';
import 'package:linga/components/fly.dart';
import 'package:linga/linga-game.dart';
import 'dart:ui';

class MachoFly extends Fly {
  MachoFly(LingaGame game, double x, double y) : super(game) {
    flyRect = Rect.fromLTWH(x, y, game.tileSize * 2.025, game.tileSize * 2.025);
    flyingSprite = List();
    flyingSprite.add(Sprite('flies/macho-fly-1.png'));
    flyingSprite.add(Sprite('flies/macho-fly-2.png'));
    deadSprite = Sprite('flies/macho-fly-dead.png');
  }
}