Class {
	#name : #FGLeftHeavyMessageTallyNode,
	#superclass : #FGMessageTallyNode,
	#category : #FlameGraph
}

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 10:49'
}
FGLeftHeavyMessageTallyNode >> children [
	^ super children sorted: #width descending
]
