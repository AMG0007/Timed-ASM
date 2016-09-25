
asm ALU2

import StandardLibrary

signature:
	// DOMAINS
	domain UpdateRule subsetof Agent
	domain Register subsetof Integer
	domain Word subsetof Integer
	// FUNCTIONS
	controlled reg: Register -> Word
	monitored instr : Prod(Register,Register,Register)
	controlled v1 : Word
	controlled v2 : Word
	controlled rd : Register

	static ur_r1 : UpdateRule
	static ur_r2 : UpdateRule
	static ur_r3 : UpdateRule
	static ur_wb: UpdateRule
	
	controlled min : Integer
	controlled delay : UpdateRule -> Integer
	controlled ct : Integer
	
definitions:
	// DOMAIN DEFINITIONS
	domain Register = {0..31}
	domain Word = {0..255}

	// FUNCTION DEFINITIONS
	

	// RULE DEFINITIONS
	rule r_min =
		seq 
			choose $x in UpdateRule with delay($x) != 0 do
				min := delay($x)
			while (exist $y in UpdateRule with delay($y)!= 0 and  delay($y) <min) do
				choose $z in UpdateRule with  delay($z) != 0 do
					min :=  delay($z)
		endseq
	
	rule r_updateRule =
		switch (self)
			case ur_r3 : rd := first(instr)
			case ur_r1 : v1 := reg(second(instr))
			case ur_r2 : v2 := reg(third(instr))
			case ur_wb : if v1 + v2 <= 255 then
							reg(rd):= v1 + v2
						endif
		endswitch
	
	rule r_delayedUpdateRule =
		par
			if delay(self) = min then
				r_updateRule[] 
			endif
			if delay(self) - min > 0 then
					delay(self):= delay(self) - min
			endif
		endpar
		
	// INVARIANTS
	invariant over rd : rd != 0 
	// MAIN RULE
	main rule r_Main =
		seq
			r_min[]
			forall $x in UpdateRule do
			program($x)
			ct:= ct + min
		endseq

// INITIAL STATE
default init s0:
	function reg($a in Register) = $a
	function delay($x in UpdateRule) = switch $x
			case ur_r3 : 2
			case ur_r1 : 2
			case ur_r2 : 2
			case ur_wb : 4
		endswitch
	function ct = 0
	agent UpdateRule :
		r_delayedUpdateRule[]
	
