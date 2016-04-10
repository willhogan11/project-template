// This query returns a number coutns based on Gender. 
// The Total Available seats, Male/ Female elected counts and % of Female seats won. 

MATCH
	(con)-[r:CONSTITUENCY_OF]->(can)<-[m:MEMBER]-(p)
	WHERE can.IsElected = true 
		AND can.Gender = "Female"
RETURN 
	DISTINCT(con.Name) AS Area, 
			 con.Seats AS AvailableSeats, 
		    (con.Seats - COUNT(can.Gender = "Female")) AS Elected_M_Count,
			 COUNT(can.Gender = "Female") AS Elected_F_Count,
		    (COUNT(can.Gender = "Female") * 100 / con.Seats + "%") AS Elected_F_P
ORDER BY Elected_F_P DESC;
