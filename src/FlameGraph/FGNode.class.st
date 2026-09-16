Class {
	#name : #FGNode,
	#superclass : #Object,
	#category : #FlameGraph
}

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 10:34'
}
FGNode >> children [
	self subclassResponsibility.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 10:38'
}
FGNode >> colorKey [
	self subclassResponsibility.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 10:36'
}
FGNode >> depth [
	^ 1 + ((self children collect: #depth) ifNotEmpty: #max ifEmpty: [0])
]

{
	#category : #'event handling',
	#'squeak_changestamp' : 'mad 9/16/2026 10:45'
}
FGNode >> mouseDown: anEvent [
	self subclassResponsibility.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 10:59'
}
FGNode >> startOffset [
	self subclassResponsibility.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 10:37'
}
FGNode >> width [
	self subclassResponsibility.
]
