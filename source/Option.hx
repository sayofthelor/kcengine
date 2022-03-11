package;

class Option {
    public var name:String;
    public var description:String;

    public function new(name:String, ?description:String) {
        this.name = name;
        this.description = description;
    }

    public function changeValue(val:Dynamic) {

    }
}

class BoolOption extends Option {

    public var value:Bool;

    public function new(name:String, ?description:String, value:Bool) {
        super(name, description);
        this.value = value;
    }

    public override function changeValue(val:Dynamic) {
        value = !value;
    }
}

class ArrayOption<T> extends Option {

    public var array:Array<T>;
    public var value:T;

    public function new(name:String, ?description:String, value:T, array:Array<T>) {
        super(name, description);
        this.value = value;
        this.array = array;
    }

    public override function changeValue(desiredValue:Dynamic) {
        value = array[desiredValue];
    }
}