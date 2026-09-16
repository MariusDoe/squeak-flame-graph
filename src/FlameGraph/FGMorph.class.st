Class {
	#name : #FGMorph,
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
FGMorph class >> on: aMessageTally [
	^ self new
		rootNode: aMessageTally;
		yourself
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 00:29'
}
FGMorph >> basicZoom: aNumber [
	zoom := aNumber.
]

{
	#category : #drawing,
	#'squeak_changestamp' : 'mad 9/16/2026 10:40'
}
FGMorph >> colorFor: anFGNode [
	^ [WeakIdentityKeyDictionary new] once at: anFGNode colorKey ifAbsentPut: [Color random]
]

{
	#category : #drawing,
	#'squeak_changestamp' : 'mad 9/16/2026 11:06'
}
FGMorph >> drawChildrenOf: anFGNode on: aCanvas startingAt: aPoint textWithin: aRectangle [
	anFGNode children do: [:each |
		self drawNodeAndChildren: each on: aCanvas startingAt: aPoint + (each startOffset * self zoomFactor @ 0) textWithin: aRectangle].
]

{
	#category : #drawing,
	#'squeak_changestamp' : 'mad 9/16/2026 10:41'
}
FGMorph >> drawNode: anFGNode on: aCanvas in: nodeRectangle textWithin: textBoundsRectangle [
	| nodeColor textRectangle continued |
	(nodeRectangle intersects: aCanvas clipRect) ifFalse: [^ self].
	nodeColor := self colorFor: anFGNode.
	FlameGraph fillAlpha > 0 ifTrue: [
		aCanvas fillRectangle: nodeRectangle color: (nodeColor alpha: FlameGraph fillAlpha)].
	aCanvas frameRectangle: nodeRectangle color: nodeColor.
	textRectangle := nodeRectangle left: (nodeRectangle left clampLow: textBoundsRectangle left).
	continued := textRectangle left > nodeRectangle left.
	textRectangle := textRectangle insetBy: FlameGraph textPadding px.
	textRectangle width >= FlameGraph minimumTextWidth px ifTrue: [ | string |
		string := anFGNode printString.
		continued ifTrue: [string := '...{1}' format: {string}].
		aCanvas drawString: string in: textRectangle font: nil color: nodeColor].
]

{
	#category : #drawing,
	#'squeak_changestamp' : 'mad 9/16/2026 10:41'
}
FGMorph >> drawNodeAndChildren: anFGNode on: aCanvas startingAt: aPoint textWithin: aRectangle [
	| rectangle |
	rectangle := aPoint extent: (self widthOf: anFGNode) @ self nodeHeight.
	(rectangle width >= 1 and: [(rectangle withHeight: Float infinity) intersects: aCanvas clipRect]) ifFalse: [^ self].
	self
		drawNode: anFGNode on: aCanvas in: rectangle textWithin: aRectangle;
		drawChildrenOf: anFGNode on: aCanvas startingAt: aPoint x @ (aPoint y + self nodeHeight) textWithin: aRectangle.
]

{
	#category : #drawing,
	#'squeak_changestamp' : 'mad 9/16/2026 01:19'
}
FGMorph >> drawOn: aCanvas [
	| textBounds |
	textBounds := (self ownerThatIsA: ScrollPane)
		ifNil: [self bounds]
		ifNotNil: [:pane | pane scroller offset extent: pane scroller extent].
	aCanvas clipBy: self bounds during:
		[:canvas | self drawNodeAndChildren: self rootNode on: canvas startingAt: self position textWithin: textBounds].
]

{
	#category : #'event handling',
	#'squeak_changestamp' : 'mad 9/16/2026 11:06'
}
FGMorph >> findNodeAt: aPoint below: anFGNode ifFound: aBlock [
	(aPoint y >= 0 and: [aPoint x between: 0 and: (self widthOf: anFGNode)]) ifFalse: [^ self].
	aPoint y <= self nodeHeight ifTrue: [^ aBlock value: anFGNode].
	anFGNode children do: [:each |
		self
			findNodeAt: aPoint - (each startOffset * self zoomFactor @ self nodeHeight)
			below: each
			ifFound: [:node | ^ aBlock value: node]].
]

{
	#category : #'event handling',
	#'squeak_changestamp' : 'mad 9/15/2026 22:21'
}
FGMorph >> handlesKeyboard: anEvent [
	^ true
]

{
	#category : #'event handling',
	#'squeak_changestamp' : 'mad 9/15/2026 23:35'
}
FGMorph >> handlesMouseDown: anEvent [
	^ true
]

{
	#category : #sizing,
	#'squeak_changestamp' : 'mad 9/16/2026 10:40'
}
FGMorph >> heightOf: anFGNode [
	^ anFGNode depth * self nodeHeight
]

{
	#category : #initialization,
	#'squeak_changestamp' : 'mad 9/16/2026 00:30'
}
FGMorph >> initialize [
	super initialize.
	self basicZoom: 0.
]

{
	#category : #'event handling',
	#'squeak_changestamp' : 'mad 9/16/2026 01:20'
}
FGMorph >> keyStroke: anEvent [
	anEvent key caseOf: {
		[$W] -> [self zoom: self zoom + 1].
		[$S] -> [self zoom: self zoom - 1].
	} otherwise: [].
]

{
	#category : #'event handling',
	#'squeak_changestamp' : 'mad 9/16/2026 10:44'
}
FGMorph >> mouseDown: anEvent [
	anEvent redButtonPressed ifFalse: [^ self].
	anEvent hand mouseFocus = self ifFalse: [^ self].
	self findNodeAt: anEvent position below: self rootNode ifFound: [:node |
		Project current addDeferredUIMessage: [
			node mouseDown: anEvent]].
]

{
	#category : #sizing,
	#'squeak_changestamp' : 'mad 9/16/2026 01:27'
}
FGMorph >> nodeHeight [
	^ TextStyle defaultFont height + (2 * FlameGraph textPadding px)
]

{
	#category : #scrolling,
	#'squeak_changestamp' : 'mad 9/15/2026 23:28'
}
FGMorph >> preserveScrollingOffsetDuring: aBlock [
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
FGMorph >> recomputeExtent [
	self extent: (self widthOf: self rootNode) @ (self heightOf: self rootNode).
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 00:29'
}
FGMorph >> rootNode [
	^ rootNode
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 10:41'
}
FGMorph >> rootNode: anFGNode [
	rootNode := anFGNode.
	self recomputeExtent.
]

{
	#category : #sizing,
	#'squeak_changestamp' : 'mad 9/16/2026 11:05'
}
FGMorph >> widthOf: anFGNode [
	^ anFGNode width * self zoomFactor
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 00:27'
}
FGMorph >> zoom [
	^ zoom
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 00:30'
}
FGMorph >> zoom: aNumber [
	self preserveScrollingOffsetDuring: [
		self basicZoom: aNumber.
		self recomputeExtent].
]

{
	#category : #sizing,
	#'squeak_changestamp' : 'mad 9/16/2026 11:04'
}
FGMorph >> zoomFactor [
	^ 1 px * ((self zoom * 0.2) exp)
]
