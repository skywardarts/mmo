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
import haxegui.controls.ComboBox;
import haxegui.controls.Image;
import haxegui.controls.Input;
import haxegui.controls.Label;
import haxegui.controls.Tree;
import haxegui.controls.UiList;
import haxegui.events.DragEvent;
import haxegui.events.FileEvent;
import haxegui.events.MoveEvent;
import haxegui.events.ResizeEvent;
import haxegui.events.TreeEvent;
import haxegui.managers.StyleManager;
import haxegui.utils.Align;
import haxegui.utils.Color;
import haxegui.utils.Opts;
import haxegui.utils.Size;
//}}}


using haxegui.controls.Component;


//{{{ FileDialog
/**
* FileDialog window<br/>
*
*
* @author Omer Goshen <gershon@goosemoose.com>
* @author Russell Weir <damonsbane@gmail.com>
* @version 0.1
*/
class FileDialog extends Window {

	public var showHidden : Bool;
	public var useFilter  : Bool;

	public var filter     : EReg;

	public var path		  : String;
	public var file		  : String;

	public var tree 	  : Tree;
	public var pathCombo  : ComboBox;
	public var fileInput  : Input;
	public var ok  		  : Button;


	static var layoutXml = Xml.parse('
	<haxegui:Layout name="FileDialog">
		<haxegui:containers:Container name="Container1" x="10" y="20" left="10" right="0" top="20" bottom="20" fitV="false" fitH="false">
			<haxegui:containers:VDivider name="VDivider">

				<haxegui:containers:ScrollPane name="ScrollPane1">
					<haxegui:controls:Tree/>
				</haxegui:containers:ScrollPane>

				<haxegui:containers:Container name="Container2">
					<haxegui:containers:Container height="40" fitV="false">
						<haxegui:controls:Label text="Directory" top="14" left="10"/>
						<haxegui:controls:ComboBox top="10" left="80" right="10" text="{this.getParentWindow().path}">
						<events>
							<script type="text/hscript" action="onLoaded">
							<![CDATA[
							this.dataSource = new haxegui.DataSource();
							this.dataSource.data = [];
							var dir = this.input.getText().split("/");
							for(i in dir) {
								this.dataSource.data.push(dir.join("/"));
								dir.pop();
							}
							]]>
							</script>
						</events>
						</haxegui:controls:ComboBox>
					</haxegui:containers:Container>

					<haxegui:containers:Container name="Container3" fitV="false" top="40" bottom="80">
						<haxegui:containers:ScrollPane name="ScrollPane2">
							<haxegui:containers:Grid name="Grid3" cellSpacing="1" rows="1" cols="5">
								<haxegui:controls:UiList description="File"/>
								<haxegui:controls:UiList description="Type"/>
								<haxegui:controls:UiList description="Size"/>
								<haxegui:controls:UiList description="Created At"/>
								<haxegui:controls:UiList description="Last Modified"/>
							</haxegui:containers:Grid>
						</haxegui:containers:ScrollPane>
					</haxegui:containers:Container>

				<haxegui:containers:Container name="Container4" fitV="false" left="0" right="0" bottom="0" height="80">
					<haxegui:controls:Label text="File" left="10" top="14" halign="right"/>
					<haxegui:controls:Input text="" name="fileInput" top="10" left="40" right="110"/>
					<haxegui:controls:Button height="24" label="Ok" right="10" top="10"/>

					<haxegui:controls:Label text="Filter" left="10" bottom="12"/>
					<haxegui:controls:ComboBox text="^(.+[^~])$"left="40" bottom="10" right="110">
						<haxegui:DataSource>
							<Array>
								<String>^(.+[^~])$</String>
								<String>^.+\\.(xml)$</String>
								<String>^.+\\.(swf)$</String>
							</Array>
						</haxegui:DataSource>
					</haxegui:controls:ComboBox>
					<haxegui:controls:Button height="24" label="Cancel" right="10" bottom="10"/>
				</haxegui:containers:Container>

				</haxegui:containers:Container>
			</haxegui:containers:VDivider>
		</haxegui:containers:Container>
		<haxegui:windowClasses:StatusBar>
		<!--	<haxegui:controls:ProgressBar progress="50" left="200" right="0"/> -->
		</haxegui:windowClasses:StatusBar>
	</haxegui:Layout>
	').firstElement();

	//{{{ init
	public override function init(?opts:Dynamic=null) {
		box = new Size(720,384).toRect();
		type = WindowType.MODAL;

		super.init(opts);

		path = Opts.optString(opts, "path", path);

		box = new Size(720,384).toRect();

		layoutXml.set("name", name);

		XmlParser.apply(FileDialog.layoutXml, this);

		tree = untyped getChildByName("Container1").getChildByName("VDivider").getChildByName("ScrollPane1").getChildByName("content").getChildAt(0);
		if(path!=null)
		tree.rootNode.expander.label.setText(path.split("/").pop());


		pathCombo = untyped getChildByName("Container1").getChildByName("VDivider").getChildByName("Container2").getChildAt(0).getChildAt(1);
		//pathCombo.input.addEventListener(Event.CHANGE, function(e) trace(e), false, 0, true);

		fileInput = untyped getChildByName("Container1").getChildByName("VDivider").getChildByName("Container2").getChildByName("Container4").getChildByName("fileInput");

		ok = untyped getChildByName("Container1").getChildByName("VDivider").getChildByName("Container2").getChildByName("Container4").getElementsByClass(Button).next();
		//ok.addEventListener(MouseEvent.CLICK, onSelected, false, 0, true);
	}
	//}}}

	public function onSelected(e:MouseEvent) {
		//dispatchEvent(new Event(Event.CHANGE));
	}

	//{{{
	public override function onMouseDoubleClick(e:MouseEvent) {
		if(fileInput!=null && Std.is(e.target, ListItem)) {
		fileInput.setText(e.target.parent.rowData[0]);
		dispatchEvent(new FileEvent(FileEvent.SELECT));
		}

		super.onMouseDoubleClick(e);
		//destroy();
	}
	//}}}
	//{{{
	public override function onMouseClick(e:MouseEvent) {
		if(fileInput!=null && Std.is(e.target, ListItem))
		fileInput.setText(e.target.parent.rowData[0]);

		if(fileInput!=null && e.target==ok)
		dispatchEvent(new FileEvent(FileEvent.SELECT));

		super.onMouseClick(e);

		//destroy();
	}

}
//}}}
