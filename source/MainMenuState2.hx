package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.addons.display.FlxBackdrop;
import io.newgrounds.NG;
import lime.app.Application;

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = ['storymode', 'freeplay', 'settings', 'credits'];
	
	var newGaming:FlxText;
	var newGaming2:FlxText;
	var newInput:Bool = true;

	public static var kadeEngineVer:String = "1.1.3";
	public static var gameVer:String = "0.2.7.1";




	override function create()
	{
		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('back'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		var bg2:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('back2'));
		bg2.scrollFactor.x = 0;
		bg2.scrollFactor.y = 0.16;
		bg2.setGraphicSize(Std.int(bg2.width * 1.1));
		bg2.updateHitbox();
		bg2.screenCenter();
		bg2.antialiasing = true;
		add(bg2);

		var bg2:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('back2'));
		bg2.scrollFactor.x = 0;
		bg2.scrollFactor.y = 0.16;
		bg2.setGraphicSize(Std.int(bg2.width * 1.1));
		bg2.updateHitbox();
		bg2.screenCenter();
		bg2.antialiasing = true;
		add(bg2);

		var bgx:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('backx'));
		bgx.scrollFactor.x = 0;
		bgx.scrollFactor.y = 0.12;
		bgx.setGraphicSize(Std.int(bgx.width * 1.1));
		bgx.updateHitbox();
		bgx.screenCenter();
		bgx.antialiasing = true;
		add(bgx);

		var circle:FlxSprite = new FlxSprite(500, -50).loadGraphic(Paths.image('back'));
		circle.setGraphicSize(Std.int(bg.width * 4.0));
		circle.screenCenter();
		circle.antialiasing = true;
		add(circle);

		var lines:FlxBackdrop = new FlxBackdrop(Paths.image('lines'),0,0,true,false,0,0);
		lines.antialiasing = true;
		lines.screenCenter(Y);
		lines.velocity.x = 45;
		add(lines);




		

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('menu_shit');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(600 - (1200 * i), 60 + (i * 160));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " block", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " select", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.setGraphicSize(Std.int(menuItem.width * 0.7));
			menuItem.updateHitbox();
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
		}

		menuItems.forEach(function(menuItem:FlxSprite){
		menuItem.x -= 400;
		});

		

		

		// NG.core.calls.event.logEvent('swag').send();


		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'mod')
				{
					#if linux
					Sys.command('/usr/bin/xdg-open', ["https://gamebanana.com/gamefiles/17106", "&"]);
					#else
					FlxG.openURL('https://gamebanana.com/gamefiles/17106');
					#end
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

				
					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story mode':
										FlxG.switchState(new StoryMenuState());
										trace("Story Menu Selected");
									case 'freeplay':
										FlxG.switchState(new FreeplayState());

										trace("Freeplay Menu Selected");

									case 'settings':
										FlxG.switchState(new OptionsMenu());

									case 'credits':
										FlxG.switchState(new CreditsMenu());
								}
							});
						}
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');

			}

			spr.updateHitbox();
		});
	}
}
