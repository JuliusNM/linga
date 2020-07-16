import 'dart:ui';
import 'package:flame/game/base_game.dart';
import 'package:flame/gestures.dart';
import 'package:linga/linga-game.dart';
import 'package:flame/sprite.dart';
import 'package:linga/view.dart';
import 'package:linga/components/callout.dart';
import 'package:flame/flame.dart';

class Fly extends BaseGame with TapDetector {
  final LingaGame game;
  Rect flyRect;
  bool isDead = false;
  bool isOffScreen = false;
  List<Sprite> flyingSprite;
  Sprite deadSprite;
  double flyingSpriteIndex = 0;
  double get speed => game.tileSize * 2;
  Offset targetLocation;
  Callout callout;

  Fly(this.game) {
    setTargetLocation();
    callout = Callout(this);
  }

  void render(Canvas c) {
    if (isDead) {
      deadSprite.renderRect(c, flyRect.inflate(2));
    } else {
      if (game.activeView == View.playing) {
        callout.render(c);
      }
      flyingSprite[flyingSpriteIndex.toInt()].renderRect(c, flyRect.inflate(2));
    }
  }

  void update(double t) {
    if (isDead) {
      flyRect = flyRect.translate(0, game.tileSize * 12 * t);
      if (flyRect.top > game.screenSize.height) {
        isOffScreen = true;
      }
    } else {
      callout.update(t);
      flyingSpriteIndex += 30 * t;
      if (flyingSpriteIndex >= 2) {
        flyingSpriteIndex -= 2;
      }
      double stepDistance = speed * t;
      Offset toTarget = targetLocation - Offset(flyRect.left, flyRect.top);
      if (stepDistance < toTarget.distance) {
        Offset stepToTarget =
            Offset.fromDirection(toTarget.direction, stepDistance);
        flyRect = flyRect.shift(stepToTarget);
      } else {
        flyRect = flyRect.shift(toTarget);
        setTargetLocation();
      }
    }
  }

  void setTargetLocation() {
    double x = game.rnd.nextDouble() *
        (game.screenSize.width - (game.tileSize * 2.025));
    double y = game.rnd.nextDouble() *
        (game.screenSize.height - (game.tileSize * 2.025));
    targetLocation = Offset(x, y);
  }

  @override
  void onTapDown(details) {
    if (!isDead) {
      Flame.audio
          .play('sfx/ouch' + (game.rnd.nextInt(11) + 1).toString() + '.ogg');
      isDead = true;

      if (game.activeView == View.playing) {
        game.score += 1;
        if (game.score > (game.storage.getInt('highscore') ?? 0)) {
          game.storage.setInt('highscore', game.score);
          game.highscoreDisplay.updateHighscore();
        }
      }
    }
    if (game.soundButton.isEnabled) {
      Flame.audio
          .play('sfx/ouch' + (game.rnd.nextInt(11) + 1).toString() + '.ogg');
    }
  }
}
