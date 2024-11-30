package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;
import flixel.addons.display.FlxBackdrop;

class OutdatedSubState extends MusicBeatState
{
	public static var leftState:Bool = false;

	public static var needVer:String = "IDFK LOL";

	public var InExpungedState:Bool = false;

	var bgdrop:FlxBackdrop;

	override function create()
	{
		super.create();
		InExpungedState = FlxG.save.data.exploitationState == 'playing';
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		bgdrop = new FlxBackdrop(Paths.image('ui/checkeredBG', 'preload'), #if (flixel < "5.0.0") 1, 1, true, true, #else XY, #end 1, 1);
		bgdrop.alpha = 0;
		bgdrop.antialiasing = true;
		bgdrop.scrollFactor.set();
		add(bgdrop);
		var txt:FlxText = null;
		if (InExpungedState)
		{
			txt = new FlxText(0, 0, FlxG.width, LanguageManager.getTextString('intoWarningExpunged'), 32);

			FlxG.save.data.exploitationState = null;
			FlxG.save.flush();
		}
		else if (FlxG.save.data.begin_thing)
		{
			txt = new FlxText(0, 0, FlxG.width, LanguageManager.getTextString('introWarningSeen'), 32);
		}
		else
		{
			txt = new FlxText(0, 0, FlxG.width, LanguageManager.getTextString('introWarningFirstPlay'), 32);
		}
		txt.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		txt.antialiasing = true;
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (controls.PAUSE && (FlxG.save.data.begin_thing == true || InExpungedState))
		{
			leaveState();
		}
		if (InExpungedState)
		{
			super.update(elapsed);
			return;
		}
		if (FlxG.keys.justPressed.Y && FlxG.save.data.begin_thing != true || FlxG.keys.justPressed.ENTER && FlxG.save.data.begin_thing != true)
		{
			FlxG.save.data.begin_thing = true;
			FlxG.save.data.eyesores = true;
			leaveState();
		}
		if (FlxG.keys.justPressed.N && FlxG.save.data.begin_thing != true || FlxG.keys.justPressed.ENTER && FlxG.save.data.begin_thing != true)
		{
			FlxG.save.data.begin_thing = true;
			FlxG.save.data.eyesores = false;
			leaveState();
		}
		super.update(elapsed);
	}

	function leaveState()
	{
		if (!FlxG.save.data.alreadyGoneToWarningScreen)
		{
			FlxG.save.data.alreadyGoneToWarningScreen = true;
			FlxG.save.flush();
		}
		leftState = true;
		FlxG.switchState(new MainMenuState());
	}
}
