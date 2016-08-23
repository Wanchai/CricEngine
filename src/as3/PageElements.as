package as3{
	import mx.containers.* ;
	import mx.core.* ;
	import mx.controls.TextArea ;
	import mx.controls.Image ;
	import mx.controls.Alert;
	import mx.controls.Label;
	import mx.controls.ColorPicker;
	import mx.events.ColorPickerEvent;
	import mx.events.*;
	import mx.managers.CursorManager;
	import flash.events.* ;
	import flash.display.* ;
	import flash.text.StyleSheet;
	import org.swxformat.*;
	import as3.ToolBox;
	import as3.SmallBox;
	import as3.Funk;
	import comp.*;

	public class PageElements extends Canvas{
		/* image.name stores image URL
		/* color.name stores the color
		* id stores DB id
		* name stores type
		*/
		// The root
		public static var panel:Canvas;
		public static var tb:ToolBox;
		public static var sp:PageElements;
		public static var slideOk:Boolean = false;
		// The block who's just been clicked
		public static var selectedBlock:Object;
		public static var DEBUG:TextArea;
		public static var page:int = 1;
		public static var mag:int = 2;
		public static var style:StyleSheet = new StyleSheet();
		// Every elements on the page
		public static var elementsArr:Array = [];
		public var imgName:String;

		public function PageElements(){
			super();
			var a:Object = new Object();
            a.textDecoration = "underline";
            a.color = "#627cff";
			style.setStyle("A", a);
			addEventListener(MouseEvent.CLICK, pickBlock);
		}
		// ****************** CREATE/ADD EACH BLOCK ******************
		// --- Create/Replace the SOUND BLOCK ---
		public static function sndElement(obj:Object):PageElements{
			sp =  new PageElements();
			// --- Allow to see what is not inside the canvas ---
			sp.clipContent = false;
			sp.id = (obj.id) ? obj.id : sp.id;
			sp.name = "snd";

			var snd:CricSound = new CricSound();
			snd.song = Funk.SND_DIR + obj.content;
			snd.name = obj.content;

			sp.addChild(snd);
			// --- Add boxes ---
			setupBoxes(sp);
			return sp;
		}
		// --- Create/Replace the BGD BLOCK ---
		public static function bgdElement(obj:Object):PageElements{
			sp =  new PageElements();
			sp.id = (obj.id) ? obj.id : sp.id;
			sp.name = "bgd";

			var bgd:Image = new Image();
			bgd.source = Funk.IMG_DIR + obj.content;
			bgd.name = obj.content;
			bgd.width = obj.width;
			bgd.height = obj.height;

			sp.addChild(bgd);
			return sp;
		}
		// --- Create/Add each COLOR BLOCK ---
		public static function colElement(obj:Object):PageElements{
			sp =  new PageElements();
			// --- Allow to see what is not inside the canvas ---
			sp.clipContent = false;
			sp.id = (obj.id) ? obj.id : sp.id;
			sp.name = "col";

			var col:Box = new Box();
			col.setStyle("backgroundColor", obj.content);
			col.width= obj.width;
			col.height= obj.height;
			col.name= obj.content;
			col.setStyle("borderThickness", 1);
			col.setStyle("borderStyle", "solid");
			sp.addChild(col);

			var pick:ColorPicker = new ColorPicker();
			pick.showTextField = true;
			pick.selectedColor = 0xFFFFFF;
			pick.addEventListener(ColorPickerEvent.CHANGE, setCol)
			sp.addChild(pick);

			// --- Add boxes ---
			setupBoxes(sp);
			return sp;
		}
		// --- Create/Add each IMAGE BLOCK ---
		public static function imgElement(obj:Object):PageElements{
			sp =  new PageElements();
			// --- Allow to see what is not inside the canvas ---
			sp.clipContent = false;
			sp.id = (obj.id) ? obj.id : sp.id;
			sp.name = "img";

			var img:Image = new Image();
			img.showBusyCursor = true;
			img.source = Funk.IMG_DIR + obj.content;

			img.name = obj.content;
			if (obj.width && obj.width != 0) img.width = obj.width;
			if (obj.height && obj.height != 0) img.height = obj.height;

			sp.addChild(img);
			// --- Add boxes ---
			setupBoxes(sp);
			return sp;
		}
		// --- Create/Add each TEXT BLOCK ---
		public static function textElement(obj:Object):PageElements{
			sp =  new PageElements();
			sp.explicitWidth = obj.width;
			sp.clipContent = false;
			sp.id = (obj.id) ? obj.id : sp.id;
			sp.name = "txt";

			var tf:TextArea = new TextArea();
			tf.percentWidth = 100;
			tf.editable = false;
			tf.verticalScrollPolicy = "off";
			tf.htmlText = obj.content;
			tf.setStyle("paddingLeft", 2);
			tf.setStyle("paddingRight", 2);
			tf.setStyle("backgroundAlpha", (obj.bg_alpha) ? obj.bg_alpha : 0);
			tf.setStyle("backgroundColor", (obj.bg_color) ? obj.bg_color : 0xFFFFFF);
			tf.setStyle("borderColor", (obj.border_color) ? obj.border_color : 0x000000);
			tf.setStyle("borderStyle", (!obj.thickness || obj.thickness == 0) ? "none" : "solid");
			tf.setStyle("borderThickness", obj.thickness);
			tf.height = obj.height;
			sp.addChild(tf);

			// --- Add boxes ---
			setupBoxes(sp);
			return sp;
		}
		public static function changeHand(obj:Object) : void{
			obj.target.validateNow();
			DEBUG.text += "\r " + obj.toString() + " textHeight: " + obj.target.mx_internal::getTextField().textHeight;
		}
		// ****************** SETUP AND FLUSH BLOCKS ******************
		// --- SETUP ---

		public static function setupBlocs(pPage:int, pMag:int, contain:Canvas = null, pDEBUG:* = null) : void{
			page = pPage;
			mag = pMag;
			if(pDEBUG) DEBUG = pDEBUG;
			if(contain) panel = contain;
			// --- select page et mag ---
			var com4:SWX = Funk.initSWX(setupBlocsHand, errorHandler);
			var callDetails:Object =	{serviceClass: "Lecric2", method: "selectBlocs", args: [pPage,pMag]};
			com4.call(callDetails);
			if(tb) panel.removeChild(tb);
			tb = new ToolBox();
			panel.addChild(tb);
			tb.x=880;
		}
		public static function setupBlocsHand(e:Object) : void{
			if(e.result != "0"){
				for (var pip:String in e.result){
					// e.result is an array containing objects. Each object is a DB entry
					var hop:Object = e.result[pip];
					var pof:PageElements;
					if(hop.type == "txt"){
						pof = PageElements.textElement(hop);
					}else if(hop.type == "img"){
						pof = PageElements.imgElement(hop);
					}else if(hop.type == "col"){
						pof = PageElements.colElement(hop);
					}else if(hop.type == "bgd"){
						pof = PageElements.bgdElement(hop);
					}else if(hop.type == "snd"){
						pof = PageElements.sndElement(hop);
					}
					// The DB request send all blocks ordered by level DESC
					var mic:DisplayObject = panel.addChildAt(pof, (panel.getChildAt(0).name == "bgd")? 1 : 0);
					elementsArr.push(pof);
					mic.x = hop.x;
					mic.y = hop.y;
				}
			}
		}
		public static function saveAll(): void{
			if(elementsArr.length > 0){
				for (var pe:String in elementsArr){
					updateBloc(elementsArr[pe]);
				}
			}
		}
		// When you leave the page for another one
		public static function flushPage(): void{
			if(elementsArr.length > 0){
				for (var pe:String in elementsArr){
					//updateBloc(elementsArr[pe])
					panel.removeChild(elementsArr[pe]);
				}
			}
			elementsArr = [];
		}
		// ****************** DATABASE COMMUNICATION FOR BLOCKS ******************
		// --- ADD a new one in DB ---
		public static function addBloc(obj:Object) : void{
			var com2:SWX = Funk.initSWX(addHand, errorHandler);
			var callDetails:Object =	{serviceClass: "Lecric2", method: "addBloc", args: [obj.x, obj.y, obj.width, obj.height, obj.content, page, mag, obj.type, obj.level]};
			com2.call(callDetails);
		}
		public static function addHand(e:Object) : void{
			sp.id = e.result;
			//DEBUG.text += "\r id :" + e.result;
		}
		// --- DELETE ---
		public static function delBlock (e:MouseEvent) : void{
			e.currentTarget.parent.removeEventListener(MouseEvent.CLICK, pickBlock)
			selectedBlock = null;
			DEBUG.text += " Del ";
			delBloc(e.target, 2);
		}
		public static function delBloc(targ:*, num:int) : void{
			if(num == 2) targ = targ.parent;
			targ.parent.removeChild(targ);
			var im:* = targ.getChildAt(0);
			elementsArr.splice(elementsArr.indexOf(targ), 1);
			// ---
			var com3:SWX = Funk.initSWX(delHand, errorHandler);
			var str3:String = "";
			if(targ.name == "img" && targ.name == "bgd" && targ.name == "snd"){
				str3 = im.name;
			}
			var callDetails:Object =	{serviceClass: "Lecric2", method: "delBloc", args: [targ.id, str3, targ.name]};
			com3.call({serviceClass: "Lecric2", method: "delBloc", args: [targ.id, str3, targ.name]});
		}
		public static function delHand(e:Object) : void{
		}
		// --- UPDATE ---
		public static function replaceBgd(obj:Object) : void{
			var com4:SWX = Funk.initSWX(replaceBgdHandler, errorHandler);
			var callDetails:Object = {serviceClass: "Lecric2", method: "replaceBgd", args: [obj]};
			com4.call({serviceClass: "Lecric2", method: "replaceBgd", args: [obj]});
		}
		public static function replaceBgdHandler(e:Object) : void{
			if (e.result != "") sp.id = e.result;
		}
		public static function updateLevels(aa:*, bb:*) : void{
			var swxArr:Array = [];
			swxArr.push({id: aa.id, level: panel.getChildIndex(aa)});
			swxArr.push({id: bb.id, level: panel.getChildIndex(bb)});
			// ---
			var com4:SWX = Funk.initSWX(updateLvlHandler, errorHandler);
			com4.call({serviceClass: "Lecric2", method: "updateLevels", args: [swxArr]});
		}
		public static function updateLvlHandler(e:Object) : void{
			//DEBUG.text += "\r " + e.result;
		}
		public static function updateBloc(mic:*) : void{
			var tfa:* = mic.getChildAt(0);
			var com1:SWX = Funk.initSWX(updateHandler, errorHandler);
			var arr:Array ;
			if (tfa is TextArea){
				tfa.validateNow();
				tfa.height = tfa.mx_internal::getTextField().textHeight + 10;
				arr = [mic.x, mic.y, tfa.width, tfa.height, tfa.htmlText, mic.id, panel.getChildIndex(mic), 
					"0x"+uint(tfa.getStyle("backgroundColor")).toString(16), tfa.getStyle("backgroundAlpha"), "0x"+uint(tfa.getStyle("borderColor")).toString(16), 
					(tfa.getStyle("borderStyle") == "none") ? 0 : tfa.getStyle("borderThickness")];
					
			}else if (tfa is Image){
				arr = [mic.x, mic.y, tfa.contentWidth, tfa.contentHeight,  tfa.name, mic.id, panel.getChildIndex(mic)];
			}else if (tfa is Box){
				arr = [mic.x, mic.y, tfa.width, tfa.height, tfa.name, mic.id, panel.getChildIndex(mic)];
			}else if (tfa is CricSound){
				arr = [mic.x, mic.y, 0, 0, tfa.name, mic.id, panel.getChildIndex(mic)];
			}
			com1.call({serviceClass: "Lecric2", method: "updateBloc", args: arr});
			CursorManager.setBusyCursor();
		}
		public static function updateHandler(e:Object) : void{
			CursorManager.removeBusyCursor();
			if(e.result == 0) Alert.show("Erreur de sauvegarde. Veuillez recommencer")
		}
		// ---
		public static function errorHandler(e:Object) : void{
			DEBUG.text += "Fault : " + e.fault.message.toString()
			DEBUG.text += "Result : " + e.target.toString()
		}
		// ****************** INTERACTIONS ******************
		public static function pickBlock (ev:MouseEvent):void{
			DEBUG.text += "Pick";
			if(selectedBlock) selectedBlock.removeEventListener(KeyboardEvent.KEY_DOWN, keyHandler)
			if (ev.target is UITextField){
				// Edit a textfield when you click on it
				ev.target.parent.editable = true;
			}else if(selectedBlock && selectedBlock.name == "txt"){
				// Cut the focus from the previous block
				selectedBlock.getChildAt(0).editable = false;
				ev.currentTarget.stage.focus = ev.currentTarget;
			}else{
				ev.currentTarget.stage.focus = ev.currentTarget;
			}
			selectedBlock = ev.currentTarget;
			selectedBlock.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler)
			tb.targ = selectedBlock;
		}
		public static function setCol(ev:ColorPickerEvent):void{
			var box:Box = ev.currentTarget.parent.getChildAt(0);
			box.setStyle("backgroundColor", ev.color);
			box.name =  String(ev.color);
			updateBloc(ev.currentTarget.parent);
		}
		// --- KEY HANDLER ---
		public static function keyHandler(ev:KeyboardEvent):void{
			if(selectedBlock){
				if(ev.target is UITextField){
					// Inside the textfield, we don't move the block
				}else{
					// --- UP
					if(ev.keyCode == 38){
						selectedBlock.y -= 1;
					}
					// --- DOWN
					if(ev.keyCode == 40){
						selectedBlock.y += 1;
					}
					// --- LEFT
					if(ev.keyCode == 37){
						selectedBlock.x -= 1;
					}
					// --- RIGHT
					if(ev.keyCode == 39){
						selectedBlock.x += 1;
					}
				}
			}
		}
		// ****************** SMALL BOXES MANAGEMENT ******************
		// --- Dispose Block
		public static function plusBlock (e:MouseEvent) : void{
			var sp:PageElements = e.currentTarget.parent;
			var nextp:DisplayObject;
			if(panel.getChildIndex(sp) < panel.numChildren-3){
				nextp = panel.getChildAt(panel.getChildIndex(sp)+1);
				panel.swapChildren(sp, nextp)
				updateLevels(sp, nextp);
			}
		}
		public static function minusBlock (e:MouseEvent) : void{
			var sp:PageElements = e.currentTarget.parent;
			var nextp:DisplayObject;
			if(panel.getChildIndex(sp) > 1){
				nextp = panel.getChildAt(panel.getChildIndex(sp)-1);
				panel.swapChildren(sp, nextp)
				updateLevels(sp, nextp);
			}
		}
		// --- Slide Block
		public static function slideDown (e:MouseEvent) : void{
			if(e.target.name == "true"){
				e.target.removeEventListener(Event.ENTER_FRAME, slideBlock);
				e.target.name = "false";
				updateBloc(e.target.parent);
			}else{
				e.target.name = "true";
				e.target.addEventListener(Event.ENTER_FRAME, slideBlock)
			}
		}
		public static function slideBlock (e:Event) : void{
			var sp:PageElements = e.target.parent;
			var mic:* = sp.getChildAt(0);
			if (mic is TextArea){
				sp.width = e.target.x = sp.mouseX + 12;
				mic.height = e.target.y = sp.mouseY +12;
			}else{
				mic.width = sp.mouseX + 12;
				mic.height = sp.mouseY +12;
			}
		}
		// --- Move Block
		public static function moveBlock (e:MouseEvent) : void{
			e.target.parent.startDrag();
		}
		public static function stopBlock (e:MouseEvent) : void{
			e.target.parent.stopDrag();
			updateBloc(e.target.parent);
		}
		// --- Add small boxes to the bloc
		public static function setupBoxes(sp:PageElements): void{
			var squareSize:Number = 15;
			// + Box
			var pb:SmallBox = new SmallBox(squareSize, 0xcccccc);
			pb.setStyle("top", -squareSize);
			pb.setStyle("right", squareSize*2 +3);
			pb.addEventListener(MouseEvent.MOUSE_DOWN , plusBlock);
			var tf1:Label = new Label();
			tf1.text = "+";
			tf1.width = 15;
			tf1.mouseChildren= false;
			tf1.buttonMode = true;
			pb.addChild(tf1)
			// - Box
			var mnb:SmallBox = new SmallBox(squareSize, 0xcccccc);
			mnb.setStyle("top", -squareSize);
			mnb.setStyle("right", squareSize);
			mnb.addEventListener(MouseEvent.MOUSE_DOWN , minusBlock);
			var tf2:Label = new Label();
			tf2.text = "--";
			tf2.width = 15;
			tf2.mouseChildren= false;
			tf2.buttonMode = true;
			mnb.addChild(tf2)
			// Move Box
			var mb:SmallBox = new SmallBox(squareSize, 0xffcc00);
			mb.setStyle("top", -squareSize);
			mb.setStyle("left", squareSize + 3);
			mb.addEventListener(MouseEvent.MOUSE_DOWN , moveBlock);
			mb.addEventListener(MouseEvent.MOUSE_UP , stopBlock);
			// Slide Box
			var sb:SmallBox = new SmallBox(squareSize+7, 0x339900);
			sb.setStyle("bottom", squareSize+7);
			sb.setStyle("right", squareSize+7);
			sb.addEventListener(MouseEvent.CLICK , slideDown);
			// Delete Box
			var db:SmallBox = new SmallBox(squareSize, 0xCC0000);
			db.setStyle("top", -squareSize);
			db.setStyle("left",  0);
			db.addEventListener(MouseEvent.CLICK , delBlock);

			sp.addChild(mnb);
			sp.addChild(pb);
			sp.addChild(mb);
			sp.addChild(sb);
			sp.addChild(db);
		}
	}
}
