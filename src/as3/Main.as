import flash.events.* ;
import flash.utils.Timer;
import flash.display.NativeWindow;

import mx.containers.* ;
import mx.core.* ;
import mx.controls.TextArea ;
import mx.controls.TextInput ;
import mx.controls.Alert;
import mx.collections.ArrayCollection;
import mx.managers.CursorManager;
import mx.containers.TitleWindow;
import mx.managers.PopUpManager;
import mx.utils.*;

import as3.Funk;
import as3.PageElements;
import as3.ImageEngine;
import as3.SoundUpload;
import org.swxformat.*;

import air.update.ApplicationUpdaterUI;
import air.update.events.UpdateEvent;
private var appUpdater:ApplicationUpdaterUI = new ApplicationUpdaterUI();

public var squareSize:Number = 10;
public var blockWidth:Number;
public var sp:DisplayObject;
public var tf:TextArea;
public var blocId:Array;
public var NUM:int = 0;
public var tw:TitleWindow = new TitleWindow();
// ****************** Mag and Page ID
public var page:int = 1;
public var mag:int = 2;
[Bindable]
public var pageNums:Array = [{label:0, data:0}];

// ************************************
public function panelClick(ev:MouseEvent):void{
	if(ev.target == ev.currentTarget){
		PageElements.selectedBlock = null ;
	}
}
// ****************** CONNECTION BOX ******************
public function connectBox():void{
	tw.title = "Connect";
	var ti:TextInput = new TextInput();
	ti.displayAsPassword = true;
	ti.percentWidth = 100;
	ti.addEventListener("enter", checkPassword);
	ti.name = "ti";
	ti.setStyle("color", "0x000000")
	var ta:* = tw.addChild(ti);
	PopUpManager.addPopUp(tw, magPanel, true);
	tw.x = 200;
	tw.y = 100;
	tw.width = 200;
	tw.height = 70;
	ta.setFocus();
}
// ****************** UPDATE ******************
private function updateMe():void {
	appUpdater.updateURL = "http://www.lecric-mag.com/updates/update-descriptor.xml";
	appUpdater.addEventListener(UpdateEvent.INITIALIZED, onUpdate);
	appUpdater.addEventListener(ErrorEvent.ERROR, onError);
	appUpdater.initialize();
}
private function onUpdate(event:UpdateEvent):void {
	appUpdater.checkNow();
}
public function onError(e:Event):void{
	Alert.show(e.toString());
}
// ****************** PASSWORD ******************
public function checkPassword(e:Event):void{
	var com7:SWX = Funk.initSWX(checkPassHand);
	var callDetails:Object =	{serviceClass: "CricCon", method: "checkPass", args: [e.currentTarget.text]};
	com7.call(callDetails);
	CursorManager.setBusyCursor();
}
private function checkPassHand(e:Object):void {
	if(e.result == "1"){
		PopUpManager.removePopUp(tw);
		launchApp();
	}else{
		Alert.show("Wrong Password");
	}
	CursorManager.removeBusyCursor();
}
// ****************** APPLICATION MANAGEMENT ******************
public function launchApp():void{
	rte.toolbar.setStyle("verticalGap", 3);
	rte.toolbar.setStyle("horizontalGap", 3);
	rte.setStyle("horizontalAlign", "center");
	rte.colorPicker.setStyle("color", 0x000000);
	rte.colorPicker.selectedColor=0x000000;
	rte.alignButtons.selectedIndex=3;
	setPageMenuNums();
}
public function appClose(event:TimerEvent):void{
	this.stage.nativeWindow.close();
}
public function closeCall() : void{
	PageElements.saveAll();
	var minuteTimer:Timer = new Timer(1000, 2);
	minuteTimer.addEventListener(TimerEvent.TIMER_COMPLETE, appClose);
	minuteTimer.start();
	Alert.show("CricEngine is closing, see you soon ... ")
}
public function showFull(): void{
	stage.displayState = StageDisplayState.FULL_SCREEN;
}
// ****************** SOUND
public function loadSnd(): void{
	CursorManager.setBusyCursor();
	var snd:SoundUpload = new SoundUpload();
	snd.file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadSndHandler);
	snd.file.addEventListener(Event.CANCEL, cancelUplHand);
}
private function cancelUplHand(e:Event):void {
	CursorManager.removeBusyCursor();
}
private function uploadSndHandler(event:DataEvent):void {
	addSnd(event.data)
	CursorManager.removeBusyCursor();
}
public function addSnd(nom:String) : void{
	var num:int = panel.numChildren - 1;
	var peObj:Object = {x:-20, y:60, content: nom, type:"snd", level:num};
	var pof:PageElements = PageElements.sndElement(peObj);
	sp = panel.addChildAt(pof, num);
	sp.x = -20;
	sp.y = 60;

	peObj.width = 0;
	peObj.height = 0;
	PageElements.elementsArr.push(pof);
	PageElements.addBloc(peObj);
}
// ****************** TITLE
public function changeTitleLabel(): void{
	titleTextInput.editable = true;
	validTitleBtn.visible = true;
}
public function saveNewTitle(): void{
	var com6:SWX = Funk.initSWX(updateTitleHand);
	var callDetails:Object =	{serviceClass: "Lecric2", method: "updatePageTitle", args: [escape(StringUtil.trim(titleTextInput.text)), page]};
	com6.call(callDetails);
}
public function updateTitleHand(e:Object): void{
	titleTextInput.editable = false;
	validTitleBtn.visible = false;
	// --- updates datas in comboBox
	pagesMenu.selectedItem.title = e.result;
}
// ****************** PAGES
public function addNewPage(): void{
	var com5:SWX = Funk.initSWX(addNewPageHand);
	var callDetails:Object =	{serviceClass: "Lecric2", method: "addPage", args: [mag]};
	com5.call(callDetails);
}
public function addNewPageHand(e:Object): void{
	// Adds the new page to pageNums Array and to the comboBox
	pageNums.push(e.result);
}
public function setPageMenuNums(): void{
	var com2:SWX = Funk.initSWX(selectPagesHand);
	var callDetails:Object =	{serviceClass: "Lecric2", method: "selectPages", args: [mag]};
	com2.call(callDetails);
}
public function selectPagesHand(e:Object): void{
	pageNums = e.result;
	PageElements.setupBlocs(pageNums[0].data, mag, panel, DEBUG);
	page = pageNums[0].data;
	titleTextInput.text = unescape(pageNums[0].title);
}
public function pageChange(ev:Event): void{
	if(page != ev.target.selectedItem.data){
		PageElements.flushPage();
		page = ev.target.selectedItem.data;
		DEBUG.text += ev.target.selectedItem.data;
		PageElements.setupBlocs(page, mag);
		titleTextInput.text = unescape(ev.target.selectedItem.title);
	}
}
// ****************** COLOR
public function addCol() : void{
	var num:int = panel.numChildren - 1;
	var peObj:Object = {x:-30, y:50, width: 150, height: 150, content: "0xFFFFFF", type:"col", level:num};
	var pof:PageElements = PageElements.colElement(peObj);
	sp = panel.addChildAt(pof, num);
	sp.x = -30;
	sp.y = 50;
	PageElements.elementsArr.push(pof);
	PageElements.addBloc(peObj);
}
// ****************** BACKGROUND
public function loadBgd () : void{
	CursorManager.setBusyCursor();
	var img:ImageEngine = new ImageEngine();
	img.file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,uploadBgdHandler);
	img.file.addEventListener(Event.CANCEL, cancelUplHand);
}
private function uploadBgdHandler(event:DataEvent):void {
	CursorManager.removeBusyCursor();
	addBgd(event.data)
}
public function delBgd() : void{
	if(panel.getChildAt(0).name == "bgd") PageElements.delBloc(panel.getChildAt(0), 1);
}
public function addBgd(nom:String) : void{
	if(panel.getChildAt(0).name == "bgd") PageElements.delBloc(panel.getChildAt(0), 1);
	var peObj:Object = {x:0, y:0, width: 960, height: 540, content: nom, name:"bgd", level:0, id_mag:mag, id_page:page};
	var pof:PageElements = PageElements.bgdElement(peObj);
	sp = panel.addChildAt(pof, 0);
	sp.x = sp.y = 0;

	PageElements.elementsArr.push(pof);
	PageElements.replaceBgd(peObj);
}
// ****************** IMAGES
public function loadImg () : void{
	CursorManager.setBusyCursor();
	var img:ImageEngine = new ImageEngine();
	img.file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,uploadCompleteDataHandler);
	img.file.addEventListener(Event.CANCEL, cancelUplHand);
}
private function uploadCompleteDataHandler(event:DataEvent):void {
	CursorManager.removeBusyCursor();
	addImg(event.data)
	DEBUG.text += event.data;
}
public function addImg(nom:String) : void{
	var num:int = panel.numChildren - 1;
	var peObj:Object = {x:-30, y:60, content: nom, type:"img", level:num};
	var pof:PageElements = PageElements.imgElement(peObj);
	sp = panel.addChildAt(pof, num);
	sp.x = -30;
	sp.y = 60;

	peObj.width = 0;
	peObj.height = 0;
	PageElements.elementsArr.push(pof);
	PageElements.addBloc(peObj);
}
// ****************** TEXT/RTE
public function showRte(num:Number) : void{
	rte.visible = true;
	btnValid.visible = true;

	rte.fontSizeCombo.selectedItem = num ;
	rte.textArea.setStyle("fontSize", num);

	rte.height = 540;
	rte.textArea.height = 440;

	if(num == 11){
		rte.width = 350;
		rte.textArea.width = blockWidth = 290;
	}else if(num == 14){
		rte.width = 350;
		rte.textArea.width = blockWidth = 320;
	}else if(num == 26){
		rte.width = rte.textArea.width = blockWidth = 840;
		rte.height = 145;
		rte.textArea.height = 85;
	}
	rte.width += 4;
}
public function addText(targ:*) : void{
	rte.visible = false;
	btnValid.visible = false;
	if(rte.htmlText){
		var num:int = panel.numChildren - 1;
		var peObj:Object = {x:-20, y:2, width: (rte.height > 270) ? blockWidth : rte.textArea.textWidth + 80, height: rte.textArea.textHeight + 20, content: rte.htmlText, type:"txt", level:num};
		var pof:PageElements = PageElements.textElement(peObj);
		sp = panel.addChildAt(pof, num);
		sp.x = -20;
		sp.y = 40;

		PageElements.elementsArr.push(pof);
		// Send the block in DB
		PageElements.addBloc(peObj);
	}
	rte.htmlText = "";
}
// ****************** ACTION MENU
public function itemClickHandler(e:Object) : void{
	switch(e.index){
		case 0 :
			addNewPage()
			break;
		case 1 :
			loadImg()
			break;
		case 2 :
			addCol()
			break;
		case 3 :
			loadBgd();
			break;
		case 4 :
			delBgd();
			break;
		case 5 :
			loadSnd();
			break;
	}
}