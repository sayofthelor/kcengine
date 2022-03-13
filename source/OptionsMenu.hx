package;

import openfl.geom.ColorTransform;
import Controls.KeyboardScheme;
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

//todo: json this shit ig
class OptionsMenu extends MusicBeatState
{

	var optionThingy:FlxTypedGroup<FlxText>;
	var daIndex:Int;

	var optionShit:Array<Array<Dynamic>>;

	var curOption:Array<Dynamic>;

	var optionDisplay:FlxText;

	var optionDisplayShit:Array<String>;

	override function create()
	{

		if (FlxG.sound.music == null) {
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.7);	
		}

		daIndex = 0;

		optionShit = [
			// b = Bool
			// a = Array
			["Downscroll", "Toggle if the note arrows\nshould be up or down", Prefs.downscroll, "b"],
			["Ghost Tapping", "Toggle if hitting keys while no note\n is on the arrows count as a miss", Prefs.ghostTapping, "b"],
			["Note Splashes", "Toggle if there should be a notesplash effect\nwhen you hit a SICK", Prefs.noteSplashes, "b"],
			["Show Time Bar", "Toggle if there should be a timebar\nshowing the amount of time left in a song", Prefs.showTimeBar, "b"],
			["Change Keybinds", "Toggle between keybind presets such as DFJK\nor Solo(WASD+ArrowKeys)", Prefs.keyboardScheme, "a"],
			["Botplay", "Toggle if a bot should play as the player", Prefs.botplay, "b"]
		];

		optionDisplayShit = [
			"Downscroll ",
			"Ghost Tapping ",
			"Note Splashes ",
			"Time Bar ",
			"Keybind: ",
			"Botplay "
		];

		generateUI();

		super.create();

		curOption = optionShit[0];
	
		changeSelection(0);
	}

	var schemeIndex:Int = 0;
	var schemeArray:Array<KeyboardScheme> = [Solo, DFJK, AS56, WEOP];

	function generateUI() {
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		// controlsStrings = CoolUtil.coolTextFile(Paths.txt('controls'));
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		optionThingy = new FlxTypedGroup<FlxText>();
		add(optionThingy);
	
		for (i in optionShit) {
			createText(i[0]);
		}

		optionDisplay = new FlxText(FlxG.width - 620, optionThingy.members[2].y, 0, "", 40);
		add(optionDisplay);
		optionDisplay.font = Paths.font('vcr.ttf');
	}

	function createText(text:String) {
		var theText:FlxText = new FlxText(0, optionThingy.length * 40 + 80, 0, text, 40);
		theText.x = 70;
		theText.font = Paths.font('vcr.ttf');
		optionThingy.add(theText);
		return theText;
	}

	var accepted:Bool;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (controls.BACK) {
			legitSave();
			FlxG.switchState(new MainMenuState());
		}

		if (controls.UP_P) {
			changeSelection(-1);
		} else if (controls.DOWN_P) {
			changeSelection(1);
		}

		if (curOption != null)
			acceptShit();

		manageOptionDisplay();
	}

	function manageOptionDisplay() {
		if (curOption[3] == "b") {

			var lePostfix:String = curOption[2] ? "On" : "Off";

			optionDisplay.text = optionDisplayShit[daIndex] + lePostfix;
			return;
		}
		optionDisplay.text = optionDisplayShit[daIndex] + curOption[2];
	}

	var selectedScheme:KeyboardScheme;

	function acceptShit() {
		if (curOption[3] == "b") {
			if (controls.ACCEPT || controls.LEFT_P || controls.RIGHT_P) {
				curOption[2] = !curOption[2];
				//boolOptionShit(curOption[0]);

				trace(curOption[2]);
			}
		} else if (curOption[3] == "a") {
			if (controls.LEFT_P) {
				schemeIndex--;
				if (schemeIndex < 0) {
					schemeIndex = schemeArray.length - 1;
				}
			} else if (controls.RIGHT_P) {
				schemeIndex++;
				if (schemeIndex > schemeArray.length - 1) {
					schemeIndex = 0;
				}
			}

			curOption[2] = schemeArray[schemeIndex];

			
			if (Prefs.keyboardScheme != schemeArray[schemeIndex]) {
				Prefs.keyboardScheme = schemeArray[schemeIndex];
				trace(schemeArray[schemeIndex]);
			}
		}
	}

	function legitSave() {

		trace(optionShit);

		Prefs.downscroll = optionShit[0][2];
		Prefs.ghostTapping = optionShit[1][2];
		Prefs.noteSplashes = optionShit[2][2];
		Prefs.showTimeBar = optionShit[3][2];
		Prefs.keyboardScheme = optionShit[4][2];
		Prefs.botplay = optionShit[5][2];

		Prefs.save();
	}

	function changeSelection(change:Int = 0)
	{
			daIndex += change;

			if (daIndex < 0) {
				daIndex = optionShit.length - 1;
			} else if (daIndex > optionShit.length - 1) {
				daIndex = 0;
			}

			optionThingy.members[daIndex].color = FlxColor.BLUE;

			curOption = optionShit[daIndex];

			for (i in optionThingy.members) {
				if (i != optionThingy.members[daIndex]) {
					i.color = FlxColor.WHITE;
				}
			}
	}
}
