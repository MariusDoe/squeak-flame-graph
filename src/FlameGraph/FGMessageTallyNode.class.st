Class {
	#name : #FGMessageTallyNode,
	#superclass : #FGNode,
	#instVars : [
		'tally'
	],
	#category : #FlameGraph
}

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'mad 9/16/2026 10:42'
}
FGMessageTallyNode class >> on: aMessageTally [
	^ self new
		tally: aMessageTally;
		yourself
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 10:43'
}
FGMessageTallyNode >> children [
	^ (self tally childrenOver: 0) collect: [:each | self class on: each]
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
