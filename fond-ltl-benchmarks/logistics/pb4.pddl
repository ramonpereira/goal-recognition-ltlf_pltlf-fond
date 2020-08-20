(define (problem pb3)
(:domain logistics-strips)
(:objects
 airplane1 airplane2 airplane3 airplane4 airplane5 airplane6
 apt1 apt2 apt3 apt4 apt5 apt6
 pos66 pos55 pos44 pos33 pos21 pos22 pos23 pos11 pos12 pos13
 cit2 cit1 cit3 cit4 cit5 cit6
 truck1 truck2 truck3 truck4 truck5
 package55 package44 package33 package23 package22 package21 package13 package12 package11 package00)

(:init 
	(city cit1)
	(city cit2)
	(city cit3)
	(city cit4)
	(city cit5)
	(city cit6)

	(truck truck1)
	(truck truck2)
	(truck truck3)
	(truck truck4)
	(truck truck5)

	(not (flattire truck1))
	(not (flattire truck2))
	(not (flattire truck3))
	(not (flattire truck4))
	(not (flattire truck5))

	(airplane airplane1)
	(not (needfuel plane1))
	(airplane airplane2)
	(needfuel plane2)
	(airplane airplane3)
	(not (needfuel plane3))
	(airplane airplane4)
	(needfuel plane4)
	(airplane airplane5)
	(not (needfuel plane5))
	(airplane airplane6)
	(needfuel plane6)

	(location pos11)
	(location pos12)
	(location pos13)
	(location pos21)
	(location pos22)
	(location pos23)
	(location pos33)
	(location pos44)
	(location pos55)
	(location pos66)

	(airport apt1)
	(airport apt2)
	(airport apt3)
	(airport apt4)
	(airport apt5)
	(airport apt6)

	(at airplane1 apt2) 
	(at airplane2 apt1) 
	(at airplane3 apt1) 
	
	(at truck1 pos11) 
	(at truck3 pos12) 
	(at truck4 pos13) 
	(at truck2 pos22) 
	
	(package package11)
	(package package12)
	(package package13)
	(package package21)
	(package package22)
	(package package23)
	(package package55)
	(package package44)
	(package package33)
	(at package11 pos11) 
	(at package12 pos13) 
	(at package13 pos11)
	(at package21 pos21) 
	(at package22 pos21) 
	(at package23 pos22)
	(at package55 pos13) 
	(at package44 pos12) 
	(at package33 pos11)

	(sparetirein pos11)
    (sparetirein pos13)
	(sparetirein pos21)
	(sparetirein pos22)
	
	(incity apt1 cit1) 
	(incity pos11 cit1) 
	(incity pos12 cit1) 
	(incity pos13 cit1)
	
	(incity apt2 cit2) 
	(incity pos21 cit2) 
	(incity pos22 cit2) 
	(incity pos23 cit2)
	
	(incity pos33 cit4) 
	(incity pos44 cit4) 
	(incity pos55 cit4) 
	(incity pos66 cit5)
	
	(incity apt3 cit3) 
	(incity apt4 cit4) 
	(incity apt5 cit5) 
	(incity apt6 cit6)
)

(:goal 
	(and (at package23 pos11) (at package33 pos22))
))