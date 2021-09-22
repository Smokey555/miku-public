package;

import flixel.group.FlxGroup.FlxTypedGroup;
import FreeplayState.SongMetadata;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;



class OptionBar extends FlxSpriteGroup{

    //This shit so sexy it's gettin' more pussy than half of the FNF community on god
    var bg:FlxSprite;
    var option:String;
    var optionValueText:FlxText;
    var optionText:FlxText;
    public var optionValue:Dynamic;
    public var isSelected:Bool = false;

public function new(x:Float,y:Float,_option:String)
    {
    super();
    option = _option;


    bg = new FlxSprite(x,y);
    bg.frames = Paths.getSparrowAtlas('menuBG/options_bricks');
    if (option == 'Change Binds'){
    bg.animation.addByPrefix('normal','keybindbrick0',24,true);
    bg.animation.addByPrefix('selected','keybindbrick select0',24,true);
    }
    else{
    bg.animation.addByPrefix('normal','settings_brick0',24,true);
    bg.animation.addByPrefix('selected','settings_brick select0',24,true);
    }
    bg.antialiasing = true;
    add(bg);


    optionText = new FlxText(0, 0,0,'',40);
    optionText.setPosition(bg.x + 37, bg.y + 20);
    optionText.setFormat(Paths.font('shit.ttf'), 38, FlxColor.fromRGB(65, 77, 77), FlxTextAlign.CENTER, FlxTextBorderStyle.NONE, FlxColor.TRANSPARENT);
    optionText.bold = true;
    optionText.borderQuality = 1;
    optionText.text = option;
    optionText.antialiasing = true;
    add(optionText);

    optionValueText = new FlxText(0,0,0,'',40);
    optionValueText.setPosition(optionText.x + 415, optionText.y);
    optionValueText.setFormat(Paths.font('shit.ttf'), 38, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.NONE, FlxColor.TRANSPARENT);
    optionValueText.bold = true;
    optionValueText.borderQuality = 1;
    optionValueText.antialiasing = true;
    add(optionValueText);
    }


    

    override function update(elapsed:Float)
    {

        super.update(elapsed);

     
        optionValueText.text = optionValue;
        //change text
        switch (optionValueText.text){
        case 'true':
        optionValueText.text = 'ON';
        case 'false':
        optionValueText.text = 'OFF';   
        } 
      
        if (isSelected){
            bg.animation.play('selected');
            bg.offset.x = 44;
            bg.offset.y = 40;
        }   
        else{
            bg.animation.play('normal');
            bg.centerOffsets();    
        }


        







    }

}