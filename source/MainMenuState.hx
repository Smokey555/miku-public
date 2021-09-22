package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
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
import flash.display.BitmapData;
import openfl.Assets;


using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;
	var canSelect:Bool = false;
	var menuItems:FlxTypedGroup<FlxSprite>;
	#if !switch
	var optionShit:Array<String> = ['storymode', 'freeplay', 'settings', 'credits'];
	#else
	var optionShit:Array<String> = ['storymode', 'freeplay'];
	#end
	var loadOut:Transition;
	var loadIn:Transition;

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var characters:FlxSprite;

	override function create()
	{

		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		loadIn = new Transition(0,0,'in');
		loadOut = new Transition(0,0,'out');
		loadOut.animation.finishCallback = changeState;
		loadIn.animation.finishCallback = deleteLoadIn;
		loadOut.alpha = 0;
		loadOut.scrollFactor.set(0,0);
		loadIn.scrollFactor.set(0,0);
	

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		var bg:MikuBG = new MikuBG(0,0);
		bg.scrollFactor.set(0,0);
		add(bg);
		
		characters = new FlxSprite();
		characters.frames = Paths.getSparrowAtlas('menuBG/mainmenuCharacters');
		characters.animation.addByPrefix('storymode','storymode',1,true);
		characters.animation.addByPrefix('freeplay','freeplay',1,true);
		characters.animation.addByPrefix('settings','settings',1,true);
		characters.animation.addByPrefix('credits','credits',1,true);
	//	characters.setGraphicSize(Std.int(characters.width * 1.0));
	//	characters.screenCenter();
		characters.antialiasing = true;
		characters.y = -350;
	//	var starting:FloodFill = new FloodFill(100, FlxG.height * .5 - characters.height * .5, characters, characters.width - 20, characters.height,
	//		6, .01);
	//	add(starting);
		add(characters);
		characters.animation.play('storymode');

	//	var mikuBitmapData:BitmapData = Assets.getBitmapData(Paths.image('menuBG/Miku')).clone();
	//	var miku:FloodFill = new FloodFill(100, FlxG.height * .5 - mikuBitmapData.height * .5, mikuBitmapData, mikuBitmapData.width - 20, mikuBitmapData.height,
	//		6, .01);
	//	miku.antialiasing = true;
	//	add(miku);

	//	var miku:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('meekoo'));
	//	miku.scrollFactor.x = 0;
	//	miku.scrollFactor.y = 0.1;
	//	miku.setGraphicSize(Std.int(miku.width * 1.2));
	//	miku.updateHitbox();
	//	miku.screenCenter();
	//	miku.antialiasing = true;
	//	add(miku);

		var bars:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('menuBG/mainmenubars'));
		bars.scrollFactor.set();
		bars.screenCenter(Y);
		bars.updateHitbox();
		bars.antialiasing = true;

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.18;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('menu_shit');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(10 + (i * 40), 90 + (i * 140));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " block", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " select", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.setGraphicSize(Std.int(menuItem.width * 0.6));
			menuItem.updateHitbox();
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
			menuItems.add(menuItem);
			menuItem.x -= 200;
			menuItem.alpha = 0;
			FlxTween.tween(menuItem,{x : menuItem.x + 200,alpha:1},0.6,{ease:FlxEase.smoothStepOut,startDelay: 0.3*i,
				onComplete: function(twn:FlxTween)
				{
				canSelect = true;
				}
			});
			
			
		}
				
		add(bars);
		loadIn.animation.play('transition');
		add(loadIn);
		add(loadOut);
		FlxG.camera.follow(camFollow, null, 0.06);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();
		

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{

		#if debug
		
		if(FlxG.keys.justPressed.END){
		FlxG.switchState(new MikuOptions());
		}
		#end

		menuItems.forEach(function(menuItem:FlxSprite)
		{
		

		if (menuItem.animation.curAnim.name == 'selected')
			{
				menuItem.centerOffsets();
				menuItem.offset.x += 25;
				menuItem.offset.y += 23;
			}

		});

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UP_P && canSelect)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P && canSelect)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.ACCEPT && canSelect) 
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));

				menuItems.forEach(function(spr:FlxSprite)
				{
					if (curSelected != spr.ID)
					{
						FlxTween.tween(spr, {alpha: 0}, 0.4, {
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
							loadOut.alpha = 1;
							loadOut.animation.play('transition');
						});
					}
				});
			}
		}

		super.update(elapsed);

	
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		tweenCharacter();

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
			//	camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}

	function tweenCharacter():Void
	{
		FlxTween.tween(characters,{x : -200, alpha : 0},0.2,{ease:FlxEase.cubeIn,
			onComplete: function(twn:FlxTween)
			{
				characters.animation.play(optionShit[curSelected]);
				FlxTween.tween(characters,{x : -600, alpha : 1},0.2,{ease:FlxEase.cubeOut});
			}
		});
	}

	function changeState(huh:String){
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
			case 'storymode':
				FlxG.switchState(new StoryMenuState());
				trace("Story Menu Selected");
			case 'freeplay':
				FlxG.switchState(new FreeplayState());
				trace("Freeplay Menu Selected");
			case 'settings':
				FlxG.switchState(new MikuOptions());
				trace("Options Menu Selected");
			case 'credits':
				FlxG.switchState(new EndingState());
				trace("Credits Menu Selected");
		}

	}
	function deleteLoadIn(huh:String){
	loadIn.kill();
	}
}