Class {
	#name : #BaselineOfFlameGraph,
	#superclass : #BaselineOf,
	#category : #BaselineOfFlameGraph
}

{
	#category : #baseline,
	#'squeak_changestamp' : 'mad 9/16/2026 13:15'
}
BaselineOfFlameGraph >> baseline: spec [
	<baseline>
	spec for: #common do: [
		spec package: 'FlameGraph'].
]
