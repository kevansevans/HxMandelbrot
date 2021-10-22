package ;

import hxsl.Shader;
import hxsl.Types.Vec;

/**
 * ...
 * @author Kaelan
 */
class MandelbrotShader extends Shader 
{

	public function new() 
	{
		super();
	}
	
	static var SRC = {
		
		@:import h3d.shader.Texture;
		@global var time:Float;
		
		@param var iterations:Int = 100;
		@param var scale:Float = 0.125;
		@param var offsetX:Float = 0;
		@param var offsetY:Float = 0;
		@param var alpha:Int = 0;
		@param var hue:Float = 0;
		
		var c:Vec2;
		var o:Vec2;
		
		function vertex() 
		{
			var factor:Int = 1;
			
			c = input.uv;
			c *= 0.5;
			c -= 0.25;
			c /= scale;
			o = vec2(offsetX, offsetY);
			c += o;
		}
		
		function fragment() 
		{
			
			var z:Vec2 = c;
			var oc:Vec2 = z;
			var threshold = 256.0;
			
			var n:Int = 0;
			
			for (i in 0...iterations)
			{
				var sqrVec = complexSquare(z);
				z = vec2(sqrVec.x + oc.x, sqrVec.y + oc.y);
				
				n++;
				
				if (dot(z, z) > threshold * threshold)
				{
					break;
				}
			}
			
			if (n == iterations) {
				pixelColor = vec4(0, 0, 0, 1);
			} else {
				var brightness:Float = alpha == 1 ? float(n) / float(iterations) : 1;
				var sn:Float = float(n) - log2(log2(dot(z, z))) + 4.0 + hue;
				pixelColor = vec4(hueToRGB(sn % 360, 1.0, 1.0), brightness);
			}
			
			
		}
		
		function complexSquare(_input:Vec2):Vec2
		{
			var x:Float = (_input.x * _input.x) - (_input.y * _input.y);
			var y:Float = 2 * _input.x * _input.y;
			
			return vec2(x, y);
		}
		
		function hueToRGB(_hue:Float, _value:Float, _light:Float):Vec3
		{
			
			var _r:Float = 255;
			var _g:Float = 255;
			var _b:Float = 255;
			
			var v:Float = _value;
			var s:Float = _light;
			
			var h:Float = float((_hue % 360)) / 60;
			if (h < 1) {
				_r = floor(255 * v);
				_g = floor(255 * v * (1 - s * (1 - h)));
				_b = floor(255 * v * (1 - s));
			}
			else if (h < 2)
			{
				_r = floor(255 * v * (1 - s * (h - 1)));
				_g = floor(255 * v);
				_b = floor(255 * v * (1 - s));
			}
			else if (h < 3)
			{
				_r = floor(255 * v * (1 - s));
				_g = floor(255 * v);
				_b = floor(255 * v * (1 - s * (3 - h)));
			}
			else if (h < 4)
			{
				_r = floor(255 * v * (1 - s));
				_g = floor(255 * v * (1 - s * (h - 3)));
				_b = floor(255 * v);
			}
			else if (h < 5)
			{
				_r = floor(255 * v * (1 - s * (5 - h)));
				_g = floor(255 * v * (1 - s));
				_b = floor(255 * v);
			}
			else
			{
				_r = floor(255 * v);
				_g = floor(255 * v * (1 - s));
				_b = floor(255 * v * (1 - s * (h - 5)));
			}
			
			return vec3(_r / 255, _g / 255, _b / 255);
		}
		
	}
	
}