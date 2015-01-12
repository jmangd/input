package input;

import input.Keyboard;
import js.JQuery;
import js.Browser;
import input.KeyboardEventData;

@:access(input.Keyboard)
class KeyboardManager
{
	private static var keyboardInstance : KeyboardManager;

	private var mainKeyboard : Keyboard;

	private var keyboardEventData: KeyboardEventData;
	private var jquery : JQuery;

	private function new()
	{
		mainKeyboard = new Keyboard();
		jquery = new JQuery(Browser.window);
		keyboardEventData = new KeyboardEventData();
	}

	public function getMainKeyboard(): Keyboard
	{
		return mainKeyboard;
	}

	public static inline function instance(): KeyboardManager
	{
		return keyboardInstance;
	}

	public static function initialize(finishedCallback: Void -> Void) : Void
	{
		keyboardInstance = new KeyboardManager();

		keyboardInstance.initializeCallbacks(finishedCallback);
	}

	private function initializeCallbacks(finishedCallback: Void -> Void)
	{
		jquery.ready(function(e):Void
        {
			jquery.keydown(function(e:Dynamic)
			{
				keyboardEventData.keyCode = e.keyCode;
				keyboardEventData.shiftKeyPressed = e.shiftKey;
				keyboardEventData.ctrlKeyPressed = e.ctrlKey;
				keyboardEventData.altKeyPressed = e.altKey;
				keyboardEventData.state = KeyState.Down;
				mainKeyboard.onKeyboardEvent.dispatch(keyboardEventData);
			});

			jquery.keyup(function(e:Dynamic)
			{
				keyboardEventData.keyCode = e.keyCode;
				keyboardEventData.shiftKeyPressed = e.shiftKey;
				keyboardEventData.ctrlKeyPressed = e.ctrlKey;
				keyboardEventData.altKeyPressed = e.altKey;
				keyboardEventData.state = KeyState.Up;
				mainKeyboard.onKeyboardEvent.dispatch(keyboardEventData);
			});

			finishedCallback();
		});
	}
}
