
class StateTransition<T:Hashable>
{
    private var _fromState:T
    private var _toState:T
    private var _queue:[T]?
    
    init(fromState:T, toState:T, via:[T]?)
    {
        self._fromState = fromState
        self._toState = toState
        
        if let via = via
        {
            self._queue = []
            
            for s in via
            {
                self._queue!.append( s )
            }
            
            self._queue!.append( toState )
        }
    }
    
    /**
     * @return	Starting state for this transition
     */
    var from:T
        {
            return self.from
    }
    
    /**
     * @return	Finishing state for this transition
     */
    var t0:T
        {
            return self._toState
    }
    
    /**
     * @return	Array of states in a complex state
     */
    var queue:[T]?
    {
        let clone = _queue
        return clone
    }
    
    /**
     * @return	True if this is a simple transition
     */
    var simple:Bool
    {
        return _queue == nil
    }
}

public class StateMachine<StateType:Hashable, EventType:Hashable, TransitionListenerId:Hashable, EventListenerId:Hashable>
{
    public typealias TransitionListener = ()->Void
    public typealias EventListener = ([AnyObject]?)->Void
    
    private var ANY : StateType
    
    var _transitions: [StateType:[StateType:StateTransition<StateType>]]
    var _previousState: StateType?
    var _currentState: StateType?
    var _queuedState: StateType?
    
    var _statesQueue: [StateType]?
    
    var _transitionListeners: [StateType:[StateType:[(TransitionListenerId, TransitionListener)]]]
    var _eventListeners: [StateType:[EventType:[(EventListenerId, EventListener)]]]
    
    var _inTransition: Bool = false
    
    var _canChangeStateDuringTransition: Bool = true
    
    /**
     * Initializes state machine
     */
    public init(_ anyStateId:StateType)
    {
        ANY = anyStateId
        _transitions = [:]
        _transitionListeners = [:]
        _eventListeners = [:]
    }
    
    /**
     * Adds possible transition from one state to another.
     * If it's first ever transition for this state machine, starting state is set as current state.
     * @param	fromState	Starting state
     * @param	toState		Finishing state name or array of state names
     * @param	via			State name or array of states via which transition takes place
     */
    public func add(fromState fromState:StateType, toState:[StateType]? = nil, via:[StateType]? = nil)
    {
        // no state set?
        if _currentState == nil
        {
            _currentState = fromState
        }
        
        if toState == nil
        {
            return
        }
        
        // no transitions from this state yet
        if _transitions[fromState] == nil
        {
            _transitions[fromState] = [:]
        }
        
        if let toState = toState as? StateType
        {
            _transitions[fromState]![toState] = StateTransition(fromState: fromState, toState: toState, via: via)
        }
        else if let toState = toState
        {
            for s in toState
            {
                _transitions[fromState]![s] = StateTransition(fromState: fromState, toState: s, via: via)
            }
        }
    }
    
    public func add(fromState fromState:StateType, toState:StateType? = nil, via:StateType? = nil)
    {
        if let toState = toState
        {
            if let via = via
            {
                self.add(fromState: fromState, toState: [toState], via: [via])
            }
            else
            {
                self.add(fromState: fromState, toState: [toState], via: nil as [StateType]?)
            }
        }
        else if let via = via
        {
            self.add(fromState: fromState, toState:nil as [StateType]?,  via: [via])
        }
    }
    
    public func add(fromState fromState:StateType, toState:StateType? = nil, via:[StateType]? = nil)
    {
        if let toState = toState
        {
            self.add(fromState: fromState, toState:[toState], via: via)
        }
    }
    
    public func add(fromState fromState:StateType, toState:[StateType]? = nil, via:StateType? = nil)
    {
        if let via = via
        {
            self.add(fromState: fromState, toState: toState, via: [via])
        }
    }
    
    
    /**
     * Adds a two-way transition from one state to another.
     * @param	fromState	Starting state
     * @param	toState		Finishing state
     * @param	via			State name or array of states via which transition takes place
     */
    public func addTwoWay(fromState fromState:StateType, toState:StateType, via:[StateType]? = nil)
    {
        add(fromState: fromState, toState: [toState], via: via)
        add(fromState: toState, toState: [fromState], via: via)
    }
    
