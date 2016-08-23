package as3{
    import flash.display.Sprite;
    import flash.events.*;
    import flash.net.FileFilter;
    import flash.net.FileReference;
    import flash.net.URLRequest;
	
	import mx.controls.Alert;

    public class SoundUpload extends Sprite {
        private var uploadURL:URLRequest;
        public var file:FileReference;

        public function SoundUpload() {
            uploadURL = new URLRequest();
            uploadURL.url = "http://www.lecric-mag.com/php/uploadSound.php";
            file = new FileReference();
			file.addEventListener(Event.SELECT, selectHandler);
			file.addEventListener(Event.COMPLETE, completeHandler);
            file.browse(new Array(new FileFilter("Son (*.mp3)", "*.mp3")));
        }

        private function completeHandler(event:Event):void {
			//Alert.show(event.result);
        }
        private function selectHandler(event:Event):void {
            var file:FileReference = FileReference(event.target);
            file.upload(uploadURL);
        }
    }
}