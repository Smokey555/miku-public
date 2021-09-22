package;

import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.text.FlxTypeText;
import flixel.input.gamepad.FlxGamepad;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.Lib;
import Options;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

class MikuOptions extends MusicBeatState
{
    var optionText:Array<String> = 
    [
    'Toggles downscroll strumlines.',
    'Toggles the accuracy bar.',
    'Toggle counting pressing a directional input when no arrow is there as a miss.',
    'Changes the FPS Limit of the game.',
    'Preloads character bitmapdata for faster startup(Increases RAM usage).',
    'Change the keybinds, press ENTER to change them.'
    ];
    var coolText:FlxTypeText;
    
    var settings:Array<String> = 
    [
    'Downscroll',
    'Accuracy Bar',
    'Ghost Tapping',
    'FPS Limit',
    'Preload Chars',
    'Change Binds'
    ];
    var settingsBlocks:Array<OptionBar> = [];
    var infoBox:FlxSprite;
    var curSelected:Int = 0;
	var loadOut:Transition;
	var loadIn:Transition;
    override function create()
    {
        FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		loadIn = new Transition(0,0,'in');
        loadIn.animation.finishCallback = function(huh:String){
        remove(loadIn);
        };
		loadOut = new Transition(0,0,'out');
		loadOut.alpha = 0;
		loadOut.scrollFactor.set(0,0);
		loadIn.scrollFactor.set(0,0);

        var bg:MikuBG = new MikuBG(0,0);
        add(bg);
        //var test:OptionBar = new OptionBar(20,20,'TEST OPTION','hi');
        //add(test);

        for (i in 0...settings.length)
        {
            var settingsBlock:OptionBar = new OptionBar(64,75 + (100 * i),settings[i]);
            add(settingsBlock);
            settingsBlock.ID = i;
            settingsBlock.alpha = 0;
            settingsBlock.y -= 10;
            FlxTween.tween(settingsBlock,{alpha:1, y : settingsBlock.y + 10},0.3,{ease:FlxEase.smoothStepOut,startDelay: 0.2*i});
            settingsBlocks.push(settingsBlock);
            
            
        }


        var logo:FlxSprite = new FlxSprite(662,-7);
        logo.frames = Paths.getSparrowAtlas('logoBumpin');
        logo.animation.addByPrefix('bump','logo bumpin',24,true);
        logo.setGraphicSize(Std.int(logo.width * 0.65));
        logo.updateHitbox();
        logo.antialiasing = true;
        logo.animation.play('bump');
        add(logo);

        infoBox = new FlxSprite(750,439).loadGraphic(Paths.image('menuBG/textbox'));
        infoBox.antialiasing = true;
        add(infoBox);

        coolText = new FlxTypeText(infoBox.x + 24, infoBox.y + 20, Std.int(infoBox.width),'',30);
        coolText.setFormat(Paths.font('shit.ttf'), 25, FlxColor.fromRGB(65, 77, 77), FlxTextAlign.LEFT, FlxTextBorderStyle.NONE, FlxColor.TRANSPARENT);
        coolText.antialiasing = true;
        add(coolText);
        

        var bars:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('menuBG/settingsbars'));
		bars.scrollFactor.set();
		bars.antialiasing = true;
		add(bars);
        loadIn.animation.play('transition');
        add(loadIn);
        add(loadOut);
        changeSelection();
       
        

    }


    override function update(elapsed:Float){

    super.update(elapsed);


    if (FlxG.keys.justPressed.DOWN)
        changeSelection(1);
    if (FlxG.keys.justPressed.UP)
        changeSelection(-1);
    if (FlxG.keys.justPressed.ESCAPE){
        for (i in 0...settingsBlocks.length)
        FlxTween.tween(settingsBlocks[i],{x: settingsBlocks[i].x - 250},0.3,{ease:FlxEase.smoothStepIn,startDelay: 0.2*i});
        loadOut.alpha = 1;
        loadOut.animation.play('transition');
        loadOut.animation.finishCallback = function(huh:String){FlxG.switchState(new MainMenuState());};
      
      

    }
    for (i in 0...settings.length)
        settingsBlocks[i].optionValue = optionArray()[i];

    if (FlxG.keys.justPressed.LEFT){
        switch settings[curSelected]
            {
            case 'Downscroll':
            FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
            case 'Accuracy Bar':
            FlxG.save.data.accuracyDisplay = !FlxG.save.data.accuracyDisplay;
            case 'Ghost Tapping':
            FlxG.save.data.ghost = !FlxG.save.data.ghost;
            case 'FPS Limit':
            if (FlxG.save.data.fpsCap >= 60)
            FlxG.save.data.fpsCap -= 10;
            case 'Preload Chars':
            FlxG.save.data.cacheImages = !FlxG.save.data.cacheImages;
            }

    }

    if (FlxG.keys.justPressed.RIGHT){
        switch settings[curSelected]
            {
            case 'Downscroll':
            FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
            case 'Accuracy Bar':
            FlxG.save.data.accuracyDisplay = !FlxG.save.data.accuracyDisplay;
            case 'Ghost Tapping':
            FlxG.save.data.ghost = !FlxG.save.data.ghost;
            case 'FPS Limit':
            if (FlxG.save.data.fpsCap <= 270)
            FlxG.save.data.fpsCap += 10;
            case 'Preload Chars':
            FlxG.save.data.cacheImages = !FlxG.save.data.cacheImages;
           }
    }


    if (FlxG.keys.justPressed.ENTER && settings[curSelected] == 'Change Binds')
        openSubState(new KeyBindMenu());
    

    }



    function changeSelection(change:Int = 0):Void{
        FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
        curSelected += change;

		if (curSelected >= settings.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = settings.length - 1;

        coolText.resetText(optionText[curSelected]);
		coolText.start(0.02, true);
        for (i in 0...settingsBlocks.length)
        settingsBlocks[i].isSelected = false;

        settingsBlocks[curSelected].isSelected = true;


      
           





    }

    function optionArray()
    {
    return [FlxG.save.data.downscroll,FlxG.save.data.accuracyDisplay,FlxG.save.data.ghost,FlxG.save.data.fpsCap,FlxG.save.data.cacheImages];
    }

}