    public func addTwoWay(fromState fromState:StateType, toState:StateType, via:StateType? = nil)
    {
        if let via = via
        {
            let vias = [via]
            add(fromState: fromState, toState: [toState], via: vias)
            add(fromState: toState, toState: [fromState], via: vias)
        }
        else
        {
            add(fromState: fromState, toState: [toState], via: nil as [StateType]?)
            add(fromState: toState, toState: [fromState], via: nil as [StateType]?)
        }
    }
    
    public func setState(toState:StateType)
    {
        // we are in transition and can change states during it
        if _inTransition && _canChangeStateDuringTransition
        {
            _queuedState = toState
            return
        }
        else
        {
            _queuedState = nil
        }
        
        // no transition from current state
        
        if let currentState = _currentState
        {
            if _transitions[currentState] == nil
            {
                return
            }
        }
        else
        {
            return
        }
        
        let st = _transitions[_currentState!]![toState]
        
        if let st = st
        {
            _previousState = _currentState
            
            if st.simple
            {
                // simple synchroneous transition
                _currentState = st.t0
                broadcastStateChange(fromState: st.from, toState: st.t0)
            }
            else
            {
                // complex trasition
                _inTransition = true
                _statesQueue = st.queue
                setNextQueuedState()
            }
        }
    }
    
    /**
     * Finish current unnamed state callback
     */
    public func release()
    {
        setNextQueuedState()
    }
    
    /**
     * Dispatch state event
     * @param	name	Event name
     * @param	args	Single event argument or array of arguments
     */
    public func dispatch(name name:EventType, args:[AnyObject])
    {
        if let listeners = _eventListeners[ANY]
        {
            if let nameListeners = listeners[name]
            {
                for (_, f) in nameListeners
                {
                    f(args)
                }
            }
        }
        if let currentState = _currentState
        {
            if let currentStateListeners = _eventListeners[currentState]
            {
                if let nameListeners = currentStateListeners[name]
                {
                    for (_, f) in nameListeners
                    {
                        f(args)
                    }
                }
            }
        }
    }
    
    /**
     * Adds state transition listener
     * @param	fromState	Starting state name
     * @param	toState		Finishing state name
     * @param	funcId      closure identifier
     * @param	function    closure
     */
    public func addTransitionListener(fromState fromState:StateType, toState:StateType, funcId:TransitionListenerId, function:TransitionListener)
    {
        if _transitionListeners[fromState] == nil
        {
            _transitionListeners[fromState] = [:]
        }
        
        if _transitionListeners[fromState]![toState] == nil
        {
            _transitionListeners[fromState]![toState] = []
        }
        
        var listeners = _transitionListeners[fromState]![toState]!
        
        let l:Int = listeners.count
        
        for i in 0 ..< l
        {
            if listeners[i].0 == funcId
            {
                return
            }
        }
        
        listeners.append((funcId, function))
        _transitionListeners[fromState]![toState] = listeners
    }
    
    /**
     * Removes state transition listener
     * @param	fromState	Starting state
     * @param	toState		Finishing state
     * @param	funcId		closure identifier
     */
    public func removeTransitionListener(fromState fromState:StateType, toState:StateType, funcId:TransitionListenerId)
    {
        if var listeners = _transitionListeners[fromState]?[toState]
        {
            let l = listeners.count
            var indicesToRemove:[Int] = []
            for i in 0 ..< l
            {
                if listeners[i].0 == funcId
                {
                    
                    indicesToRemove.append(i)
                }
            }
            
            for j in indicesToRemove
            {
                listeners.removeAtIndex(j)
            }
                        
            _transitionListeners[fromState]![toState] = listeners
            
            if listeners.count == 0
            {
                _transitionListeners[fromState]!.removeValueForKey(toState)
            }
            
            if let tos = _transitionListeners[fromState]
            {
                for (_, _) in tos
                {
                    return
                }
            }
            
            _transitionListeners.removeValueForKey(fromState)
        }
    }
    
