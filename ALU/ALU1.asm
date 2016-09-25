

asm ALU1

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
	static ur_wb : UpdateRule
definitions:
	// DOMAIN DEFINITIONS
	domain Register = {0..31}
	domain Word = {0..255}

	// FUNCTION DEFINITIONS
	

	// RULE DEFINITIONS
	rule r_updateRule=
		switch self 
			case ur_r3 : rd := first(instr)
			case ur_r1 : v1 := reg(second(instr))
			case ur_r2 : v2 := reg(third(instr))
			case ur_wb : if v1 != undef and v2 != undef and rd !=undef then
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
