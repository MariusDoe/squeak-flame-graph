Extension { #name : #CompiledBlock }

{
	#category : #'*FlameGraph-printing',
	#'squeak_changestamp' : 'mad 9/16/2026 12:40'
}
CompiledBlock >> flameGraphPrintOn: aStream [
	aStream nextPutAll: '[] in '.
	self outerCode flameGraphPrintOn: aStream.
]