    /**
     * Adds event listener
     * @param	state	 State name
     * @param	event	 Event name
     * @param	funcId   closure identifier
     */
    public func addEventListener(state state:StateType, event:EventType, funcId:EventListenerId, function:EventListener)
    {
        if _eventListeners[state] == nil
        {
            _eventListeners[state] = [:]
        }
        
        if _eventListeners[state]![event] == nil
        {
            _eventListeners[state]![event] = []
        }
        
        var listeners = _eventListeners[state]![event]!
        
        for (i, _) in listeners
        {
            if i == funcId
            {
                return
            }
        }
        
        listeners.append((funcId, function))
        _eventListeners[state]![event] = listeners
    }
    
    /**
     * Removes event listener
     * @param	state	State name
     * @param	event	Event name
     * @param	funcId	closure identifier
     */
    public func removeEventListener(state state:StateType, event:EventType, funcId:EventListenerId)
    {
        if var listeners = _eventListeners[state]?[event]
        {
            let l = listeners.count
            var indicesToRemove:Set<Int> = []
            for i in 0 ..< l
            {
                if listeners[i].0 == funcId
                {
                    indicesToRemove.insert(i)
                }
            }
            
            for j in indicesToRemove
            {
                listeners.removeAtIndex(j)
            }
            
            _eventListeners[state]![event] = listeners
            
            if listeners.count == 0
            {
                _eventListeners[state]!.removeValueForKey(event)
            }
            
            if let events = _eventListeners[state]
            {
                for (_, _) in events
                {
                    return
                }
            }
            
            _eventListeners.removeValueForKey(state)
        }
    }
    
    /**
     * @return	Current state name
     */
    public var currentState:StateType?
    {
        return _currentState
    }
    
    /**
     * @return	Previous state name
     */
    public var previousState:StateType?
    {
        return _previousState
    }
    
    public var canChangeStateDuringTransition:Bool
    {
        get
        {
            return _canChangeStateDuringTransition
        }
        
        set(value)
        {
            return _canChangeStateDuringTransition = value
        }
    }
    
    /**
     * Sets current state to next state in complex state queue
     */
    func setNextQueuedState()
    {
        assert(_previousState != nil, "setState must be called first")
        
        _previousState = _currentState
        _currentState = _statesQueue?.removeFirst()
        // tell everyone
        
        broadcastStateChange(fromState: _previousState!, toState: _currentState!)
        if _statesQueue?.count == 0
        {
            // finished
            _inTransition = false
        }
        
        // if it's not transition state
        if !isTransitionState(_currentState!) || !_inTransition
        {
            // changing state to queued
            if let queuedState = _queuedState, let currentState = _currentState
            {
                if let _ = _transitions[currentState]?[queuedState]
                {
                    _inTransition = false
                    _statesQueue = nil
                    setState(queuedState)
                }
            }
            else if _inTransition
            {
                setNextQueuedState()
            }
        }
    }
    
    /**
     * Returns true if a state is transition state
     * @param	state	State name
     */
    func isTransitionState(state:StateType) -> Bool
    {
        return _transitions[state] == nil
    }
    
    /**
     * Executes state change event listeners
     * @param	fromState	Previous state name
     * @param	toState		Next state name
     */
    func broadcastStateChange(fromState fromState:StateType, toState:StateType)
    {
        // any state state
        if let listeners = _transitionListeners[ANY]
        {
            if let anyListeners = listeners[ANY]
            {
                for (_, f) in anyListeners
                {
                    f()
                }
            }
            
            if let toStateListeners = listeners[toState]
            {
                for (_, f) in toStateListeners
                {
                    f()
                }
            }
        }
        
        // current state
        if let listeners = _transitionListeners[fromState]
        {
            if let anyListeners = listeners[ANY]
            {
                for (_, f) in anyListeners
                {
                    f()
                }
            }
            
            if let toStateListeners = listeners[toState]
            {
                for (_, f) in toStateListeners
                {
                    f()
                }
            }
        }
    }
}
