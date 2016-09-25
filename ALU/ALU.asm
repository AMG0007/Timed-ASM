asm ALU

import StandardLibrary

signature:
	// DOMAINS
	domain Register subsetof Integer
	domain Word subsetof Integer
	// FUNCTIONS
	controlled reg: Register -> Word
	monitored instr : Prod(Register,Register,Register)
	controlled v1 : Word
	controlled v2 : Word
	controlled rd : Register

definitions:
	// DOMAIN DEFINITIONS
	domain Register = {0..31}
	domain Word = {0..255}
	
	// INVARIANTS
	invariant over rd : rd != 0 

	// MAIN RULE
	main rule r_Main =
		par
			rd := first(instr)
			v1 := reg(second(instr))
			v2 := reg(third(instr))
			if v1 != undef and v2 != undef and rd !=undef then
					if v1 + v2 <= 255 then
							reg(rd):= v1 + v2
					endif
			endif
		endpar

// INITIAL STATE
default init s0:
	function reg($a in Register) = $a
