import haxe.PosInfos;
import hxjsonast.Json;
import js.Browser.document;
import json2object.JsonParser;

class App{
	@:jcustomparse(App.customParse)
	@:jcustomwrite(App.num2json)
	public static var value:Dynamic;

	public static  function main() {
		var map:Map<String,String> = [
			'hello'=>'world :)'
		];
		show(map.toString());
		
		var writer = new json2object.JsonWriter<Map<String,String>>();
		var json:String = writer.write(map);
		show(json);
		//writer = new json2object.JsonWriter<Map<String,Dynamic>>();
		json = writer.write(dyn2string(['hello world' => 666]));
		show(json);
		//writer = new json2object.JsonWriter<JType>();
		var reader = new JsonParser<{hello:String,hell:Int}>();
		value = reader.fromJson('{"hello":"world","hell":666}');
		show(value);
		//value = ['hello world' => 666];
		var dw = new json2object.JsonWriter<{hello:String,hell:Int}>();
		json = dw.write(value);
		show(json);
	}

	public static function num2json<T>(dynMap:Map<String,T>):String {
		trace(dynMap);
		return '{"dynMap":"${dynMap.toString()}"}';
	}

	public static function customParse(val:Json, name:String):String {
		trace(name + ':' + val);
		return switch (val.value) {
			case JString(s):
				s;
			case JNumber(s):
				Std.string(s);
			default:
				null;

		}
	}	

	static function dyn2string(m:Map<String,Dynamic>):Map<String,String> {
		var typedMap:Map<String,String> = [];
		var it:KeyValueIterator<String,String> = m.keyValueIterator();
		while(it.hasNext()){
			var kv:Dynamic = it.next();
			trace(kv);
			typedMap[kv.key] = Std.string(kv.value);
		}
		return typedMap;
	}

	
	public static  function show(m:String, ?pos:PosInfos) {
		var pre = document.createPreElement();
		pre.innerText = pos.fileName + ':' + pos.methodName + ':' + pos.lineNumber + '::' + m;
		document.querySelector("#screen").appendChild(pre);
	}
}