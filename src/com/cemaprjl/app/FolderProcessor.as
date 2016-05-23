/**
 * Created by Mor on 22.05.2016.
 */
package com.cemaprjl.app {
import com.cemaprjl.util.PNGEncoder;
import com.cemaprjl.util.TextureUtil;

import flash.display.Bitmap;
import flash.display.BitmapData;

import flash.display.BitmapData;
import flash.display.StageQuality;
import flash.events.Event;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.filters.BitmapFilterQuality;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

public class FolderProcessor extends EventDispatcher{

    public static const COMPLETE:String = "com.cemaprjl.app.FolderProcessor.COMPLETE";

    private var _directory:File;
    public var outDir:File;

    private var _loadingStack:Array;
    private var _images:Array;
    private var _rectsMap:Object;

    private var _atlas:BitmapData;

    private var _maxSize:uint = 2048;

    private var _isHD : Boolean = true;
    private var _json:SpritesheetData;

    public function FolderProcessor(dir : File) {

        _directory = dir;

    }

    public function start()
    {
        var files : Array = _directory.getDirectoryListing();
        _loadingStack = [];
        _images = [];
        _rectsMap = {};
        for (var i:int = 0; i < files.length; i++) {
            var file : File = files[i];
            if(file.isDirectory || file.extension != "png")
            {
                continue
            }
            _loadingStack.push(new FileLoader(file));
        }

        _isHD = true;

        loadNextFile();
    }

    private function loadNextFile():void {
        if(_loadingStack.length > 0)
        {
            var fl : FileLoader = _loadingStack.shift();
            fl.addEventListener(FileLoader.READY, onFileReady);
            fl.start();
        }
        else
        {
            calculateSheet();
        }
    }

    private function onFileReady(event:Event):void {

        var fl : FileLoader = event.target as FileLoader;

        var imageVO : ImageVO = new ImageVO();
        imageVO.filename = fl.file.name;
        imageVO.bitmapData = fl.bd;

        _images.push(imageVO);

        _rectsMap[imageVO.filename] = fl.rect;

        loadNextFile();
    }

    private function calculateSheet():void {

        var atlasSize:Rectangle = TextureUtil.packTextures(0, 2, _rectsMap);

        _atlas = new BitmapData(Math.min(_maxSize, atlasSize.width), Math.min(_maxSize, atlasSize.height), true, 0x00000000);

        _json = new SpritesheetData();

        for (var i:int = 0; i < _images.length; i++) {
            var image:ImageVO = _images[i];
            var rect  : Rectangle = _rectsMap[image.filename];

            _json.frames.push(new FrameData(image.filename, rect));

            _atlas.copyPixels(image.bitmapData, new Rectangle(0, 0, rect.width, rect.height), new Point(rect.x, rect.y));
        }

        var fileName : String = "spritesheet";
        var arr : Array = _directory.name.split("__");
        if(arr.length > 1)
        {
            fileName = arr[1];
        }

        var folderName : String = arr[0];

        save(fileName, outDir.nativePath + File.separator + (_isHD ? "hd" : "sd" ) + File.separator + folderName);


//        var l: int = _loadedFiles.length;
//        for (var i = 0; i < l; i++) {
//            var texture: TextureWrapper = _textures[i];
//            var rect: Rectangle = textures[texture.name];
//            if (texture.rect == rect) {
//                _atlas.copyPixels(texture.bd, new Rectangle(0, 0, texture.width, texture.height), new Point(texture.x, texture.y));
////                _atlas.draw(texture.bd, new Matrix(1,0,0,1,rect.x,rect.y));
//                delete textures[texture.name];
//            } else {
//                texture.destroy();
//                _textures.splice(i--, 1);
//                l--;
//            }
//        }

        if(_isHD)
        {
            makeSD();
        }
        else
        {
            dispatchEvent(new Event(FolderProcessor.COMPLETE));
        }



    }

    private function makeSD():void {

        _isHD = false;

        for (var i:int = 0; i < _images.length; i++) {
            var image:ImageVO = _images[i];

            var bmpData : BitmapData = new BitmapData(image.bitmapData.width * 0.5, image.bitmapData.height * 0.5, true,  0x00FFFFFF);
            var mx : Matrix = new Matrix();
            mx.scale(0.5, 0.5);
            bmpData.drawWithQuality(image.bitmapData, mx, null, null, null, true, StageQuality.BEST);

            image.bitmapData = bmpData;
            _rectsMap[image.filename] = new Rectangle(0,0,bmpData.width, bmpData.height);
        }

        calculateSheet();

    }

    public function save(name: String, path: String):void {
        var folder: File = File.applicationStorageDirectory.resolvePath(path);
        if (!folder.exists) {
            folder.createDirectory();
        }

        var stream: FileStream = new FileStream();

        var file: File = folder.resolvePath(name+".png");
        stream.open(file, FileMode.WRITE);
        stream.writeBytes(PNGEncoder.encode(_atlas));
        stream.close();
        _atlas.dispose();
        _atlas = null;

        file = folder.resolvePath(name+".json");
        stream.open(file, FileMode.WRITE);
        stream.writeUTFBytes(JSON.stringify(_json));
        stream.close();
    }



}
}
