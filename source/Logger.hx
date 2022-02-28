package;

import sys.io.File;
import sys.FileSystem;

class Logger {
    
    public var name:String;

    public var path:String;

    public function new(name:String = 'log') {

        this.name = name;

        if (!FileSystem.exists(Paths.txt('log'))) {
            File.saveContent(Paths.txt(name), '');
        }

        this.path = Paths.txt(name.split('/')[name.split('/').length - 1]);
    }

    public function write(data:String) {
        if (File.getContent(path).length == 0) {
            File.saveContent(path, data);
        } else {
            File.saveContent(path, File.getContent(path) + '\n' + data);
        }

        #if debug
        trace('logged ' + data + 'to ' + path);
        #end
    }

    public function clear() {
        if (File.getContent(path).length > 0 && FileSystem.exists(path)) {
            File.saveContent(path, '');
            return true;
        }

        return false;
    }
}