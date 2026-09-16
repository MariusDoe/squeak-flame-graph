Class {
	#name : #FGMessageTallyNode,
	#superclass : #FGNode,
	#instVars : [
		'tally',
		'startOffset'
	],
	#category : #FlameGraph
}

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'mad 9/16/2026 11:03'
}
FGMessageTallyNode class >> on: aMessageTally [
	^ self on: aMessageTally startOffset: 0
]

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'mad 9/16/2026 11:02'
}
FGMessageTallyNode class >> on: aMessageTally startOffset: aNumber [
	^ self new
		tally: aMessageTally;
		startOffset: aNumber;
		yourself
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 11:02'
}
FGMessageTallyNode >> children [
	| offset |
	offset := 0.
	^ self rawChildren collect: [:each | | node |
		node := self species on: each startOffset: offset.
		offset := offset + node width.
		node]
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 10:39'
}
FGMessageTallyNode >> colorKey [
	^ self tally method
]

{
	#category : #'event handling',
	#'squeak_changestamp' : 'mad 9/16/2026 10:45'
}
FGMessageTallyNode >> mouseDown: anEvent [
	anEvent shiftPressed
		ifTrue: [self tally inspect]
		ifFalse: [self tally method homeMethod browse].
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 10:39'
}
FGMessageTallyNode >> printOn: aStream [
	self tally printOn: aStream.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 11:01'
}
FGMessageTallyNode >> rawChildren [
	^ self tally childrenOver: 0
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 10:59'
}
FGMessageTallyNode >> startOffset [
	^ startOffset
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 11:00'
}
FGMessageTallyNode >> startOffset: aNumber [
	startOffset := aNumber
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 10:39'
}
FGMessageTallyNode >> tally [
	^ tally
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 10:43'
}
FGMessageTallyNode >> tally: aMessageTally [
	tally := aMessageTally
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 10:37'
}
FGMessageTallyNode >> width [
	^ self tally tally
]
