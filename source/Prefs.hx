package;

import Controls.KeyboardScheme;
import flixel.FlxG;
class Prefs {
    public static var downscroll:Bool;
    public static var ghostTapping:Bool;
    public static var noteSplashes:Bool;
    public static var keyboardScheme:KeyboardScheme;
    public static var showTimeBar:Bool;
    public static var botplay:Bool;

    public static var data(get, never):String;

    static function get_data() {
        return '
        downscroll:$downscroll\n
        ghosttapping:$ghostTapping\n
        notesplashes:$noteSplashes\n
        keyboardScheme:$keyboardScheme\n
        timebar:$showTimeBar\n
        botplay:$botplay
        ';
    }

    public static function init() {

        FlxG.save.bind('funkin', 'ninjamuffin99');

        downscroll = FlxG.save.data.downscroll;
        ghostTapping = FlxG.save.data.ghostTapping;
        noteSplashes = FlxG.save.data.noteSplashes;
        keyboardScheme = FlxG.save.data.keyboardScheme;
        showTimeBar = FlxG.save.data.showTimeBar;
        botplay = FlxG.save.data.botplay;
    }

    public static function save() {

        trace("saving");

        FlxG.save.data.downscroll = downscroll;
        FlxG.save.data.ghostTapping = ghostTapping;
        FlxG.save.data.noteSplashes = noteSplashes;
        FlxG.save.data.keyboardScheme = keyboardScheme;
        FlxG.save.data.showTimeBar = showTimeBar;
        FlxG.save.data.botplay = botplay;

        FlxG.save.flush();

        trace("saved");
    }

    // public static function testing() {
    //     FlxG.save.data.downscroll = false;
    //     FlxG.save.data.ghostTapping = true;
    //     FlxG.save.data.noteSplashes = true;
    //     FlxG.save.data.keyboardScheme = Solo;
    //     FlxG.save.data.showTimeBar = true;
    //     FlxG.save.data.botplay = false;
    // }
}