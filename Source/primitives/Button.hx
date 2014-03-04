package primitives;

import flash.geom.Point;
import flash.events.MouseEvent;
import flash.display.BitmapData;
import flash.utils.Function;
import flash.display.Bitmap;
import flash.display.Sprite;
import openfl.Assets;

class Button extends Sprite {

	private var _image:Bitmap;
	private var _callback:Function;

    public function new(imageURL:String, callback:Function):Void {

	    super();

	    _image = new Bitmap(Assets.getBitmapData(imageURL, true));
	    addChild(_image);

	    _callback = callback;

	    addEventListener(MouseEvent.CLICK, _callback);
    }

	//TODO: Learn how to do getters and setters
	public function setOriginX(newOriginX:Float):Void {
		_image.x -= newOriginX;
	}

	public function getOriginX():Float {
		return _image.x;
	}

	public function setOriginY(newOriginY:Float):Void {
		_image.y -= newOriginY;
	}

	public function getOriginY():Float {
		return _image.y;
	}

	public function cleanUp():Void {
		removeEventListener(MouseEvent.CLICK, _callback);
		_callback = null;
	}
}
