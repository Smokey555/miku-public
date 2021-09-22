package;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxObject;
import flixel.group.FlxSpriteGroup;
import flixel.addons.display.FlxBackdrop;
import flixel.graphics.frames.FlxAtlasFrames;

class MikuBG extends FlxSpriteGroup{

	var velocityArray:Array<Int> = [45,60,30,80,25,100,160,120,140,170,200];

public function new(x:Float, y:Float)
    {
    super(x,y);

    var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG/back'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.1;
		bg.setGraphicSize(Std.int(bg.width * 1.4));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		var bg2:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG/back2'));
		bg2.scrollFactor.x = 0;
		bg2.scrollFactor.y = 0.3;
		bg2.setGraphicSize(Std.int(bg2.width * 1.4));
		bg2.updateHitbox();
		bg2.screenCenter();
		bg2.antialiasing = true;
		add(bg2);

		var bgx:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG/backx'));
		bgx.scrollFactor.x = 0;
		bgx.scrollFactor.y = 0.2;
		bgx.setGraphicSize(Std.int(bgx.width * 1.4));
		bgx.updateHitbox();
		bgx.screenCenter();
		bgx.antialiasing = true;
		add(bgx);
		FlxTween.tween(bgx,{x: bgx.x + 70}, 6,{ease:FlxEase.cubeOut,type:PINGPONG});

		var circle:FlxSprite = new FlxSprite(-10, 500).loadGraphic(Paths.image('menuBG/circles'));
		circle.setGraphicSize(Std.int(circle.width * 1.3));
		circle.screenCenter(Y);
		circle.scrollFactor.x = 0;
		circle.scrollFactor.y = 0.2;
		circle.updateHitbox();
		circle.antialiasing = true;
		add(circle);
		FlxTween.angle(circle,circle.angle,360,20,{type:LOOPING});

		for (i in 0...10){

		var lines:FlxBackdrop = new FlxBackdrop(Paths.image('menuBG/line' + i),0,0,true,false,0,0);
		lines.antialiasing = true;
		lines.screenCenter(Y);
		lines.velocity.x = velocityArray[i];
		add(lines);
		}

        var tr:FlxBackdrop = new FlxBackdrop(Paths.image('menuBG/triangles'),0,0,true,false,0,0);
		tr.antialiasing = true;
		tr.screenCenter(Y);
		tr.velocity.x = 200;
		add(tr);





    }




}