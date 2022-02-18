package;

import flixel.FlxG;

class Prefs {
    public static var downscroll:Bool;
    public static var ghostTapping:Bool;
    public static var noteSplashes:Bool;
    public static var dfjk:Bool;
    public static var showTimeBar:Bool;

    public static function init() {

        downscroll = FlxG.save.data.downscroll;
        ghostTapping = FlxG.save.data.ghostTapping;
        noteSplashes = FlxG.save.data.noteSplashes;
        dfjk = FlxG.save.data.dfjk;
        showTimeBar = FlxG.save.data.showTimeBar;
    }

    public static function save() {
        FlxG.save.data.downscroll = downscroll;
        FlxG.save.data.ghostTapping = ghostTapping;
        FlxG.save.data.noteSplashes = noteSplashes;
        FlxG.save.data.dfjk = dfjk;
        FlxG.save.data.showTimeBar = showTimeBar;
    }

    public static function testing() {
        FlxG.save.data.downscroll = false;
        FlxG.save.data.ghostTapping = true;
        FlxG.save.data.noteSplashes = true;
        FlxG.save.data.dfjk = false;
        FlxG.save.data.showTimeBar = true;
    }
}