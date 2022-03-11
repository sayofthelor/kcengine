package;

import Controls.KeyboardScheme;
import Character.CharacterManager;
import openfl.filters.ShaderFilter;
import ColorBlindEffect.ColorBlindnessType;
import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;

class MusicBeatState extends FlxUIState
{

	public static var saveInitted:Bool = false;

	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls(get, never):Controls;

	public var colorBlindnessEffect:ColorBlindEffect;

	public static var playerSettingsInnitted:Bool = false;

	inline function get_controls():Controls {
		if (Prefs.keyboardScheme == KeyboardScheme.DFJK)
		PlayerSettings.player1.controls.setKeyboardScheme(DFJK);
		else
			PlayerSettings.player1.setKeyboardScheme(Solo);
		return PlayerSettings.player1.controls;
	}

	public function new() {
		if (!saveInitted) {
			saveInitted = true;
			Prefs.testing();
			Prefs.init();
			trace('initted player prefs');
		}

		if (!playerSettingsInnitted) {
			PlayerSettings.init();
			playerSettingsInnitted = true;
		}
		super();
	}

	override function create() {
		if (transIn != null)
			trace('reg ' + transIn.region);

		super.create();

		colorBlindnessEffect = new ColorBlindEffect(NONE);
		
		if (colorBlindnessEffect.shader.blindnessType.value[0] != NONE) {
			FlxG.camera.setFilters([new ShaderFilter(colorBlindnessEffect.shader)]);
			FlxG.cameras.cameraAdded.add((cam) -> {
				cam.setFilters([new ShaderFilter(colorBlindnessEffect.shader)]);
			});
		}
	}

	override function update(elapsed:Float)
	{

		

		//everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep && curStep > 0)
			stepHit();

		super.update(elapsed);
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
	}

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		//do literally nothing dumbass
	}
}
