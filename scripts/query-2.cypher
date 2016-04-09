/*
* This query returns different statistical information
*/

MATCH(can)<-[m:MEMBER]-(p)
RETURN 
	DISTINCT(p.Name) AS Party, 
	STR("Total Members") AS Election_Info, 
	COUNT(can) AS Party_Candidate_Count
ORDER BY Party_Candidate_Count DESC

UNION ALL

MATCH(can)<-[m:MEMBER]-(p)
	WHERE can.IsElected = true
RETURN 
	DISTINCT(p.Name) AS Party, 
	STR("Elected Candidate Count") AS Election_Info,
	COUNT(can) AS Party_Candidate_Count 
ORDER BY Party_Candidate_Count DESC

UNION ALL

MATCH(can)<-[m:MEMBER]-(p)
	WHERE can.IsElected = false
RETURN 
	DISTINCT(p.Name) AS Party, 
	STR("Not Elected Candidate Count") AS Election_Info,
	COUNT(can) AS Party_Candidate_Count
ORDER BY Party_Candidate_Count DESC;