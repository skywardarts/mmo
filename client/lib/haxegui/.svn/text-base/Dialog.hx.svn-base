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


//{{{ Dialog
/**
* Dialog window<br/>
*
*
* @author <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
* @version 0.1
*/
class Dialog extends Window {

	public var container 	: Container;
	public var icon  	 	: Icon;
	public var label 	 	: Label;
	public var buttons   	: Array<Button>;

	static var xml = Xml.parse('
	<haxegui:Layout name="Dialog">
		<haxegui:containers:Container name="Container">
			<haxegui:containers:Grid rows="2" cols="1">
				<haxegui:controls:Label name="Label"/>
				<haxegui:containers:HBox>
					<haxegui:controls:Button label="Ok"/>
					<haxegui:controls:Button label="Canel"/>
				</haxegui:containers:HBox>
			</haxegui:containers:Grid>
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

		XmlParser.apply(Dialog.xml, this);




		moveTo(.5*(this.stage.stageWidth-box.width), .5*(this.stage.stageHeight-box.height));
		type = WindowType.MODAL;

		// container = new Container(this);
		// container.init();
		container = cast this.getChildByName("Container");


		// label = new haxegui.controls.Label(container);
		// label.init({text: Opts.optString(opts, "label", name)});
		label = cast container.asComponent().firstChild().asComponent().firstChild();
		label.text = Opts.optString(opts, "label", name);
		label.align.horizontal = HorizontalAlign.CENTER;
		// label.center();
		// label.move(0, -20);

//		icon = new Icon(container);
//		icon.init({src: Icon.DIALOG_WARNING});
//		icon.moveTo(14, label.y-6);


//		var button = new haxegui.controls.Button(container);
//		button.init({label: "ok"});
//		button.center();
//		button.move(-60, 46);
//		button.setAction("mouseClick", "this.getParentWindow().destroy();");

//		var button = new haxegui.controls.Button(container);
//		button.init({label: "cancel"});
//		button.center();
//		button.move(60, 46);
//		button.setAction("mouseClick", "this.getParentWindow().destroy();");


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
