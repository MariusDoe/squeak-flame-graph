Class {
	#name : #FlameGraphMorph,
	#superclass : #Morph,
	#instVars : [
		'rootNode',
		'zoom'
	],
	#category : #FlameGraph
}

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'mad 9/16/2026 00:29'
}
FlameGraphMorph class >> on: aMessageTally [
	^ self new
		rootNode: aMessageTally;
		yourself
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 00:29'
}
FlameGraphMorph >> basicZoom: aNumber [
	zoom := aNumber.
]

{
	#category : #sizing,
	#'squeak_changestamp' : 'mad 9/15/2026 23:47'
}
FlameGraphMorph >> childrenAndOffsetsOf: aMessageTally do: aBlock [
	| x |
	x := 0.
	(self childrenOf: aMessageTally) do: [:each |
		aBlock value: each value: x.
		x := x + (self widthOf: each)].
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/15/2026 23:47'
}
FlameGraphMorph >> childrenOf: aMessageTally [
	^ aMessageTally childrenOver: 0
]

{
	#category : #drawing,
	#'squeak_changestamp' : 'mad 9/15/2026 21:37'
}
FlameGraphMorph >> colorFor: aMessageTally [
	^ [WeakIdentityKeyDictionary new] once at: aMessageTally method ifAbsentPut: [Color random]
]

{
	#category : #drawing,
	#'squeak_changestamp' : 'mad 9/16/2026 00:02'
}
FlameGraphMorph >> drawChildrenOf: aMessageTally on: aCanvas startingAt: aPoint textWithin: aRectangle [
	self childrenAndOffsetsOf: aMessageTally do: [:each :offset |
		self drawNodeAndChildren: each on: aCanvas startingAt: aPoint + (offset @ 0) textWithin: aRectangle].
]

{
	#category : #drawing,
	#'squeak_changestamp' : 'mad 9/16/2026 01:29'
}
FlameGraphMorph >> drawNode: aMessageTally on: aCanvas in: nodeRectangle textWithin: textBoundsRectangle [
	| nodeColor textRectangle continued |
	(nodeRectangle intersects: aCanvas clipRect) ifFalse: [^ self].
	nodeColor := self colorFor: aMessageTally.
	FlameGraph fillAlpha > 0 ifTrue: [
		aCanvas fillRectangle: nodeRectangle color: (nodeColor alpha: FlameGraph fillAlpha)].
	aCanvas frameRectangle: nodeRectangle color: nodeColor.
	textRectangle := nodeRectangle left: (nodeRectangle left clampLow: textBoundsRectangle left).
	continued := textRectangle left > nodeRectangle left.
	textRectangle := textRectangle insetBy: FlameGraph textPadding px.
	textRectangle width >= FlameGraph minimumTextWidth px ifTrue: [ | string |
		string := aMessageTally printString.
		continued ifTrue: [string := '...{1}' format: {string}].
		aCanvas drawString: string in: textRectangle font: nil color: nodeColor].
]

{
	#category : #drawing,
	#'squeak_changestamp' : 'mad 9/16/2026 00:04'
}
FlameGraphMorph >> drawNodeAndChildren: aMessageTally on: aCanvas startingAt: aPoint textWithin: aRectangle [
	| rectangle |
	rectangle := aPoint extent: (self widthOf: aMessageTally) @ self nodeHeight.
	(rectangle width >= 1 and: [(rectangle withHeight: Float infinity) intersects: aCanvas clipRect]) ifFalse: [^ self].
	self
		drawNode: aMessageTally on: aCanvas in: rectangle textWithin: aRectangle;
		drawChildrenOf: aMessageTally on: aCanvas startingAt: aPoint x @ (aPoint y + self nodeHeight) textWithin: aRectangle.
]

{
	#category : #drawing,
	#'squeak_changestamp' : 'mad 9/16/2026 01:19'
}
FlameGraphMorph >> drawOn: aCanvas [
	| textBounds |
	textBounds := (self ownerThatIsA: ScrollPane)
		ifNil: [self bounds]
		ifNotNil: [:pane | pane scroller offset extent: pane scroller extent].
	aCanvas clipBy: self bounds during:
		[:canvas | self drawNodeAndChildren: self rootNode on: canvas startingAt: self position textWithin: textBounds].
]

