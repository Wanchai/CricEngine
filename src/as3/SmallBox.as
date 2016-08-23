package as3{
	
	import mx.containers.* ;
	
	public class SmallBox extends Box{
		public function SmallBox(squareSize:Number, color:uint){
			this.graphics.beginFill(color);
			this.graphics.lineStyle(1, 0xCCCCCC);
			this.graphics.drawRect(0, 0, squareSize, squareSize);
			this.graphics.endFill();
			buttonMode = true;
		}
	}
}
