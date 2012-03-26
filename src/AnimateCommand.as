package
{
	import caurina.transitions.Tweener;

	import flash.geom.Point;

	/**
	 * @author jay
	 */
	public class AnimateCommand implements ICommand
	{
		private var warpTool:WarpToolTest;

		public function execute(context:Object):void
		{
			this.warpTool = context as WarpToolTest;

			var time:Number = 1.5;
			if (warpTool.dragPoints[0].x == 0)
			{
				Tweener.addTween(warpTool.dragPoints[0], {x:this.warpTool.startCoords[0].x + 50, y:this.warpTool.startCoords[0].y + 10, time:time, onUpdate:onUpdate});
				Tweener.addTween(warpTool.dragPoints[1], {x:this.warpTool.startCoords[1].x - 50, y:this.warpTool.startCoords[1].y + 10, time:time});
				Tweener.addTween(warpTool.dragPoints[2], {x:this.warpTool.startCoords[2].x - 50, y:this.warpTool.startCoords[2].y - 10, time:time});
				Tweener.addTween(warpTool.dragPoints[3], {x:this.warpTool.startCoords[3].x + 50, y:this.warpTool.startCoords[3].y - 10, time:time});
				Tweener.addTween(warpTool.dragPoints[4], {x:this.warpTool.startCoords[4].x + 0, y:this.warpTool.startCoords[4].y - 50, time:time});
				Tweener.addTween(warpTool.dragPoints[7], {x:this.warpTool.startCoords[7].x + 0, y:this.warpTool.startCoords[7].y + 50, time:time});
				Tweener.addTween(warpTool.dragPoints[5], {x:this.warpTool.startCoords[5].x - 50, y:this.warpTool.startCoords[5].y + 0, time:time});
				Tweener.addTween(warpTool.dragPoints[6], {x:this.warpTool.startCoords[6].x + 50, y:this.warpTool.startCoords[6].y + 0, time:time});
			}
			else
			{
				for (var i:int = 0; i < this.warpTool.startCoords.length; i++)
				{
					var point:Point = this.warpTool.startCoords[i];
					if (i == 0)
						Tweener.addTween(warpTool.dragPoints[i], {x:point.x, y:point.y, time:time, onUpdate:onUpdate});
					else
						Tweener.addTween(warpTool.dragPoints[i], {x:point.x, y:point.y, time:time});
				}
			}
		}

		private function onUpdate():void
		{
			this.warpTool.onMovedDot();
		}
	}
}