{
	#category : #'event handling',
	#'squeak_changestamp' : 'mad 9/15/2026 23:45'
}
FlameGraphMorph >> findNodeAt: aPoint below: aMessageTally ifFound: aBlock [
	(aPoint y >= 0 and: [aPoint x between: 0 and: (self widthOf: aMessageTally)]) ifFalse: [^ self].
	aPoint y <= self nodeHeight ifTrue: [^ aBlock value: aMessageTally].
	self childrenAndOffsetsOf: aMessageTally do: [:each :offset |
		self
			findNodeAt: aPoint - (offset @ self nodeHeight)
			below: each
			ifFound: [:node | ^ aBlock value: node]].
]

{
	#category : #'event handling',
	#'squeak_changestamp' : 'mad 9/15/2026 22:21'
}
FlameGraphMorph >> handlesKeyboard: anEvent [
	^ true
]

{
	#category : #'event handling',
	#'squeak_changestamp' : 'mad 9/15/2026 23:35'
}
FlameGraphMorph >> handlesMouseDown: anEvent [
	^ true
]

{
	#category : #sizing,
	#'squeak_changestamp' : 'mad 9/15/2026 23:47'
}
FlameGraphMorph >> heightOf: aMessageTally [
	^ self nodeHeight +
		((self childrenOf: aMessageTally)
			ifEmpty: [0]
			ifNotEmpty: [:children |
				(children collect: [:each | self heightOf: each]) max])
]

{
	#category : #initialization,
	#'squeak_changestamp' : 'mad 9/16/2026 00:30'
}
FlameGraphMorph >> initialize [
	super initialize.
	self basicZoom: 0.
]

{
	#category : #'event handling',
	#'squeak_changestamp' : 'mad 9/16/2026 01:20'
}
FlameGraphMorph >> keyStroke: anEvent [
	anEvent key caseOf: {
		[$W] -> [self zoom: self zoom + 1].
		[$S] -> [self zoom: self zoom - 1].
	} otherwise: [].
]

{
	#category : #'event handling',
	#'squeak_changestamp' : 'mad 9/16/2026 00:34'
}
FlameGraphMorph >> mouseDown: anEvent [
	anEvent redButtonPressed ifFalse: [^ self].
	anEvent hand mouseFocus = self ifFalse: [^ self].
	self findNodeAt: anEvent position below: self rootNode ifFound: [:node |
		Project current addDeferredUIMessage: [
			anEvent shiftPressed
				ifTrue: [node inspect]
				ifFalse: [node method homeMethod browse]]].
]

{
	#category : #sizing,
	#'squeak_changestamp' : 'mad 9/16/2026 01:27'
}
FlameGraphMorph >> nodeHeight [
	^ TextStyle defaultFont height + (2 * FlameGraph textPadding px)
]

{
	#category : #scrolling,
	#'squeak_changestamp' : 'mad 9/15/2026 23:28'
}
FlameGraphMorph >> preserveScrollingOffsetDuring: aBlock [
	| pane centerPercentage |
	pane := (self ownerThatIsA: ScrollPane) ifNil: [^ aBlock value].
	centerPercentage := (pane scroller offset x + (pane scroller width / 2)) / self width.
	^ aBlock ensure: [
		pane
			updateLayout;
			hScrollBarValue: centerPercentage * self width - (pane scroller width / 2)]
]

{
	#category : #sizing,
	#'squeak_changestamp' : 'mad 9/16/2026 00:28'
}
FlameGraphMorph >> recomputeExtent [
	self extent: (self widthOf: self rootNode) @ (self heightOf: self rootNode).
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 00:29'
}
FlameGraphMorph >> rootNode [
	^ rootNode
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 00:28'
}
FlameGraphMorph >> rootNode: aMessageTally [
	rootNode := aMessageTally.
	self recomputeExtent.
]

{
	#category : #sizing,
	#'squeak_changestamp' : 'mad 9/16/2026 01:20'
}
FlameGraphMorph >> widthOf: aMessageTally [
	^ aMessageTally tally px * ((self zoom * 0.2) exp)
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 00:27'
}
FlameGraphMorph >> zoom [
	^ zoom
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 00:30'
}
FlameGraphMorph >> zoom: aNumber [
	self preserveScrollingOffsetDuring: [
		self basicZoom: aNumber.
		self recomputeExtent].
]
