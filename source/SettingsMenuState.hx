package;

import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.FlxSprite;

class Option {

    public var name:String;
    public var description:String;
    public var data:Dynamic;
    public var type:String;

    public var onAccept:Void->Void;

    public function new(name:String, description:String, ?onAccept:Void->Void) {
        this.name = name;
        this.description = description;
        this.onAccept = onAccept;
    }

    public inline function set(value:Dynamic) {
        this.data = value;
    }
}

class OptionButton extends FlxText {
    public var option:Option;
    
    public var focused:Bool;
    public var accepted:Bool;

    public function new(option:Option) {
        super();
        this.option;
        this.text = option.name;
    }

    public override function update(elapsed:Float) {
        super.update(elapsed);
        if (accepted) {
            accepted = false;
            option.onAccept();
        }
    }
}

class SettingsMenuState extends MusicBeatState {
    
    var optionList:Array<Option>;

    var optionIndex:Int = 0;

    var camFollow:FlxObject;

    var optionDisplayList:FlxTypedGroup<OptionButton>;
    
    public function new() {

        super();

        optionList = [];      
    }

    inline function createBtn(option:Option) {
        //var btn = new OptionButton(option);
        for (opt in 0...optionList.length) {
            var btn:OptionButton = new OptionButton(optionList[opt]);
            btn.size = 24;
            btn.x = 80;
            btn.y = 160 * (opt);
            add(btn);
        }
    }

    public function makeOptions() {
        var DFJK:Option = new Option("DFJK", "Enable or disable DFJK keybinds");
        DFJK.onAccept = function() {
            Prefs.dfjk = !Prefs.dfjk;
            Prefs.save();
        }
        var downscroll:Option = new Option("Downscroll", "Enable or disable downscroll");
        downscroll.onAccept = function() {
            Prefs.downscroll = !Prefs.downscroll;
            Prefs.save();
        }

        var ghostTapping:Option = new Option("Ghost Tapping", "Enable or disable misses if no hittable notes are available on keypress");
        ghostTapping.onAccept = function() {
            Prefs.ghostTapping = !Prefs.ghostTapping;
            Prefs.save();
        }

        var noteSplashes:Option = new Option("Note splashes", "Make a note splash effect on SICK! notes");
        noteSplashes.onAccept = function() {
            Prefs.noteSplashes = !Prefs.noteSplashes;
            Prefs.save();
        }

        optionList = [downscroll, ghostTapping, DFJK, noteSplashes];
    }

    public override function create() {

        optionDisplayList = new FlxTypedGroup<OptionButton>(); 

        add(optionDisplayList);

        camFollow = new FlxObject(0, 0, 1, 1);
        add(camFollow);

        super.create();
    }

    public override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.BACK) {
            switchTo(new MainMenuState());
        }

        if (controls.UP_P) {
            optionIndex--;
            if (optionIndex < 0) {
                optionIndex = optionList.length - 1;
            }
        } else if (controls.DOWN_P) {
            optionIndex++;

            if (optionIndex > optionList.length - 1) {
                optionIndex = 0;
            }
        }
    }

    inline function acceptBool() {
        optionList[optionIndex].data = !optionList[optionIndex].data;
    }

    inline function incrInt() {
        optionList[optionIndex].data++;
    }

    inline function decrInt() {
        optionList[optionIndex].data--;
    }
}

class ControlsSubState extends MusicBeatState{

}