Class {
	#name : #FlameGraph,
	#superclass : #Model,
	#instVars : [
		'morph'
	],
	#classVars : [
		'FillAlpha',
		'MinimumTextWidth',
		'TextPadding'
	],
	#category : #FlameGraph
}

{
	#category : #preferences,
	#'squeak_changestamp' : 'mad 9/16/2026 01:15'
}
FlameGraph class >> fillAlpha [
	<preference: 'Flame Graph Context Background Fill Alpha'
		categoryList: #('Flame Graph')
		description: 'Fill context rectangles with a semi-transparent background. This sets the alpha, 0 means transparent background (faster, but less beautiful).'
		type: #String>
	^ FillAlpha ifNil: [0]
]

{
	#category : #preferences,
	#'squeak_changestamp' : 'mad 9/16/2026 01:39'
}
FlameGraph class >> fillAlpha: aNumber [
	FillAlpha := self
		numberPreferenceValue: aNumber
		check: [:alpha | (alpha between: 0 and: 1) ifFalse: [^ self error: 'alpha must be between 0 and 1']].
	Display restore.
]

{
	#category : #preferences,
	#'squeak_changestamp' : 'mad 9/16/2026 01:23'
}
FlameGraph class >> minimumTextWidth [
	<preference: 'Flame Graph Context Minimum Text Width'
		categoryList: #('Flame Graph')
		description: 'Only show labels of contexts when there are at least this many pixels available in width. The entered value is scaled using Number>>px.'
		type: #String>
	^ MinimumTextWidth ifNil: [20]
]

{
	#category : #preferences,
	#'squeak_changestamp' : 'mad 9/16/2026 01:40'
}
FlameGraph class >> minimumTextWidth: aNumber [
	MinimumTextWidth := self
		numberPreferenceValue: aNumber
		check: [:width | width ifFalse: [^ self error: 'width must not be negative']].
	Display restore.
]

{
	#category : #preferences,
	#'squeak_changestamp' : 'mad 9/16/2026 01:38'
}
FlameGraph class >> numberPreferenceValue: aNumberOrString check: aBlock [
	| parsed |
	aNumberOrString isEmptyOrNil ifTrue: [^ nil].
	parsed := aNumberOrString asNumber.
	aBlock value: parsed.
	^ parsed
]

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'mad 9/16/2026 00:28'
}
FlameGraph class >> on: aMessageTally [
	^ self new
		morph: (FlameGraphMorph on: aMessageTally);
		open
]

{
	#category : #preferences,
	#'squeak_changestamp' : 'mad 9/16/2026 01:26'
}
FlameGraph class >> textPadding [
	<preference: 'Flame Graph Context Text Padding'
		categoryList: #('Flame Graph')
		description: 'Pad labels of contexts with this many pixels. The entered value is scaled using Number>>px.'
		type: #String>
	^ TextPadding ifNil: [2]
]

{
	#category : #preferences,
	#'squeak_changestamp' : 'mad 9/16/2026 01:40'
}
FlameGraph class >> textPadding: aNumber [
	TextPadding := self
		numberPreferenceValue: aNumber
		check: [:padding | padding ifFalse: [^ self error: 'padding must not be negative']].
	Display restore.
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'mad 9/16/2026 00:30'
}
FlameGraph >> buildScrollerWith: builder [
	^ builder pluggableScrollPaneSpec new
		morph: self morph;
		hScrollBarPolicy: #whenNeeded;
		vScrollBarPolicy: #whenNeeded;
		frame: LayoutFrame fullFrame;
		yourself
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'mad 9/16/2026 00:21'
}
FlameGraph >> buildWindowWith: builder [
	^ builder pluggableWindowSpec new
		model: self;
		label: #windowTitle;
		children: {self buildScrollerWith: builder};
		yourself
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'mad 9/16/2026 00:19'
}
FlameGraph >> buildWith: builder [
	^ builder build: (self buildWindowWith: builder)
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 00:26'
}
FlameGraph >> morph [
	^ morph
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'mad 9/16/2026 00:26'
}
FlameGraph >> morph: aFlameGraphMorph [
	morph := aFlameGraphMorph
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'mad 9/16/2026 00:19'
}
FlameGraph >> open [
	ToolBuilder open: self.
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'mad 9/16/2026 00:30'
}
FlameGraph >> windowTitle [
	^ 'Flame Graph of {1}' format: {self morph rootNode}
]
