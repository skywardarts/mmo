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
import haxegui.controls.Image;
import haxegui.controls.Label;
import haxegui.events.DragEvent;
import haxegui.events.MoveEvent;
import haxegui.events.ResizeEvent;
import haxegui.managers.StyleManager;
import haxegui.utils.Color;
import haxegui.utils.Opts;
import haxegui.utils.Size;
//}}}

/**
*
* A Dialog to show errors
*
*
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
* @version 0.1
*/
class Alert extends Window
{
	//{{{ Members
	public var icon  : Icon;
	public var label : Label;
	//}}}

	//{{{ Functions
	//{{{ init
	public override function init(opts:Dynamic=null) {
		box = new Size(320,160).toRect();
		type = WindowType.MODAL;

		if(flash.Lib.current.getChildByName("bitmap")==null) {
			var bmpd = new flash.display.BitmapData(this.stage.stageWidth, this.stage.stageHeight);
			bmpd.draw(this.stage);
			bmpd.applyFilter(bmpd, new Rectangle(0,0,this.stage.stageWidth, this.stage.stageHeight), new flash.geom.Point(), new flash.filters.BlurFilter(20, 20, 5));

			var bmp = new flash.display.Bitmap(bmpd);
			bmp.name="bitmap";
			bmp.alpha=0;
			flash.Lib.current.addChild(bmp);

			var t = new feffects.Tween(0,1,500,bmp,"alpha",feffects.easing.Linear.easeNone);
			//t.start();
			haxe.Timer.delay(t.start, 150);
		}
		super.init(opts);

		moveTo(.5*(this.stage.stageWidth-box.width), .5*(this.stage.stageHeight-box.height));
		type = WindowType.MODAL;

		var container = new Container(this);
		container.init();

		label = new haxegui.controls.Label(container);
		label.init({text: Opts.optString(opts, "label", name)});
		label.center();
		label.move(0, -20);

		icon = new Icon(container);
		icon.init({src: Icon.DIALOG_WARNING});
		icon.moveTo(14, label.y-6);

		var button = new haxegui.controls.Button(container);
		button.init({label: "ok"});
		button.center();
		button.move(0, 36);
		button.setAction("mouseClick", "this.getParentWindow().destroy();");

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
	//}}}
}
