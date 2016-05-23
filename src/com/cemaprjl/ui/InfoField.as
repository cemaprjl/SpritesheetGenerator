/**
 * Created by Mor on 21.05.2016.
 */
package com.cemaprjl.ui {
import flash.text.TextField;
import flash.text.TextFormat;

public class InfoField extends TextField {
    public function InfoField() {
        super();

        defaultTextFormat = new TextFormat("Arial", 12, 0, null, null, null, null, null);

        border = true;
        borderColor = 0xDDDDDD;
        width = 630;
        height = 20;

        mouseEnabled = false;
        selectable = false;
    }
}
}
