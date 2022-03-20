package;

import flixel.group.FlxGroup;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.display.FlxExtendedSprite;
import flixel.FlxSprite;

class FunkinStage extends FlxGroup {
    
    public var background:FlxTypedGroup<FunkinSprite>;
    public var midground:FlxTypedGroup<FunkinSprite>;
    public var foreground:FlxTypedGroup<FunkinSprite>;

    var bf:Boyfriend;
    var gf:Character;
    var opponent:Character;

    public function new() {
        super();
        background = new FlxTypedGroup<FunkinSprite>();
        midground = new FlxTypedGroup<FunkinSprite>();
        foreground = new FlxTypedGroup<FunkinSprite>();

        add(background);
        add(midground);
        add(foreground);
    }

    function getByTag(layer:FlxTypedGroup<FunkinSprite>, tag:String) {
        for (i in layer) {
            if (i.tag == tag)
                return i;
        }
        return null;
    }
}

class FunkinSprite extends FlxSprite {
    
    public var tag:String;
    public var parent:FunkinSprite;
    public var children:Array<FunkinSprite>;
    
    public function new(x:Float = 0, y:Float = 0, ?tag:String) {
        super(x, y);
        this.tag = tag;
        children = new Array<FunkinSprite>();
    }

    public override function update(elapsed:Float) {
        super.update(elapsed);
    }

    public function addChild(sprite:FunkinSprite) {
        children.push(sprite);
        sprite.parent = this;
    }

    public function setParent(sprite:FunkinSprite) {
        parent = sprite;
        sprite.children.push(this);
    }
}