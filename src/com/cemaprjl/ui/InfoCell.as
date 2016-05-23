/**
 * Created by Mor on 21.05.2016.
 */
package com.cemaprjl.ui {
import flash.display.Sprite;
import flash.filesystem.File;

public class InfoCell extends Sprite {
    private var _info:InfoField;
    private var _file:File;
    private var _check:Checkbox;
    public function InfoCell() {
        super();

        _check = new Checkbox();
        addChild(_check);

        _info = new InfoField();
        addChild(_info);
        _info.x = 30;

    }

    public function get isRequiredToGenerate():Boolean {
        return _check.isEnabled;
    }

    public function get folder():File {
        return _file;
    }
    public function set folder(value:File):void {
        _info.text = value.name;
        _file = value;
        _check.isEnabled = _file.name.indexOf("_") != 0;
    }

}
}
