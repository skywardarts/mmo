// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

package haxegui;


//{{{ Imports
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import haxegui.Window;
import haxegui.containers.Container;
import haxegui.controls.Button;
import haxegui.controls.Image;
import haxegui.controls.Label;
import haxegui.events.DragEvent;
import haxegui.events.MoveEvent;
import haxegui.events.ResizeEvent;
import haxegui.managers.StyleManager;
import haxegui.utils.Align;
import haxegui.utils.Color;
import haxegui.utils.Opts;
import haxegui.utils.Size;
//}}}


using haxegui.controls.Component;


//{{{ FindDialog
/**
* FindDialog window<br/>
*
*
* @author <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
* @version 0.1
*/
class FindDialog extends Window {

	public var container 	: Container;

	static var xml = Xml.parse('
	<haxegui:Layout name="FindDialog">
		<haxegui:containers:Container name="Container">
				<haxegui:containers:Container name="Container2" left="0" top="0" bottom="0" right="110">
					<haxegui:controls:Label x="8" y="2" text="Find"/>
					<haxegui:controls:Input y="20" left="10" right="110"/>
					<haxegui:controls:Label x="8" y="22" text="Replace"/>
					<haxegui:controls:Input y="60" left="10" right="110"/>
					<haxegui:containers:Grid x="10" y="90" cols="1" rows="3">
					<haxegui:controls:RadioButton/>
					<haxegui:controls:RadioButton/>
					<haxegui:controls:RadioButton/>
					</haxegui:containers:Grid>
					</haxegui:containers:Container>
				<haxegui:containers:Container name="Container3" width="90" top="10" bottom="10" right="10" fitH="false" fitV="false" >
					<haxegui:containers:Grid cols="1" rows="3">
						<haxegui:controls:Button label="Next"/>
						<haxegui:controls:Button label="Prev"/>
						<haxegui:controls:Button label="Close"/>
					</haxegui:containers:Grid>
				</haxegui:containers:Container>
		</haxegui:containers:Container>
	</haxegui:Layout>
	').firstElement();

	//{{{ init
	public override function init(?opts:Dynamic=null) {
		box = new Size(320,160).toRect();
		type = WindowType.MODAL;
/*
		if(flash.Lib.current.getChildByName("bitmap")==null) {
			var bmpd = new flash.display.BitmapData(this.stage.stageWidth, this.stage.stageHeight);
			bmpd.draw(this.stage);
			bmpd.applyFilter(bmpd,
			new Rectangle(0,0,this.stage.stageWidth, this.stage.stageHeight),
			new flash.geom.Point(),
			new flash.filters.BlurFilter(20, 20, 5));

			var bmp = new flash.display.Bitmap(bmpd);
			bmp.name="bitmap";
			bmp.alpha=0;
			flash.Lib.current.addChild(bmp);


			var t = new feffects.Tween(0,1,500,bmp,"alpha",feffects.easing.Linear.easeNone);
			//t.start();
			haxe.Timer.delay(t.start, 150);
		}
*/
		super.init(opts);


		xml.set("name", name);

		// xml.elementsNamed("haxegui:controls:Label").next().set("text", name);

		XmlParser.apply(FindDialog.xml, this);




		moveTo(.5*(this.stage.stageWidth-box.width), .5*(this.stage.stageHeight-box.height));
		type = WindowType.MODAL;

		// container = new Container(this);
		// container.init();
		container = cast this.getChildByName("Container");



		this.toFront();
	}
	//}}}


	//{{{ destroy
	public override function destroy() {
	if(flash.Lib.current.getChildByName("bitmap")!=null)
		flash.Lib.current.removeChild(flash.Lib.current.getChildByName("bitmap"));
		super.destroy();
	}
	//}}}
}
//}}}
