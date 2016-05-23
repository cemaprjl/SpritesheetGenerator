/**
 * Created by Mor on 21.05.2016.
 */
package com.cemaprjl.ui {
import flash.display.Sprite;
import flash.events.MouseEvent;

public class Checkbox extends Sprite {
    private var _check:Sprite;
    private var _isEnabled:Boolean;
    public function Checkbox() {

        graphics.beginFill(0xFFFFFF);
        graphics.lineStyle(1, 0xDDDDDD);
        graphics.drawRect(0,0,20,20);

        _check = new Sprite();
        addChild(_check);
        _check.graphics.lineStyle(4, 0x009900);
        _check.graphics.moveTo(3,7);
        _check.graphics.lineTo(8,17);
        _check.graphics.lineTo(17,3);
        _check.mouseEnabled = false;

        _isEnabled = true;

        buttonMode = true;

        addEventListener(MouseEvent.CLICK, onClick);
    }

    private function onClick(event:MouseEvent):void {
        isEnabled = !_isEnabled;

    }

    public function get isEnabled():Boolean {
        return _isEnabled;
    }

    public function set isEnabled(value:Boolean):void {
        _isEnabled = value;
        _check.visible = _isEnabled;
    }
}
}
