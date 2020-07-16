import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/gestures.dart';
import 'package:linga/components/fly.dart';
import 'dart:math';
import 'package:linga/components/backyard.dart';
import 'package:linga/components/house-fly.dart';
import 'package:linga/components/agile-fly.dart';
import 'package:linga/components/drooler-fly.dart';
import 'package:linga/components/hungry-fly.dart';
import 'package:linga/components/macho-fly.dart';
import 'package:linga/components/start-button.dart';
import 'package:linga/view.dart';
import 'package:linga/views/home-view.dart';
import 'package:linga/views/lost-view.dart';
import 'package:linga/controllers/spawner.dart';
import 'package:linga/components/credits-button.dart';
import 'package:linga/components/help-button.dart';
import 'package:linga/views/help-view.dart';
import 'package:linga/views/credits-view.dart';
import 'package:linga/components/score-display.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:linga/components/highscore-display.dart';
import 'package:linga/components/music-button.dart';
import 'package:linga/components/sound-button.dart';

class LingaGame extends BaseGame with TapDetector {
  Size screenSize;
  double tileSize;
  List<Fly> flies;
  Random rnd;
  Backyard background;
  View activeView = View.home;
  HomeView homeView;
  StartButton startButton;
  LostView lostView;
  FlySpawner spawner;
  HelpButton helpButton;
  CreditsButton creditsButton;
  HelpView helpView;
  CreditsView creditsView;
  ScoreDisplay scoreDisplay;
  HighscoreDisplay highscoreDisplay;
  MusicButton musicButton;
  SoundButton soundButton;

  int score;
  final SharedPreferences storage;

  LingaGame(this.storage) {
    initialize();
  }

  void initialize() async {
    flies = List<Fly>();
    rnd = Random();
    resize(await Flame.util.initialDimensions());
    background = Backyard(this);
    homeView = HomeView(this);
    startButton = StartButton(this);
    lostView = LostView(this);
    spawner = FlySpawner(this);
    helpButton = HelpButton(this);
    creditsButton = CreditsButton(this);
    helpView = HelpView(this);
    creditsView = CreditsView(this);
    scoreDisplay = ScoreDisplay(this);
    highscoreDisplay = HighscoreDisplay(this);
    musicButton = MusicButton(this);
    soundButton = SoundButton(this);
    score = 0;
  }

  void spawnFly() {
    double x = rnd.nextDouble() * (screenSize.width - (tileSize * 2.025));
    double y = rnd.nextDouble() * (screenSize.height - (tileSize * 2.025));
    switch (rnd.nextInt(5)) {
      case 0:
        flies.add(HouseFly(this, x, y));
        break;
      case 1:
        flies.add(DroolerFly(this, x, y));
        break;
      case 2:
        flies.add(AgileFly(this, x, y));
        break;
      case 3:
        flies.add(MachoFly(this, x, y));
        break;
      case 4:
        flies.add(HungryFly(this, x, y));
        break;
    }
  }

  void render(Canvas canvas) {
    background.render(canvas);
    highscoreDisplay.render(canvas);
    if (activeView == View.playing) scoreDisplay.render(canvas);
    flies.forEach((Fly fly) => fly.render(canvas));
    if (activeView == View.home) homeView.render(canvas);
    if (activeView == View.home || activeView == View.lost) {
      startButton.render(canvas);
      helpButton.render(canvas);
      creditsButton.render(canvas);
    }
    if (activeView == View.lost) lostView.render(canvas);
    musicButton.render(canvas);
    soundButton.render(canvas);
    if (activeView == View.help) helpView.render(canvas);
    if (activeView == View.credits) creditsView.render(canvas);
  }

  void update(double t) {
    flies.forEach((Fly fly) => fly.update(t));
    flies.removeWhere((Fly fly) => fly.isOffScreen);
    spawner.update(t);
    if (activeView == View.playing) scoreDisplay.update(t);
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
  }

  @override
  void onTapDown(details) {
    bool isHandled = false;
    if (!isHandled && startButton.rect.contains(details.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        startButton.onTapDown();
        isHandled = true;
      }
    }
    if (!isHandled) {
      bool didHitAFly = false;

      flies.forEach((Fly fly) {
        if (fly.flyRect.contains(details.globalPosition)) {
          fly.onTapDown(details);
          isHandled = true;
          didHitAFly = true;
        }
      });
      if (activeView == View.playing && !didHitAFly) {
        activeView = View.lost;
      }
    }
    flies.forEach((Fly fly) {
      if (fly.flyRect.contains(details.globalPosition)) {
        fly.onTapDown(details);
      }
    });
    // help button
    if (!isHandled && helpButton.rect.contains(details.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        helpButton.onTapDown();
        isHandled = true;
      }
    }

    // credits button
    if (!isHandled && creditsButton.rect.contains(details.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        creditsButton.onTapDown();
        isHandled = true;
      }
    }

    if (!isHandled) {
      if (activeView == View.help || activeView == View.credits) {
        activeView = View.home;
        isHandled = true;
      }
    }
//     music button
    if (!isHandled && musicButton.rect.contains(details.globalPosition)) {
      musicButton.onTapDown();
      isHandled = true;
    }

    // sound button
    if (!isHandled && soundButton.rect.contains(details.globalPosition)) {
      soundButton.onTapDown();
      isHandled = true;
    }
  }
}
