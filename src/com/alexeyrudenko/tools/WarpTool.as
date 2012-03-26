package com.alexeyrudenko.tools
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 * @author jay
	 */
	public class WarpTool
	{
		private var size:Number = 10;
		public var moveWeight:Number = 10;
		private var _bitmap:Bitmap;
		private var _container:Sprite;
		private var vertices:Vector.<Number>;
		private var uvtData:Vector.<Number>;
		private var indices:Vector.<int>;
		public var points:Vector.<Point> = new Vector.<Point>;

		public function setupTriangles(size:Number = 10):void
		{
			this.size = size;
			var stepX:Number = _bitmap.width / size;
			var stepY:Number = _bitmap.height / size;

			var step:int = 0;

			vertices = new Vector.<Number>();
			uvtData = new Vector.<Number>();
			indices = new Vector.<int>();

			for (var i:int = 0; i < size; i++)
			{
				for (var j:int = 0; j < size; j++)
				{
					vertices.push(i * stepX, j * stepY, (i + 1) * stepX, j * stepY, (i + 1) * stepX, (j + 1) * stepY, i * stepX, (j + 1) * stepY);
					uvtData.push(i / size, j / size, (i + 1) / size, j / size, (i + 1) / size, (j + 1) / size, i / size, (j + 1) / size);
					indices.push(step + 0, step + 1, step + 3, step + 1, step + 2, step + 3);
					step += 4;
				}
			}
		}

		public function render():void
		{
			_container.graphics.beginBitmapFill(_bitmap.bitmapData);
			_container.graphics.drawTriangles(vertices, indices, uvtData);
			_container.graphics.endFill();
		}

		public function update(updatedPoints:Vector.<Point>):void
		{
			var updatedVertices:Vector.<Number> = new Vector.<Number>();

			for (var i:int = 0;i < vertices.length / 2;i++)
			{
				var moveX:Number = 0;
				var moveY:Number = 0;
				var uvtDataX:Number = uvtData[2 * i];
				var uvtDataY:Number = uvtData[2 * i + 1];

				for (var j:int = 0; j < points.length; j++)
				{
					var point:Point = points[j];
					var updatedPoint:Point = updatedPoints[j];

					// Deltas point from startPosition
					var deltaX:Number = (point.x - updatedPoint.x);
					var deltaY:Number = (point.y - updatedPoint.y);

					// Position of point in 0..1 range
					var movedUvtDataX:Number = (uvtDataX - point.x / _bitmap.width);
					var movedUvtDataY:Number = (uvtDataY - point.y / _bitmap.height);
					var movedUvtData:Number = movedUvtDataX * movedUvtDataX + movedUvtDataY * movedUvtDataY;

					moveX += this.moveFunction(deltaX, movedUvtData);
					moveY += this.moveFunction(deltaY, movedUvtData);
				}

				updatedVertices.push(_bitmap.width * uvtDataX - moveX);
				updatedVertices.push(_bitmap.height * uvtDataY - moveY);
			}

			vertices = updatedVertices;
		}

		private function moveFunction(delta:Number, uvt:Number):Number
		{
			return delta / (uvt * moveWeight + 1);
		}

		public function setBitmap(bitmap:Bitmap):void
		{
			_bitmap = bitmap;
		}

		public function setContainer(container:Sprite):void
		{
			_container = container;
		}

		public function setup(points:Vector.<Point>):void
		{
			this.points = points;
		}
	}
}