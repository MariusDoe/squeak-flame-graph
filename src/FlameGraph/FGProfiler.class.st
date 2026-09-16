Class {
	#name : #FGProfiler,
	#superclass : #Object,
	#instVars : [
		'stackNodes',
		'stackContexts',
		'contextToStackIndex'
	],
	#category : #FlameGraph
}

{
	#category : #profiling,
	#'squeak_changestamp' : 'mad 9/16/2026 12:59'
}
FGProfiler >> addChildrenInReverse: aCollection parent: anFGNode start: startNumber end: endNumber [
	| parent |
	parent := anFGNode.
	aCollection reverseDo: [:each | | node |
		node := FGProfile new
			parent: parent;
			method: each method;
			startTime: startNumber;
			endTime: endNumber;
			yourself.
		self addContext: each node: node.
		parent addChild: node.
		parent := node].
]

{
	#category : #profiling,
	#'squeak_changestamp' : 'mad 9/16/2026 12:50'
}
FGProfiler >> addContext: aContext node: anFGProfile [
	self stackContexts addLast: aContext.
	self stackNodes addLast: anFGProfile.
	self contextToStackIndex at: aContext put: self stackNodes size.
]

{
	#category : #profiling,
	#'squeak_changestamp' : 'mad 9/16/2026 12:56'
}
FGProfiler >> clearStackAbove: indexNumber endTime: endNumber [
	indexNumber + 1 to: self stackNodes size do: [:index |
		(self stackNodes at: index) endTime: endNumber.
		self contextToStackIndex removeKey: (self stackContexts at: index)].
	self stackNodes removeLast: self stackNodes size - indexNumber.
	self stackContexts removeLast: self stackContexts size - indexNumber.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 12:50'
}
FGProfiler >> contextToStackIndex [
	^ contextToStackIndex
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 12:50'
}
FGProfiler >> contextToStackIndex: aDictionary [
	contextToStackIndex := aDictionary
]

{
	#category : #profiling,
	#'squeak_changestamp' : 'mad 9/16/2026 12:55'
}
FGProfiler >> findContextInStack: aContext newChildrenInto: aCollection [
	| currentContext |
	currentContext := aContext.
	[self contextToStackIndex
		at: currentContext
		ifPresent: [:index | ^ index]
		ifAbsent: [
			aCollection add: currentContext.
			currentContext := currentContext sender]] repeat.
]

{
	#category : #profiling,
	#'squeak_changestamp' : 'mad 9/16/2026 13:04'
}
FGProfiler >> observe: aProcess [
	| delay startTime endTime |
	delay := Delay forMilliseconds: MessageTally defaultPollPeriod.
	[true] whileTrue: [
		startTime := Time millisecondClockValue.
		delay wait.
		endTime := Time millisecondClockValue.
		Processor preemptedProcess = aProcess ifTrue: [
			self
				updateStackWith: Processor preemptedProcess suspendedContext
				start: startTime
				end: endTime]].
]

{
	#category : #profiling,
	#'squeak_changestamp' : 'mad 9/16/2026 13:03'
}
FGProfiler >> profile: aBlock [
	| observedProcess root timer |
	observedProcess := Processor activeProcess.
	root := self startProfiling: aBlock.
	timer := [self observe: observedProcess] newProcess.
	timer
		priority: Processor timingPriority - 1;
		resume.
	aBlock ensure: [timer terminate].
	root endTime: Time millisecondClockValue.
	^ root
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 12:50'
}
FGProfiler >> stackContexts [
	^ stackContexts
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 12:50'
}
FGProfiler >> stackContexts: aCollection [
	stackContexts := aCollection
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 12:50'
}
FGProfiler >> stackNodes [
	^ stackNodes
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 12:50'
}
FGProfiler >> stackNodes: aCollection [
	stackNodes := aCollection
]

{
	#category : #profiling,
	#'squeak_changestamp' : 'mad 9/16/2026 13:01'
}
FGProfiler >> startProfiling: aBlock [
	| root |
	self
		contextToStackIndex: Dictionary new;
		stackContexts: OrderedCollection new;
		stackNodes: OrderedCollection new.
	root := FGProfile new
		parent: nil;
		method: aBlock method;
		startTime: Time millisecondClockValue;
		yourself.
	self addContext: nil node: root.
	^ root
]

{
	#category : #profiling,
	#'squeak_changestamp' : 'mad 9/16/2026 12:57'
}
FGProfiler >> updateStackBelow: indexNumber endTime: endNumber [.
	1 to: indexNumber do: [:index | (self stackNodes at: index) endTime: endNumber].
]

{
	#category : #profiling,
	#'squeak_changestamp' : 'mad 9/16/2026 13:00'
}
FGProfiler >> updateStackWith: aContext start: startNumber end: endNumber [
	| newChildren foundIndex |
	newChildren := OrderedCollection new.
	foundIndex := self findContextInStack: aContext newChildrenInto: newChildren.
	self
		updateStackBelow: foundIndex endTime: endNumber;
		clearStackAbove: foundIndex endTime: startNumber;
		addChildrenInReverse: newChildren
		parent: (self stackNodes at: foundIndex)
		start: startNumber end: endNumber.
]
