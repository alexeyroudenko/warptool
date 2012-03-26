package
{
	import com.alexeyrudenko.tools.WarpTool;
	import com.bit101.components.CheckBox;
	import com.bit101.components.Style;
	import com.bit101.utils.MinimalConfigurator;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.ByteArray;

	[SWF(width="400", height="400", widthPercent="100", heightPercent="100", frameRate="31", backgroundColor="#ffffff")]
	/**
	 * @author jay
	 */
	public class WarpToolTest extends Sprite
	{
		private static const PANEL_HEIGHT:Number = 30;
		[Embed(source="assets/warp_ui.xml", mimeType="application/octet-stream")]
		private var UIXML:Class;
		[Embed(source="assets/image.jpg")]
		protected var Image:Class;
		private var warpTool:WarpTool;
		public var points:Vector.<Point> = new Vector.<Point>;
		public var dragPoints:Vector.<DragPoint> = new Vector.<DragPoint>;
		private var showMesh:Boolean = true;
		private var bitmap:Bitmap;
		private var container:Sprite;
		private var dotsContainer:Sprite;

		public function WarpToolTest()
		{
			this.initUI();
			this.initBitmap();
			this.initTool();
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
		}

		private function initUI():void
		{
			var file:ByteArray = new UIXML();
			var str:String = file.readUTFBytes(file.length);
			var xml:XML = new XML(str);

			Style.setStyle(Style.DARK);

			var config:MinimalConfigurator = new MinimalConfigurator(this);
			config.parseXML(xml);
		}

		private function initBitmap():void
		{
			bitmap = new Image();

			this.container = new Sprite();
			this.addChild(container);

			this.dotsContainer = new Sprite();
			this.addChild(dotsContainer);

			container.x = this.dotsContainer.x = (this.stage.stageWidth - this.bitmap.width) / 2;
			container.y = this.dotsContainer.y = ((this.stage.stageHeight - PANEL_HEIGHT) - this.bitmap.height) / 2 + PANEL_HEIGHT;
		}

		private function initTool():void
		{
			this.warpTool = new WarpTool();
			this.warpTool.setBitmap(bitmap);
			this.warpTool.setContainer(container);
			this.warpTool.setupTriangles();
			this.draw();

			this.createDot(new Point(0, 0));
			this.createDot(new Point(bitmap.width, 0));
			this.createDot(new Point(bitmap.width, bitmap.height));
			this.createDot(new Point(0, bitmap.height));
			
//			this.createDot(new Point(bitmap.width / 2, 0));
//			this.createDot(new Point(0, bitmap.height / 2));
//			this.createDot(new Point(bitmap.width / 2, bitmap.height / 2));

			this.warpTool.setup(points);
		}

		private function createDot(point:Point):void
		{
			this.points.push(point);
			var dot:DragPoint = new DragPoint(point);
			dot.addEventListener(Event.CHANGE, onMovedDot);
			this.dotsContainer.addChild(dot);
			dragPoints.push(dot);
		}

		private function onMovedDot(event:Event = null):void
		{
			trace("onMovedDot");
			var updatePoints:Vector.<Point> = new Vector.<Point>;

			for each (var dragPoint:DragPoint in dragPoints) updatePoints.push(new Point(dragPoint.x + Math.random() * 0.01, dragPoint.y + Math.random() * 0.01));
			this.warpTool.update(updatePoints);
			this.draw();
		}

		private function draw():void
		{
			container.graphics.clear();
			container.graphics.lineStyle(1, 0x000000, this.showMesh ? 1 : 0);
			this.warpTool.render();
			container.graphics.endFill();
		}

		public function onChangeMesh(event:Event):void
		{
			trace("onChangeMesh " + CheckBox(event.target).selected);
			this.showMesh = CheckBox(event.target).selected;
			this.draw();
		}

		public function onChangeDots(event:Event):void
		{
			trace("onChangeDots " + CheckBox(event.target).selected);
			this.dotsContainer.visible = CheckBox(event.target).selected;
			this.draw();
		}
	}
}