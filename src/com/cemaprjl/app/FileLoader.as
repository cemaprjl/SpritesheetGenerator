/**
 * Created by Mor on 22.05.2016.
 */
package com.cemaprjl.app {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.events.Event;
import flash.filesystem.File;
import flash.geom.Rectangle;
import flash.geom.Rectangle;

public class FileLoader extends Loader {
    public static const READY:String = "com.cemaprjl.app.FileLoader.READY";
    public var file:File;
    private var _bitmap:Bitmap;
    public function FileLoader($file:File) {
        super();
        file = $file;
    }

    public function start():void {
        file.addEventListener(Event.COMPLETE, handleFileLoaded);
        file.load();
    }
    private function handleFileLoaded(e: Event):void {
        file.removeEventListener(Event.COMPLETE, handleFileLoaded);
        contentLoaderInfo.addEventListener(Event.COMPLETE, handleComplete);
        this.loadBytes(file.data);


    }
    private function handleComplete(e: Event):void {
        _bitmap = content as Bitmap;

        dispatchEvent(new Event(READY));
    }

    public function get bd():BitmapData {
        return _bitmap.bitmapData;
    }

    public function get rect():Rectangle {
        if(_bitmap == null)
        {
            return new Rectangle();
        }
        return new Rectangle(0,0,_bitmap.width, _bitmap.height);
    }
}
}
