package as3{
	import mx.containers.* ;
	import mx.controls.*;
	import flash.events.* ;
	import flash.display.* ;
	import mx.controls.ColorPicker;
	import mx.events.ColorPickerEvent;
	import mx.events.NumericStepperEvent;

	public class ToolBox extends Box {

		public var _targ : *;
		public var type : String;
		public var lb1:Label = new Label();
		public var lb2:Label = new Label();
		public var lb3:Label = new Label();
		public var clr1:ColorPicker = new ColorPicker();
		public var clr2:ColorPicker = new ColorPicker();
		public var btn1:Button = new Button();
		public var btn2:Button = new Button();
		
		public var ns:NumericStepper = new NumericStepper();
		
		private var box:*;

		public function ToolBox (){
			setStyle("backgroundColor", 0x000000);
			setStyle("backgroundAlpha", 1);
			setStyle("paddingTop", 2);
			setStyle("paddingBottom", 2);
			setStyle("paddingLeft", 2);
			setStyle("paddingRight", 2);
			
			lb1.text = "BackGround"
			lb2.text = "Line"
			lb3.text = "Thickness"
			
			clr1.addEventListener(ColorPickerEvent.CHANGE, setCol)
			clr2.addEventListener(ColorPickerEvent.CHANGE, setLine)
			
			btn1.label = btn2.label = "x";
			
			btn1.addEventListener(MouseEvent.MOUSE_DOWN, removeBgColor)
			btn2.addEventListener(MouseEvent.MOUSE_DOWN, removeLineColor)
			
			ns.addEventListener(NumericStepperEvent.CHANGE, changeLine)
			
			addChild(lb1)
			var bx1:HBox = new HBox()
			addChild(bx1)
			
			bx1.addChild(clr1)
			bx1.addChild(btn1)
			
			addChild(lb2)
			var bx2:HBox = new HBox()
			addChild(bx2)
			
			bx2.addChild(clr2)
			bx2.addChild(btn2)
			
			
			addChild(lb3)
			addChild(ns)
			
			addEventListener(MouseEvent.MOUSE_DOWN , moveBox);
			addEventListener(MouseEvent.MOUSE_UP , stopBox);
			//visible = false;
		}
		public function set targ(newValue:Object):void {
			_targ = newValue;
			type = newValue.name;
		}
		private function setCol(ev:ColorPickerEvent):void{
			if(type == "txt"){
				box = _targ.getChildAt(0);
				box.setStyle("backgroundAlpha", 1);
				box.setStyle("backgroundColor", ev.color);
			}
			if(type == "col"){
				box = ev.currentTarget.parent.getChildAt(0);
				box.setStyle("backgroundColor", ev.color);
				box.name =  String(ev.color);			
			}
			dispatchEvent(new Event("done"));
		}
		private function setLine(ev:ColorPickerEvent):void{
			if(type == "txt"){
				box = _targ.getChildAt(0);
				box.setStyle("borderColor", ev.color);
				box.setStyle("borderStyle", "solid");
			}
		}
		// ------ EVENTS 
		private function changeLine (e:NumericStepperEvent) : void{
			if(type == "txt"){
				box = _targ.getChildAt(0);
				box.setStyle("borderThickness", e.value);
				box.setStyle("borderStyle", "solid");
			}			
		}
		private function removeLineColor (e:MouseEvent) : void{
			if(type == "txt"){
				box = _targ.getChildAt(0);
				box.setStyle("borderStyle", "none");
			}
		}
		private function removeBgColor (e:MouseEvent) : void{
			if(type == "txt"){
				box = _targ.getChildAt(0);
				box.setStyle("backgroundAlpha", 0);
			}
		}
		private function moveBox (e:MouseEvent) : void{
			e.currentTarget.startDrag();
		}
		private function stopBox (e:MouseEvent) : void{
			e.currentTarget.stopDrag();
		}
	}
}