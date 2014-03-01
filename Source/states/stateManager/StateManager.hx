package states.stateManager;

import flash.utils.Function;
import states.stateManager.transitions.TransitionHelper;
import flash.display.Sprite;
import haxe.ds.StringMap;
import flash.display.DisplayObject;
import motion.Actuate;
import states.stateManager.transitions.SlideTransitions;

class StateManager extends Sprite {

	private static var _instance:StateManager;

	public static function getInstance():StateManager {
		if(_instance == null) _instance = new StateManager();

		return _instance;
	}

	private var states:StringMap<State>;
	private var currentStateKey:String;

	private var transitionHelper:TransitionHelper;

	private var isTransitioning:Bool;

    private function new() {
	    super();
		states = new StringMap<State>();
	    currentStateKey = "none";

	    isTransitioning = false;

	    transitionHelper = TransitionHelper.getInstance();
    }

	public function addState(name:String, state:State):Void {
		states.set(name, state);

		state.load();
		state.setUp();
	}

	public function changeState(newStateKey:String):Void {
		if(currentStateKey != "none") {
			removeChild(getCurrentState());
			getCurrentState().cleanUp();
			getCurrentState().x = getCurrentState().y = 0;
		}

		currentStateKey = newStateKey;

		if(getChildIndex(getCurrentState()) == -1) {
			addChild(getCurrentState());
		}

		getCurrentState().onEntered();
	}

	public function update(dt:Int):Void {
		if(!isTransitioning) getCurrentState().update(dt);
	}

	public function getCurrentState():State {
		return states.get(currentStateKey);
	}

	public function changeStateTransition(newStateKey:String, transitionKey:Transitions):Void {

		var nextState:State = states.get(newStateKey);
		var currentState:State = getCurrentState();

		nextState.onEnterStart();
		currentState.onExitStart();

		addChild(nextState);

		var endTransition = function():Void {
			changeState(newStateKey);

			nextState.onEnterFinish();
			currentState.onExitFinish();
			isTransitioning = false;
		}

		isTransitioning = true;

		var transition:Function = transitionHelper.getTransition(transitionKey);

		transition(currentState, nextState, endTransition);
	}
}
