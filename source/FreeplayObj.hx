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

class FreeplayObj extends FlxSpriteGroup
{
    public var isSelected:Bool = false;
    public var song:String;
    public var score:Int;
    var bg:FlxSprite;
    var songText:FlxText;
    var scoreText:FlxText;
    var stars:Array<FlxSprite>;
    public function new(x:Float,y:Float,_song:String){
    
        super();
    song = _song;
    bg = new FlxSprite(x,y);
    bg.antialiasing = true;
    bg.frames = Paths.getSparrowAtlas('menuBG/freeplaybricks');
    bg.animation.addByPrefix('normal','freeplay brick',24,true);
    bg.animation.addByPrefix('selected','freeplaybrick select',24,true);
    bg.animation.play('idle');
    bg.setGraphicSize(Std.int(bg.width * 0.8));
    bg.updateHitbox();
    add(bg);

    songText = new FlxText(0, 0,0,'',40);
    songText.setPosition(bg.x + 115, bg.y + 9);
    songText.setFormat(Paths.font('funkin.ttf'), 36, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK);
    songText.font = 'Funkin';
    songText.antialiasing = true;
    songText.bold = true;
    songText.borderQuality = 1;
    songText.text = song;
    add(songText);
    
    scoreText = new FlxText(0,0,0,'',40);
    scoreText.setFormat(Paths.font('funkin'), 29, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK);
    scoreText.setPosition(songText.x + 10, songText.y + 40);
    scoreText.font = 'Funkin';
    scoreText.antialiasing = true;
    scoreText.borderQuality = 1;
    add(scoreText);

    }
    
    override function update(elapsed:Float){


        if (isSelected){
            bg.animation.play('selected');
            bg.offset.x = 160;
            bg.offset.y = 80;
        }
            
        else{
            bg.animation.play('normal');
            bg.offset.x = 94.5;
            bg.offset.y = 21.95;
            
            
        }
        scoreText.text = 'Highscore: ' + score;
        
    super.update(elapsed);
    
    }

    public function getY():Float{
        return bg.getMidpoint().y;
    }
    public function getX():Float{
        return bg.getMidpoint().x;
    }

    public function getSong():String{
        return song;
    }
   
    

}


















































