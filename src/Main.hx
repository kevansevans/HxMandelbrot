package;

import h2d.Bitmap;
import h2d.CheckBox;
import h2d.Slider;
import h2d.Tile;
import h2d.col.Point;
import hxd.App;
import h2d.Interactive;
import hxd.Event;

/**
 * ...
 * @author Kaelan
 */
class Main extends App
{
	
	static function main() 
	{
		new Main();
	}
	
	var bitmap:Bitmap;
	var shader:MandelbrotShader;
	var clicky:Interactive;
	var down:Bool = false;
	var point:Point;
	
	public function new()
	{
		super();
	}
	
	
	
	override function init():Void 
	{
		super.init();
		
		if (engine.height > engine.width) {
			bitmap = new Bitmap(Tile.fromColor(0, engine.height, engine.height), s2d);
		} else {
			bitmap = new Bitmap(Tile.fromColor(0, engine.width, engine.width), s2d);
			bitmap.y = -(bitmap.tile.height / 2) + (engine.height / 2);
		}
		
		shader = new MandelbrotShader();
		
		bitmap.addShader(shader);
		
		clicky = new Interactive(engine.width, engine.height, s2d);
		clicky.onWheel = function(e:Event) 
		{
			var oldscale = shader.scale;
			var delta = Math.min(Math.max((shader.scale) * (e.wheelDelta > 0 ? 0.825 : 1.125), 0.01), 100000000000);
			shader.scale = delta;
		}
		
		clicky.onPush = function(e:Event)
		{
			down = true;
			point = new Point(s2d.mouseX, s2d.mouseY);
		}
		
		clicky.onRelease = function(e:Event) 
		{
			down = false;
		}
		
		clicky.onMove = function(e:Event)
		{
			if (down)
			{
				var curPos:Point = new Point(s2d.mouseX, s2d.mouseY);
				
				shader.offsetX -= (curPos.x - point.x) * (1 / engine.width) / shader.scale;
				shader.offsetY -= (curPos.y - point.y) * (1 / engine.height) / shader.scale;
				
				point = new Point(s2d.mouseX, s2d.mouseY);
			}
		}
		
		var iter:h2d.Slider = new h2d.Slider(500, 10, s2d);
		iter.x = iter.y = 10;
		iter.minValue = 1;
		iter.maxValue = 5000;
		iter.value = 100;
		iter.onChange = function()
		{
			shader.iterations = Std.int(iter.value);
		}
		
		var alp:CheckBox = new CheckBox(s2d);
		alp.x = 5;
		alp.y = 30;
		alp.text = "Iterations = Alpha";
		alp.onChange = function()
		{
			if (alp.selected) shader.alpha = 1;
			else shader.alpha = 0;
		}
	}
}