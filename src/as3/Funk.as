package as3{

	import org.swxformat. *;

	public class Funk{
		public static var IMG_DIR:String = "http://www.lecric-mag.com/mag2/img/"
		public static var SND_DIR:String = "http://www.lecric-mag.com/mag2/snd/"

		public function Funk(){
			//super();
		}
		public static function initSWX(Hand:Function, faultHandler:Function = null) : SWX{
			var swx : SWX = new SWX ();
			swx.gateway = "http://www.lecric-mag.com/swxphp/php/swx.php";
			swx.encoding = "POST";
			swx.timeout = 10;
			swx.debug = true;
			swx.resultHandler = Hand;
			if (faultHandler != null) swx.faultHandler= faultHandler;
			return swx;
		}
	}
}