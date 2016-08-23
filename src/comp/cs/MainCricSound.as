import mx.events.*;
import flash.events.*;
import flash.media.Sound;
import flash.media.SoundTransform;
import flash.media.SoundChannel;
import flash.net.URLRequest;
import flash.utils.Timer;

public var url:String;
[Bindable]
private var lab:String = "";
[Bindable]
private var lab2:String = "";
[Bindable]
private var progId3:String = "";
private var snd:Sound = new Sound();
private var request:URLRequest;
private var pausePosition:int = 0;

public var channel:SoundChannel;
public var estimatedLength:int;

// TODO
public var firstTime:Boolean = true;

public function appComplete():void{
	var toolTipDeclaration:CSSStyleDeclaration = StyleManager.getStyleDeclaration("ToolTip");
	toolTipDeclaration.setStyle("backgroundColor", 0xffffff);
	toolTipDeclaration.setStyle("color", 0x333333);
}
public function updateText(event:TimerEvent):void{
	estimatedLength = Math.ceil(snd.length / (snd.bytesLoaded / snd.bytesTotal));
    var playbackPercent:uint = Math.round(100 * (channel.position / estimatedLength));
	var p:Number = Math.round(channel.position/1000);
	var q:Number = Math.ceil((channel.position/1000)/60) -1;
	progId3 = String((q<10) ? "0"+ q : q) +":" + String((p%60 <10) ? "0"+ p%60 : p%60);
	progBar.setProgress(playbackPercent, 100);
}
public function playSound():void{
	if(firstTime){
		request	= new URLRequest(url);
		snd.addEventListener(Event.ID3 ,id3Hand)
		snd.load(request);
		channel = snd.play();
		var minuteTimer:Timer = new Timer(500);
		minuteTimer.addEventListener(TimerEvent.TIMER, updateText);
		minuteTimer.start();
		firstTime = false;
	}else{
		channel = snd.play(pausePosition);
	}
	channel.soundTransform = new SoundTransform(volumeSlider.value/100);
}
public function pauseSound():void{
	if(channel){
		pausePosition = channel.position;
		channel.stop()		
	}
}
public function avanceProgress(e:MouseEvent):void{
	if(channel){
		progBar.setProgress(e.localX, e.currentTarget.width);
		var positionPercent:Number = e.currentTarget.percentComplete;
		channel.stop();
		channel = snd.play(estimatedLength*positionPercent/100);
		channel.soundTransform = new SoundTransform(volumeSlider.value/100);		
	}
}
public function changeVolume(e:SliderEvent):void{
	if(channel){
		channel.soundTransform = new SoundTransform(e.value/100);		
	}
}
public function id3Hand(e:Event):void{
	var id3:ID3Info = snd.id3;
	var str:String;
	if(id3.songName){
		str = id3.songName;
	}else if(id3.artist){
		str = id3.artist;
	}else if(id3.artist && id3.songName){
		str = id3.artist + " - " + id3.songName;
	}else{
		str = url.slice(url.lastIndexOf("/")-1, -4)
	}
	lab = str.slice(0, 28);
	lab2 = str;		
}
public function set song(newValue:String):void {
	url = newValue;
}