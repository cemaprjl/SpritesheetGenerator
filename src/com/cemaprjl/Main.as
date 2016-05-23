package com.cemaprjl {

import com.cemaprjl.app.FolderProcessor;
import com.cemaprjl.ui.Button;
import com.cemaprjl.ui.InfoCell;
import com.cemaprjl.ui.InfoField;

import flash.display.PNGEncoderOptions;
import flash.display.Sprite;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.geom.Point;
import flash.text.TextField;
import flash.utils.ByteArray;

[SWF(frameRate="60", width="800", height="600")]
public class Main extends Sprite {
    private var _selectInput:Button;
    private var _selectOutput:Button;
    private var _inputPath:InfoField;
    private var _outputPath:InfoField;
    private var _inputDirectory:File;
    private var _outputDirectory:File;
    private var _generate:Button;
    private var _folderContainer:Sprite;
    private var _folders:Array;
    private var _generateStack:Array;
    public function Main() {

        setupApp();
        createWindowContent();


    }

    private function createWindowContent():void {
        _inputPath = new InfoField();
        addChild(_inputPath);
        _inputPath.text = "Select folder...";
        _inputPath.x = 20;
        _inputPath.y = 10;

        _selectInput = new Button();
        _selectInput.text = "Input folder";
        addChild(_selectInput);
        _selectInput.x = 660;
        _selectInput.y = 10;
        _selectInput.addEventListener(MouseEvent.CLICK, selectIn);


        _selectOutput = new Button();
        _selectOutput.text = "Output folder";
        addChild(_selectOutput);
        _selectOutput.x = 660;
        _selectOutput.y = 40;
        _selectOutput.addEventListener(MouseEvent.CLICK, selectOut);

        _outputPath = new InfoField();
        addChild(_outputPath);
        _outputPath.text = "Select folder...";
        _outputPath.x = 20;
        _outputPath.y = 40;


        _generate = new Button();
        _generate.text = "GENERATE!";
        addChild(_generate);
        _generate.x = 350;
        _generate.y = 70;
        _generate.addEventListener(MouseEvent.CLICK, generate);

        _folderContainer = new Sprite();
        addChild(_folderContainer);
        _folderContainer.x = 20;
        _folderContainer.y = 100;

    }

    private function generate(event:MouseEvent):void {

        if(!_inputDirectory || !_outputDirectory)
        {
            trace("select both folders");
            return;
        }

        _generateStack = [];

        for (var i:int = 0; i < _folders.length; i++) {
            var cell:InfoCell = _folders[i];
            var folder : File = cell.folder;
            if(folder != null && cell.isRequiredToGenerate)
            {
                var fp : FolderProcessor = new FolderProcessor(folder);
                fp.outDir = _outputDirectory;
                _generateStack.push(fp);
            }
        }

        processFolder();
    }

    private function processFolder():void {

        if(_generateStack == null || _generateStack.length == 0)
        {
            trace("JOB DONE");
            return;
        }
        var processor : FolderProcessor = _generateStack.shift();
        processor.addEventListener(FolderProcessor.COMPLETE, onFolderComplete);
        processor.start();
    }

    private function onFolderComplete(event:Event):void {

        (event.target as FolderProcessor).removeEventListener(FolderProcessor.COMPLETE, onFolderComplete);

        processFolder();

    }


    private function selectOut(event:MouseEvent):void {
        var f : File = new File;
        f.addEventListener(Event.SELECT, onOutSelected);
        f.browseForDirectory("Choose a directory");
    }

    private function selectIn(event:MouseEvent):void {

        var f : File = new File;
        f.addEventListener(Event.SELECT, onInSelected);
        f.browseForDirectory("Choose a directory");

    }

    private function onInSelected(event:Event):void {

        _inputDirectory = event.target as File;
        _inputPath.text = _inputDirectory.nativePath;

        _folderContainer.removeChildren();

        var filesArr : Array = _inputDirectory.getDirectoryListing();

        _folders = [];

        for (var i:int = 0; i < filesArr.length; i++) {
            var file:File = filesArr[i];
            if(!file.isDirectory)
            {
                continue;
            }
            var ifield : InfoCell = new InfoCell();
            ifield.y = _folderContainer.numChildren * 20;
            _folderContainer.addChild(ifield);
            ifield.folder = file;
            _folders.push(ifield);
        }

    }
    private function onOutSelected(event:Event):void {

        _outputDirectory = event.target as File;
        _outputPath.text = _outputDirectory.nativePath;
    }

    private function setupApp():void {
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        stage.nativeWindow.minSize = new Point(800,600);
        stage.nativeWindow.maxSize = new Point(800,600);
    }
}
}
