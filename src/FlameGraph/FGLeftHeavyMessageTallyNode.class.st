Class {
	#name : #FGLeftHeavyMessageTallyNode,
	#superclass : #FGMessageTallyNode,
	#category : #FlameGraph
}

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 11:08'
}
FGLeftHeavyMessageTallyNode >> rawChildren [
	^ super rawChildren sorted: #tally descending
]
