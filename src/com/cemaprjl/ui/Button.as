/**
 * Created by Mor on 21.05.2016.
 */
package com.cemaprjl.ui {
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;

public class Button extends Sprite {
    private var _textfield:TextField;
    public function Button() {

        graphics.beginFill(0xEEEEEE);
        graphics.lineStyle(1, 0xDDDDDD);
        graphics.drawRect(0,0,100,20);

        _textfield = new TextField();
        addChild(_textfield);
        _textfield.selectable = false;
        _textfield.mouseEnabled = false;
        _textfield.defaultTextFormat = new TextFormat("Arial", 10, 0, null, null, true, null, null, "center");
        _textfield.y = 2;

        buttonMode = true;
    }

    public function set text(value:String):void {
        _textfield.text = value;
    }
}
}
