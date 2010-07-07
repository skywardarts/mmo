package haxegui;

import haxe.Timer;

typedef Profile = {
	public var time 	   : Float;
	public var calls 	   : Int;
	public var percentage  : Float;
	public var selfTime	   : Float;
}

class ProfileNode {
	private static var nextId : Int = 0;

	public var id(default, null) : Int;

	public var name 	   : String;
	public var time 	   : Float;

	public var startTime : Float;

	public var stats : Profile;


	public function new(n:String) {
		id = ProfileNode.nextId++;


		if(n==null)
		name = Type.getClassName(Type.getClass(this)).split(".").pop() + id;
		else
		name = n;

		time = startTime = 0;

	}

	//{{{ begin
	public function begin() {
		startTime = Timer.stamp();
	}
	//}}}


	//{{{ end
	public function end() {
		time = Timer.stamp() - startTime;
		--ProfileNode.nextId;
	}
	//}}}


	//{{{ getStats
	public function calcStats() {
		//		return { name: this.name, calls: id, time: this.time, cumlative: this.cumlative, percentage: p };
		var stat = Profiler.profiles.get(name);
		if(stat==null)
		stats = {
			calls: 1,
			time: time,
			selfTime: time,
			percentage: .0
		}
		else
		stats = {
			calls: stat.calls + 1,
			time: stat.time + time,
			selfTime: (stat.time + time)/(stat.calls+1),
			percentage: ((stat.time + time)*100) / Timer.stamp()
		};
	}
	//}}}
}


//{{{ Profiler
class Profiler {

	public static var nodes : Array<ProfileNode> = [];
	// public static var nodes : Hash<ProfileNode> = new Hash<ProfileNode>();
	public static var profiles : Hash<Profile> = new Hash<Profile>();

	public static var currNode : ProfileNode;

	public static var interval : Int = 50;
	public static var timer : Timer;

	public function new() {
	}


	//{{{ begin
	public static function begin(n:String) {
		var node = new ProfileNode(n);

		nodes.push(node);

		currNode = node;
		currNode.begin();

		if(timer!=null) timer.stop();
		timer = new Timer(interval);
		timer.run = update;
	}
	//}}}


	//{{{ end
	public static function end() {
		currNode.end();

		update();

		currNode = nodes.pop();
	}
	//}}}


	//{{{ update
	public static function update() {
		// trace(Timer.stamp());
		for(n in nodes) {
			n.calcStats();

			//			n.stats.percentage = Std.string((n.stats.time*100) / Timer.stamp()).substr(0,5)+"%";

			profiles.set(n.name, n.stats);

			//trace(Std.string(n.getStats()));
			//trace(n.name+":"+Std.string(n.stats));
		}

		// trace(profiles);
	}
	//}}}

	//{{{ print
	public static function print(?out:String->Void) {
		if(out==null) out = flash.Lib.trace;

		var a : Array<String> = [];

		var s : String = "\nUptime: "+DateTools.format(new Date(0,0,0,0,0,Std.int(haxe.Timer.stamp())), "%H:%M:%S")+"\n";
		s += "["+StringTools.rpad("Class.methodName"," ",32)+"]\t"+
		"["+Std.string("% Time")+"]\t"+
		"["+Std.string(" Calls ")+"]\t"+
		"["+Std.string("Tot. Time")+"]\t"+
		"["+Std.string("Self Time")+"]\n\n";

		for(p in profiles.keys()) {
			var stat = profiles.get(p);
			var t =
			"["+StringTools.rpad(p," ",32)+"]\t"+
			"["+StringTools.lpad(Std.string(stat.percentage).substr(0,5), " ",5)+"%"+"]\t"+
			"["+StringTools.lpad(Std.string(stat.calls), " ", 7)+"]\t"+
			"["+StringTools.lpad(Std.string(stat.time).substr(0,8), " ", 8)+"s]\t"+
			"["+StringTools.lpad(Std.string(stat.selfTime).substr(0,8), " ", 8)+"s]";
			a.push(t);
		}

		var sorter = function(s1:String, s2:String) {
			return s1>s2 ? 1 : s1<s1 ? -1 : 0;
		}
		a.sort(sorter);
		trace(s+a.join("\n"));
	}
	//}}}


	//{{{ show
	public static function show() {
		var w = new haxegui.Window("Profiler Window");
		w.init();

		var c = new haxegui.containers.Container(w);
		c.init();

		var g = new haxegui.containers.Grid(c);
		g.init({
			rows: 1,
			cols: 5,
			cellSpacing: 0,
			left: 0,
			right: 0,
			top: 0,
			bottom: 0
		});

		for(i in 0...5) {
			var list = new haxegui.controls.UiList(g);
			list.init({});
			list.dataSource = new haxegui.DataSource();
			list.dataSource.data = new List();
		}

		g.setAction("interval",
		"
		for(i in 0...5) {
			this.getChildAt(i).removeItems();
			this.getChildAt(i).dataSource.data = new List();
		}

		for(p in Profiler.profiles.keys()) {

			var profile = Profiler.profiles.get(p);


			for(i in 0...5) {
				var list = this.getChildAt(i);
				var data = list.dataSource.data;


				//ds.data.add(p+Std.string(Profiler.profiles.get(p)));
				if(i==0) data.add(p);
				if(i==1) data.add(profile.percentage);
				if(i==2) data.add(profile.calls);
				if(i==3) data.add(profile.time);
				if(i==4) data.add(profile.selftime);

				list.setDataSource(list.dataSource);
			}
		}

		// this.removeItems();

		// var ds = new haxegui.DataSource();
		// ds.data = new List();
		// for(p in Profiler.profiles.keys())
		// ds.data.add(p+Std.string(Profiler.profiles.get(p)));
		// this.setDataSource(ds);
		");

		g.startInterval(1);
	}
	//}}}
}
//}}}