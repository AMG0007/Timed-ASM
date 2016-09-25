asm ALU0

import StandardLibrary

signature:
	// DOMAINS
	domain Register subsetof Integer
	domain Word subsetof Integer
	// FUNCTIONS
	controlled reg: Register -> Word
	monitored instr1 : Register
	monitored instr2 : Register
	monitored instr3 : Register
	controlled v1 : Word
	controlled v2 : Word
	controlled rd : Register

definitions:
	// DOMAIN DEFINITIONS
	domain Register = {0..31}
	domain Word = {0..255}
	
	// INVARIANTS
	//invariant over rd : rd != 0 

	// MAIN RULE
	main rule r_Main =
		par
			rd := instr1
			v1 := reg(instr2)
			v2 := reg(instr3)
			if (exist $x in Register with $x = rd) then
					if v1 + v2 <= 255 then
							skip
					endif
			endif
		endpar

// INITIAL STATE
default init s0:
	function reg($a in Register) = $a
