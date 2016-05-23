/**
 * Created by Mor on 23.05.2016.
 */
package com.cemaprjl.app {
import flash.geom.Rectangle;

public class FrameData {


public var filename : String;
public var frame : FrameRect;

    public function FrameData($name : String, $rect : Rectangle)
    {
        filename = $name;
        frame = new FrameRect();
        frame.x = $rect.x;
        frame.y = $rect.y;
        frame.w = $rect.width;
        frame.h = $rect.height;
    }

}
}
