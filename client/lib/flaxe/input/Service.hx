package flaxe.input;

class Service extends flaxe.ServiceBase
{
	public var change_event:flaxe.Event;
	public var key_down_event:flaxe.Event;
	public var key_up_event:flaxe.Event;
	public var button_down_event:flaxe.Event;
	public var button_up_event:flaxe.Event;
	public var scroll_event:flaxe.Event;
	
	private var state:flaxe.input.KeyState;
	private var key_code_list:flash.Vector<String>;
	private var changed:Bool;
	
	public function new(application:flaxe.Application)
	{
		super();
		
		this.change_event = new flaxe.Event();
		this.key_down_event = new flaxe.Event();
		this.key_up_event = new flaxe.Event();
		this.button_down_event = new flaxe.Event();
		this.button_up_event = new flaxe.Event();
		this.scroll_event = new flaxe.Event();
		
		this.state = new flaxe.input.KeyState();
		
		this.changed = true;
		
		application.get_layer().mouseChildren = false;
		
		// wait until the application is loaded before initializing
		application.load_event.add(this.initialize);
	}
	
	public function initialize(application:flaxe.Application):Void
	{
		application.deactivate_event.add(this.clear, []);
		
		this.initialize_key_code_list();
	}

	public function initialize_key_code_list():Void
	{
		this.key_code_list = new flash.Vector<String>(256, true);
		
		this.key_code_list[flaxe.input.KeyCode.None] = "none";
		this.key_code_list[flaxe.input.KeyCode.Back] = "Back";
		this.key_code_list[flaxe.input.KeyCode.Tab] = "Tab";
		this.key_code_list[flaxe.input.KeyCode.Enter] = "Enter";
		this.key_code_list[flaxe.input.KeyCode.Pause] = "Pause";
		this.key_code_list[flaxe.input.KeyCode.CapsLock] = "Caps Lock";
		this.key_code_list[flaxe.input.KeyCode.Escape] = "Escape";
		this.key_code_list[flaxe.input.KeyCode.Space] = "Space";
		this.key_code_list[flaxe.input.KeyCode.PageUp] = "Page Up";
		this.key_code_list[flaxe.input.KeyCode.PageDown] = "Page Down";
		this.key_code_list[flaxe.input.KeyCode.End] = "End";
		this.key_code_list[flaxe.input.KeyCode.Home] = "Home";
		this.key_code_list[flaxe.input.KeyCode.Left] = "Left";
		this.key_code_list[flaxe.input.KeyCode.Up] = "Up";
		this.key_code_list[flaxe.input.KeyCode.Right] = "Right";
		this.key_code_list[flaxe.input.KeyCode.Down] = "Down";
		this.key_code_list[flaxe.input.KeyCode.Select] = "Select";
		this.key_code_list[flaxe.input.KeyCode.Print] = "Print";
		this.key_code_list[flaxe.input.KeyCode.Execute] = "Execute";
		this.key_code_list[flaxe.input.KeyCode.PrintScreen] = "Print Screen";
		this.key_code_list[flaxe.input.KeyCode.Insert] = "Insert";
		this.key_code_list[flaxe.input.KeyCode.Delete] = "Delete";
		this.key_code_list[flaxe.input.KeyCode.Help] = "Help";
		this.key_code_list[flaxe.input.KeyCode.D0] = "D0";
		this.key_code_list[flaxe.input.KeyCode.D1] = "D1";
		this.key_code_list[flaxe.input.KeyCode.D2] = "D2";
		this.key_code_list[flaxe.input.KeyCode.D3] = "D3";
		this.key_code_list[flaxe.input.KeyCode.D4] = "D4";
		this.key_code_list[flaxe.input.KeyCode.D5] = "D5";
		this.key_code_list[flaxe.input.KeyCode.D6] = "D6";
		this.key_code_list[flaxe.input.KeyCode.D7] = "D7";
		this.key_code_list[flaxe.input.KeyCode.D8] = "D8";
		this.key_code_list[flaxe.input.KeyCode.D9] = "D9";
		this.key_code_list[flaxe.input.KeyCode.A] = "a";
		this.key_code_list[flaxe.input.KeyCode.B] = "B";
		this.key_code_list[flaxe.input.KeyCode.C] = "C";
		this.key_code_list[flaxe.input.KeyCode.D] = "d";
		this.key_code_list[flaxe.input.KeyCode.E] = "E";
		this.key_code_list[flaxe.input.KeyCode.F] = "F";
		this.key_code_list[flaxe.input.KeyCode.G] = "G";
		this.key_code_list[flaxe.input.KeyCode.H] = "H";
		this.key_code_list[flaxe.input.KeyCode.I] = "I";
		this.key_code_list[flaxe.input.KeyCode.J] = "J";
		this.key_code_list[flaxe.input.KeyCode.K] = "K";
		this.key_code_list[flaxe.input.KeyCode.L] = "L";
		this.key_code_list[flaxe.input.KeyCode.M] = "M";
		this.key_code_list[flaxe.input.KeyCode.N] = "N";
		this.key_code_list[flaxe.input.KeyCode.O] = "O";
		this.key_code_list[flaxe.input.KeyCode.P] = "P";
		this.key_code_list[flaxe.input.KeyCode.Q] = "Q";
		this.key_code_list[flaxe.input.KeyCode.R] = "R";
		this.key_code_list[flaxe.input.KeyCode.S] = "s";
		this.key_code_list[flaxe.input.KeyCode.T] = "T";
		this.key_code_list[flaxe.input.KeyCode.U] = "U";
		this.key_code_list[flaxe.input.KeyCode.V] = "V";
		this.key_code_list[flaxe.input.KeyCode.W] = "w";
		this.key_code_list[flaxe.input.KeyCode.X] = "X";
		this.key_code_list[flaxe.input.KeyCode.Y] = "Y";
		this.key_code_list[flaxe.input.KeyCode.Z] = "Z";
		this.key_code_list[flaxe.input.KeyCode.LeftWindows] = "Left Windows";
		this.key_code_list[flaxe.input.KeyCode.RightWindows] = "Right Windows";
		this.key_code_list[flaxe.input.KeyCode.Apps] = "Apps";
		this.key_code_list[flaxe.input.KeyCode.Sleep] = "Sleep";
		this.key_code_list[flaxe.input.KeyCode.NumPad0] = "NumPad 0";
		this.key_code_list[flaxe.input.KeyCode.NumPad1] = "NumPad 1";
		this.key_code_list[flaxe.input.KeyCode.NumPad2] = "NumPad 2";
		this.key_code_list[flaxe.input.KeyCode.NumPad3] = "NumPad 3";
		this.key_code_list[flaxe.input.KeyCode.NumPad4] = "NumPad 4";
		this.key_code_list[flaxe.input.KeyCode.NumPad5] = "NumPad 5";
		this.key_code_list[flaxe.input.KeyCode.NumPad6] = "NumPad 6";
		this.key_code_list[flaxe.input.KeyCode.NumPad7] = "NumPad 7";
		this.key_code_list[flaxe.input.KeyCode.NumPad8] = "NumPad 8";
		this.key_code_list[flaxe.input.KeyCode.NumPad9] = "NumPad 9";
		this.key_code_list[flaxe.input.KeyCode.Multiply] = "Multiply";
		this.key_code_list[flaxe.input.KeyCode.Add] = "Add";
		this.key_code_list[flaxe.input.KeyCode.Separator] = "Separator";
		this.key_code_list[flaxe.input.KeyCode.Subtract] = "Subtract";
		this.key_code_list[flaxe.input.KeyCode.Decimal] = "Decimal";
		this.key_code_list[flaxe.input.KeyCode.Divide] = "Divide";
		this.key_code_list[flaxe.input.KeyCode.F1] = "F1";
		this.key_code_list[flaxe.input.KeyCode.F2] = "F2";
		this.key_code_list[flaxe.input.KeyCode.F3] = "F3";
		this.key_code_list[flaxe.input.KeyCode.F4] = "F4";
		this.key_code_list[flaxe.input.KeyCode.F5] = "F5";
		this.key_code_list[flaxe.input.KeyCode.F6] = "F6";
		this.key_code_list[flaxe.input.KeyCode.F7] = "F7";
		this.key_code_list[flaxe.input.KeyCode.F8] = "F8";
		this.key_code_list[flaxe.input.KeyCode.F9] = "F9";
		this.key_code_list[flaxe.input.KeyCode.F10] = "F10";
		this.key_code_list[flaxe.input.KeyCode.F11] = "F11";
		this.key_code_list[flaxe.input.KeyCode.F12] = "F12";
		this.key_code_list[flaxe.input.KeyCode.F13] = "F13";
		this.key_code_list[flaxe.input.KeyCode.F14] = "F14";
		this.key_code_list[flaxe.input.KeyCode.F15] = "F15";
		this.key_code_list[flaxe.input.KeyCode.F16] = "F16";
		this.key_code_list[flaxe.input.KeyCode.F17] = "F17";
		this.key_code_list[flaxe.input.KeyCode.F18] = "F18";
		this.key_code_list[flaxe.input.KeyCode.F19] = "F19";
		this.key_code_list[flaxe.input.KeyCode.F20] = "F20";
		this.key_code_list[flaxe.input.KeyCode.F21] = "F21";
		this.key_code_list[flaxe.input.KeyCode.F22] = "F22";
		this.key_code_list[flaxe.input.KeyCode.F23] = "F23";
		this.key_code_list[flaxe.input.KeyCode.F24] = "F24";
		this.key_code_list[flaxe.input.KeyCode.NumLock] = "Num Lock";
		this.key_code_list[flaxe.input.KeyCode.Scroll] = "Scroll";
		this.key_code_list[flaxe.input.KeyCode.LeftShift] = "Left Shift";
		this.key_code_list[flaxe.input.KeyCode.RightShift] = "Right Shift";
		this.key_code_list[flaxe.input.KeyCode.LeftControl] = "Left Control";
		this.key_code_list[flaxe.input.KeyCode.RightControl] = "Right Control";
		this.key_code_list[flaxe.input.KeyCode.LeftAlt] = "Left Alt";
		this.key_code_list[flaxe.input.KeyCode.RightAlt] = "Right Alt";
		this.key_code_list[flaxe.input.KeyCode.BrowserBack] = "Browser Back";
		this.key_code_list[flaxe.input.KeyCode.BrowserForward] = "Browser Forward";
		this.key_code_list[flaxe.input.KeyCode.BrowserRefresh] = "Browser Refresh";
		this.key_code_list[flaxe.input.KeyCode.BrowserStop] = "Browser Stop";
		this.key_code_list[flaxe.input.KeyCode.BrowserSearch] = "Browser Search";
		this.key_code_list[flaxe.input.KeyCode.BrowserFavorites] = "Browser Favorites";
		this.key_code_list[flaxe.input.KeyCode.BrowserHome] = "Browser Home";
		this.key_code_list[flaxe.input.KeyCode.VolumeMute] = "Volume Mute";
		this.key_code_list[flaxe.input.KeyCode.VolumeDown] = "Volume Down";
		this.key_code_list[flaxe.input.KeyCode.VolumeUp] = "Volume Up";
		this.key_code_list[flaxe.input.KeyCode.MediaNextTrack] = "Media Next Track";
		this.key_code_list[flaxe.input.KeyCode.MediaPreviousTrack] = "Media Previous Track";
		this.key_code_list[flaxe.input.KeyCode.MediaStop] = "Media Stop";
		this.key_code_list[flaxe.input.KeyCode.MediaPlayPause] = "Media Play/Pause";
		this.key_code_list[flaxe.input.KeyCode.LaunchMail] = "Launch Mail";
		this.key_code_list[flaxe.input.KeyCode.SelectMedia] = "Select Media";
		this.key_code_list[flaxe.input.KeyCode.LaunchApplication1] = "Launch Application 1";
		this.key_code_list[flaxe.input.KeyCode.LaunchApplication2] = "Launch Application 2";
		this.key_code_list[flaxe.input.KeyCode.OemSemicolon] = "Semicolon";
		this.key_code_list[flaxe.input.KeyCode.OemPlus] = "Plus";
		this.key_code_list[flaxe.input.KeyCode.OemComma] = "Comma";
		this.key_code_list[flaxe.input.KeyCode.OemMinus] = "Minus";
		this.key_code_list[flaxe.input.KeyCode.OemPeriod] = "Period";
		this.key_code_list[flaxe.input.KeyCode.OemQuestion] = "Question";
		this.key_code_list[flaxe.input.KeyCode.OemTilde] = "Tilde";
		this.key_code_list[flaxe.input.KeyCode.ChatPadGreen] = "Chat Pad Green";
		this.key_code_list[flaxe.input.KeyCode.ChatPadOrange] = "Chat Pad Orange";
		this.key_code_list[flaxe.input.KeyCode.OemOpenBrackets] = "Open Brackets";
		this.key_code_list[flaxe.input.KeyCode.OemPipe] = "Pipe";
		this.key_code_list[flaxe.input.KeyCode.OemCloseBrackets] = "Close Brackets";
		this.key_code_list[flaxe.input.KeyCode.OemQuotes] = "Quotes";
		this.key_code_list[flaxe.input.KeyCode.Oem8] = "8";
		this.key_code_list[flaxe.input.KeyCode.OemBackslash] = "Backslash";
		this.key_code_list[flaxe.input.KeyCode.ProcessKey] = "Process Key";
		this.key_code_list[flaxe.input.KeyCode.Attn] = "Attn";
		this.key_code_list[flaxe.input.KeyCode.Crsel] = "Crsel";
		this.key_code_list[flaxe.input.KeyCode.Exsel] = "Exsel";
		this.key_code_list[flaxe.input.KeyCode.EraseEof] = "EraseEof";
		this.key_code_list[flaxe.input.KeyCode.Play] = "Play";
		this.key_code_list[flaxe.input.KeyCode.Zoom] = "Zoom";
		this.key_code_list[flaxe.input.KeyCode.Pa1] = "Pa1";
		this.key_code_list[flaxe.input.KeyCode.OemClear] = "Clear";
	}
	
	public inline function set_key_down(code:Int):Void
	{
		this.state.key_list[code] = true;
		
		this.changed = true;
	}

	public inline function set_key_up(code:Int):Void
	{
		this.state.key_list[code] = false;
		
		this.changed = true;
	}

	public inline function clear():Void
	{
		this.state.clear();
	}
	
	public inline function get_state():flaxe.input.KeyState
	{
		//this.changed = false;
		
		return this.state; // todo(daemn) need to allow multiple states to co-exist
	}
	
	public inline function key_to_string(key:Int):String
	{
		return this.key_code_list[key];
	}
	
	public inline function is_changed():Bool
	{
		return this.changed;
	}
	
	public inline function update():Void
	{
		// let listeners know the input has changed for this frame
		if(this.changed)
		{
			this.changed = false;
			
			this.change_event.call_with([]);
		}
	}
}

