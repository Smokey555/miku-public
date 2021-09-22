package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class GameOverSubstate extends MusicBeatSubstate
{
	var bf:Boyfriend;
	var camFollow:FlxObject;
	var daBf:String = '';
	
	var meekoo:FlxSprite;

	var stageSuffix:String = "";

	public function new(x:Float, y:Float)
	{
		var daStage = PlayState.curStage;
		switch (PlayState.SONG.player1)
		{
			case 'bf-pixel':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			case 'bf-voca':
				daBf = 'bf';
			case 'miku':
				stageSuffix = '-miku';
				daBf = 'miku';
			default:
				daBf = 'bf';
		}

		super();

		Conductor.songPosition = 0;

		bf = new Boyfriend(x, y, daBf);
		add(bf);

		if (daBf == 'bf')
		{
		//	var miku:FlxSprite = new FlxSprite(x, y, daBf);
		//	var mikuTex = Paths.getSparrowAtlas('expo/sadmiku');
		//	miku.frames = mikuTex;
		//	miku.animation.addByPrefix('sad', 'miss miku', 24, false);
		//	miku.antialiasing = true;
		//	miku.animation.play('sad');
		//	add(miku);

			new FlxTimer().start(2.0, function(tmr:FlxTimer)
			{
				if (FlxG.random.bool(60))
				{
					FlxG.sound.play(Paths.sound('Cheer4'));
				} else if (FlxG.random.bool(50)) {
					FlxG.sound.play(Paths.sound('Cheer2'));
				} else if (FlxG.random.bool(70)) {
					FlxG.sound.play(Paths.sound('Cheer3'));
				} 
				else
					FlxG.sound.play(Paths.sound('Cheer1'));
			});
		}

		if (daBf == 'miku')
		{
			meekoo = new FlxSprite(x, y, daBf);
			var meekooTex = Paths.getSparrowAtlas('expo/meekooTex');
			meekoo.frames = meekooTex;
		//	meekoo.animation.addByPrefix('happy', 'meekoohapi', 1, false);
			meekoo.animation.addByPrefix('sad', 'meekoo', 1, false);
			meekoo.antialiasing = true;
			meekoo.animation.play('sad');
			add(meekoo);

			FlxTween.tween(meekoo, {alpha: 0}, 0.4, {ease: FlxEase.quartInOut});
			new FlxTimer().start(0.5, function(tmr:FlxTimer)
			{
				meekoo.animation.play('sad');
				meekoo.alpha = 1;
				FlxTween.tween(meekoo, {alpha: 0}, 0.4, {ease: FlxEase.quartInOut});
				new FlxTimer().start(0.85, function(tmr:FlxTimer)
				{
					meekoo.animation.play('sad');
					meekoo.alpha = 1;
					meekoo.animation.play('sad');
				});
			});
		}

		camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y, 1, 1);
		add(camFollow);

		FlxG.sound.play(Paths.sound('fnf_loss_sfx' + stageSuffix));
		Conductor.changeBPM(100);

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();

		if (daBf == 'miku')
		{
			FlxG.camera.target = meekoo;
		} else {
			FlxG.camera.target = null;
		}

		bf.playAnim('firstDeath');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
		{
			endBullshit();
		}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();

			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				FlxG.switchState(new FreeplayState());
			PlayState.loadRep = false;
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
		{
			FlxG.camera.follow(camFollow, LOCKON, 0.01);
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished)
		{
			if (daBf == 'miku')
			{
				meekoo.animation.play('sad');
			}
			FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix));
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	override function beatHit()
	{
		super.beatHit();

		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			bf.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}
	}
}
