Extension { #name : #CompiledCode }

{
	#category : #'*FlameGraph-printing',
	#'squeak_changestamp' : 'mad 9/16/2026 12:38'
}
CompiledCode >> flameGraphPrintOn: aStream [ 
	aStream
		print: self methodClass;
		nextPutAll: ' >> ';
		nextPutAll: self selector.
]
