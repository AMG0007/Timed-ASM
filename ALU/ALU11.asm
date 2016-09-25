

asm ALU11

import StandardLibrary

signature:
	// DOMAINS
	domain UpdateRule subsetof Agent
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
	static ur_r1 : UpdateRule
	static ur_r2 : UpdateRule
	static ur_r3 : UpdateRule
	static ur_wb : UpdateRule

definitions:
	// DOMAIN DEFINITIONS
	domain Register = {0..31}
	domain Word = {0..255}

	// FUNCTION DEFINITIONS
	

	// RULE DEFINITIONS
	rule r_updateRule=
		switch self 
			case ur_r3 : rd := instr1
			case ur_r1 : v1 := reg(instr2)
			case ur_r2 : v2 := reg(instr3)
			case ur_wb : if (exist $x in Register with $x=rd) then 
							if v1 + v2 <= 255 then
								reg(rd):= v1 + v2
							endif
						endif
		endswitch
	

	// INVARIANTS
	//invariant over rd : rd != 0
	// MAIN RULE
	main rule r_Main =
			forall $x in UpdateRule do
				program($x)

// INITIAL STATE
default init s0:
	function reg($a in Register) = $a
	agent UpdateRule :
		r_updateRule[]