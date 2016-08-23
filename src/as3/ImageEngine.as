package as3{
    import flash.display.Sprite;
    import flash.events.*;
    import flash.net.FileFilter;
    import flash.net.FileReference;
    import flash.net.URLRequest;
	import mx.controls.Alert;

    public class ImageEngine extends Sprite {
        private var uploadURL:URLRequest;
        public var file:FileReference;

        public function ImageEngine() {
            uploadURL = new URLRequest();
            uploadURL.url = "http://www.lecric-mag.com/php/upload.php";
            file = new FileReference();
            configureListeners(file);
            file.browse(new Array(new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png, *.swf)", "*.jpg;*.jpeg;*.gif;*.png;*.swf")));
        }

        private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(Event.SELECT, selectHandler);
        }
        private function cancelHandler(event:Event):void {
            Alert.show("cancelHandler: " + event);
        }
        private function completeHandler(event:Event):void {
        }
        private function uploadCompleteDataHandler(event:DataEvent):void {
            Alert.show("uploadCompleteData: " + event);
			//fileName = file.name;
        }
        private function ioErrorHandler(event:IOErrorEvent):void {
            Alert.show("ioErrorHandler: " + event);
        }
        private function progressHandler(event:ProgressEvent):void {
        }
        private function securityErrorHandler(event:SecurityErrorEvent):void {
            Alert.show("securityErrorHandler: " + event);
        }
        private function selectHandler(event:Event):void {
            var file:FileReference = FileReference(event.target);
			//fileName = file.name;
            file.upload(uploadURL);
        }
    }
}