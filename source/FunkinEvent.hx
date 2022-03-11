package;

import flixel.FlxSprite;
import flixel.FlxBasic;
class FunkinEvent {

    public var strumTime:Float;
    public var event:String;
    public var eventParams:Array<Dynamic>;

    public function new(strumTime:Float, event:String, eventParams:Array<Dynamic>) {
        this.strumTime = strumTime;
        this.event = event;
        this.eventParams = eventParams;
    }
}

// chart util, also extends note because im fucking retarded
class FunkinEventGraphic extends Note {
    
   public var funkinEvent:FunkinEvent;
    
    public function new(funkinEvent:FunkinEvent) {
        this.funkinEvent = funkinEvent;
        super(funkinEvent.strumTime, -1, null, false, true);
    }
}