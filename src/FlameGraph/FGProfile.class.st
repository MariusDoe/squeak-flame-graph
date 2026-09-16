Class {
	#name : #FGProfile,
	#superclass : #FGNode,
	#instVars : [
		'method',
		'startTime',
		'endTime',
		'parent',
		'children'
	],
	#category : #FlameGraph
}

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 12:28'
}
FGProfile >> addChild: anFGProfile [
	self children addLast: anFGProfile.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 12:14'
}
FGProfile >> children [
	^ children
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 12:14'
}
FGProfile >> children: aCollection [
	children := aCollection
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 12:14'
}
FGProfile >> colorKey [
	^ self method
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 12:14'
}
FGProfile >> endTime [
	^ endTime
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 12:14'
}
FGProfile >> endTime: anObject [
	endTime := anObject
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'mad 9/16/2026 12:25'
}
FGProfile >> initialize [
	super initialize.
	self children: OrderedCollection new.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 12:13'
}
FGProfile >> method [
	^ method
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 12:13'
}
FGProfile >> method: anObject [
	method := anObject
]

{
	#category : #'event handling',
	#'squeak_changestamp' : 'mad 9/16/2026 12:32'
}
FGProfile >> mouseDown: anEvent [
	anEvent shiftPressed
		ifTrue: [self inspect]
		ifFalse: [self method homeMethod browse]
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 12:24'
}
FGProfile >> parent [
	^ parent
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 12:25'
}
FGProfile >> parent: anFGProfile [
	parent := anFGProfile
]

{
	#category : #printing,
	#'squeak_changestamp' : 'mad 9/16/2026 12:39'
}
FGProfile >> printOn: aStream [
	self method flameGraphPrintOn: aStream.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 12:22'
}
FGProfile >> startOffset [
	^ self parent ifNil: [0] ifNotNil: [:node | self startTime - node startTime]
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 12:14'
}
FGProfile >> startTime [
	^ startTime
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 12:14'
}
FGProfile >> startTime: anObject [
	startTime := anObject
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 12:24'
}
FGProfile >> width [
	^ self endTime - self startTime
]
