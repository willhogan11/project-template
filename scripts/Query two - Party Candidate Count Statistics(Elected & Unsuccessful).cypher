/*
* Query two displays details about each party, ie the number if members in each and each parties performance,
* like the Total elected number of candidates and unsuccessful candidates. This query is designed to reflect the Parties performance in the Election. 
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
