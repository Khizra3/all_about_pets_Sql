
/* ===================================Assignment 2=======================================================*/
/* Q1: List the names of all pet owners along with the names of their pets.  */

SELECT * FROM petowners;
SELECT * FROM pets;

SELECT CONCAT(po.Name,po.Surname) AS owner_name,pe.Name AS pet_name
FROM petowners po
INNER JOIN pets pe ON po.OwnerID = pe.OwnerID;

/* Q2: List all pets and their owner names, including pets that don't have recorded owners. */

SELECT CONCAT(po.Name,po.Surname) AS owner_name, p.name
FROM petowners po
RIGHT JOIN pets p ON po.OwnerID = p.OwnerID;

/* Q3. Combine the information of pets and their owners, including those pets 
without owners and owners without pets */

SELECT * FROM petowners po
LEFT JOIN pets p ON po.OwnerID = p.OwnerID
UNION
SELECT * FROM petowners po
RIGHT JOIN pets p ON po.OwnerID = p.OwnerID; 


/* Q4. Find the names of pets along with their owners' names and the details of the 
procedures they have undergone
1. names of pets and owner
2. name and detail of procedure on the pet*/

SELECT (p.Name) AS pet_name,CONCAT(po.Name, ' ', po.Surname) AS owner_name,ph.ProcedureType,prd.Description
FROM petowners po
INNER JOIN pets p ON p.OwnerID = po.OwnerID
INNER JOIN procedureshistory ph ON p.PetID = ph.PetID
INNER JOIN proceduresdetails prd ON ph.ProcedureSubCode = prd.ProcedureSubCode;

/* Q5. List all pet owners and the number of dogs they own*/

SELECT po.Name,po.Surname,p.Kind, count(p.PetID) as count_of_dogs
FROM petowners po
LEFT JOIN pets p ON po.OwnerID = p.OwnerID
WHERE Kind = 'Dog'
group by po.name,po.Surname;


/*Q6. Identify pets that have not had any procedures*/

SELECT p.Name AS pet_name,ph.ProcedureType
FROM pets p 
LEFT JOIN procedureshistory ph ON p.PetID = ph.petID
WHERE ProcedureType IS NULL;

/*Q7. Find the name of the oldest pet*/

SELECT (Name) AS pet_name,MAX(Age) AS max_age
FROM pets
GROUP BY PetID, Name
ORDER BY max_age DESC
Limit 3;

/*Q8. List all pets who had procedures that cost more than the average cost of all 
procedures
1. name of pets whose proceure cost > than all AVG cost!
2. find avg cost
3. Then use subquery to equate it and use  > sign with main query*/

SELECT (p.Name) AS pet_name, 
prd.price
FROM pets p
INNER JOIN procedureshistory as ph on p.PetID = ph.petID
INNER JOIN proceduresdetails as prd on ph.ProcedureType = prd.ProcedureType
WHERE price  > (SELECT AVG(price) AS avg_cost 
FROM proceduresdetails);
#another method
SELECT
    p.PetID AS pet_ID,
    p.Name AS pet_Name,
    pd.price AS procedure_price
	from pets p
	LEFT JOIN procedures_history ph ON p.PetID=ph.PetID
	LEFT JOIN procedures_details pd ON ph.ProcedureType=Pd.ProcedureType 
    WHERE pd.price IS NOT NULL AND pd.price > (SELECT AVG(pd.Price) from procedures_details pd);
/*Q9. Find the details of procedures performed on 'Cuddles'.*/

SELECT p.Name,p.OwnerID,ph.ProcedureType,pd.Description,pd.Price
FROM pets p
LEFT JOIN procedureshistory ph ON p.PetID= ph.PetID
LEFT JOIN proceduresdetails pd ON ph.ProcedureType = pd.ProcedureType
WHERE p.Name = 'Cuddles';


/*Q10. Create a list of pet owners along with the total cost they have spent on 
procedures and display only those who have spent above the average 
spending
  - List of pet owners - total cost of procedures
  - spent above average spending*/

SELECT DISTINCT(po.Name) AS owner_name,
SUM(pd.price) AS total_cost,
AVG(pd.price) AS avg_cost
FROM petowners po
INNER JOIN pets p ON po.OwnerID = p.OwnerID
INNER JOIN procedureshistory ph ON p.PetID = ph.PetID
INNER JOIN proceduresdetails pd ON ph.ProcedureType = pd.ProcedureType
GROUP BY po.Name
HAVING total_cost > avg_cost;

/*Q11. List the pets who have undergone a procedure called 'VACCINATIONS'. */

SELECT p.PetID
(p.Name) AS pet_name,
ph.ProcedureType
FROM pets p
LEFT JOIN 
procedureshistory ph ON p.PetID= ph.PetID
WHERE ProcedureType = 'VACCINATIONS';

# another method: 
SELECT p.petID, p.Name, pd.ProcedureType
    FROM pets p
	LEFT JOIN procedures_history ph ON p.PetID=ph.PetID
	LEFT JOIN procedures_details pd ON ph.ProcedureType=Pd.ProcedureType 
	WHERE pd.ProcedureType = "VACCINATIONS"
    GROUP BY p.PetID,p.Name;
/*Q12. Find the owners of pets who have had a procedure called 'EMERGENCY'*/

SELECT 
(p.Name) AS pet_name,
ph.ProcedureType
FROM pets p
LEFT JOIN 
procedureshistory ph ON p.PetID= ph.PetID
WHERE ProcedureType = 'EMERGENCY';

/*Q13.Calculate the total cost spent by each pet owner on procedures.*/

SELECT po.OwnerID,(po.Name) AS Owner_name,
SUM(pd.price) AS total_cost
FROM petowners po
LEFT JOIN 
pets p ON po.OwnerID = p.OwnerID
LEFT JOIN 
procedureshistory ph  ON ph.PetID = p.PetID
LEFT JOIN 
proceduresdetails pd ON ph.ProcedureType = pd.ProcedureType   
GROUP BY po.OwnerID, po.Name, pd.price;

/*Q14. Count the number of pets of each kind*/

SELECT Kind, COUNT(Kind) as total_pets
FROM pets
GROUP BY Kind;

/*Q15. Group pets by their kind and gender and count the number of pets in each group.*/

SELECT Kind,Gender,
COUNT(*) AS no_of_pets 
FROM pets
GROUP BY Kind,Gender;

/*Q16. Show the average age of pets for each kind, but only for kinds that have more 
than 5 pets*/

SELECT
DISTINCT(KIND) AS type_pet,
ROUND(AVG(Age),1) AS avg_age
FROM pets
GROUP BY Kind
HAVING COUNT(Kind) >5;

/*Q17. Find the types of procedures that have an average cost greater than $50*/

SELECT * FROM proceduresdetails;
SELECT ProcedureType,ROUND(AVG(Price),3)AS avg_cost
FROM proceduresdetails
GROUP BY ProcedureType
HAVING AVG(Price) >50;

/*Q18. Classify pets as 'Young', 'Adult', or 'Senior' based on their age. Age less then 
3 Young, Age between 3and 8 Adult, else Senior*/

SELECT 
Name,
Age,
CASE
	WHEN Age < 3 THEN 'Young'
	WHEN Age BETWEEN 3 AND 8 THEN 'Adult'
	ELSE 'Senior'
END AS pet_classification
FROM pets;

/*Q19. .Calculate the total spending of each pet owner on procedures, labeling them 
as 'Low Spender' for spending under $100, 'Moderate Spender' for spending 
between $100 and $500, and 'High Spender' for spending over $500*/

SELECT (po.Name) AS pet_owner,
SUM(pd.Price) AS total_spending,
CASE
	WHEN SUM(pd.Price) < 100 THEN 'Low Spender'
	WHEN SUM(pd.Price) BETWEEN 100 AND 500 THEN 'Moderate Spender'
	WHEN SUM(pd.Price) IS NULL then 'No spending'
    ELSE 'High Spender'
END AS expense_class
FROM petowners po
LEFT JOIN pets p ON po.OwnerID = p.OwnerID
LEFT JOIN procedureshistory ph ON p.PetID = ph.PetID
LEFT JOIN proceduresdetails pd ON ph.ProcedureType = pd.ProcedureType
GROUP BY po.Name,ph.ProcedureType,po.OwnerID, p.PetID;

/*Q20. .Show the gender of pets with a custom label ('Boy' for male, 'Girl' for female)*/

SELECT * FROM pets;
SELECT PetID,Kind,
CASE
	WHEN Gender = 'male' THEN 'Boy'
    WHEN Gender = 'female' THEN 'Girl'
END AS updated_gender 
FROM pets;

/*Q21. .For each pet, display the pet's name, the number of procedures they've had, 
and a status label: 'Regular' for pets with 1 to 3 procedures, 'Frequent' for 4 to 
7 procedures, and 'Super User' for more than 7 procedures*/

SELECT p.PetID, p.Name,
COUNT(ph.ProcedureSubCode) AS num_procedures,
CASE
	WHEN COUNT(ph.ProcedureSubCode) BETWEEN 1 AND 3 THEN 'Regular'
    WHEN COUNT(ph.ProcedureSubCode) BETWEEN 4 AND 7 THEN 'Frequent'
    WHEN COUNT(ph.ProcedureSubCode) = 0 THEN 'N/A'
    ELSE 'Super User'
END AS status_label
FROM pets p
LEFT JOIN procedureshistory ph ON p.PetID = ph.PetID
GROUP BY p.PetID, p.Name;

/*Q22. Rank pets by age within each kind*/

SELECT 
Kind,
RANK() OVER(ORDER BY Age DESC) AS ranking
FROM pets;

/*Q23. Assign a dense rank to pets based on their age, regardless of kind*/

SELECT PetID,(Name) As pet_name,Age,
DENSE_RANK() OVER (ORDER BY Age) AS age_dense_rank
FROM pets;

/*Q24. For each pet, show the name of the next and previous pet in alphabetical order.*/ 

SELECT PetID, Name,
LAG(Name) OVER (ORDER BY Name) AS previous_pet,
LEAD(Name) OVER (ORDER BY Name) AS next_pet
FROM pets
ORDER BY Name;

/*25.Show the average age of pets, partitioned by their kind. */

SELECT PetID,Name,Age, Kind,
AVG(Age) OVER (PARTITION BY Kind) AS avg_age_by_kind
FROM pets
Group by Kind;

/*26.Create a CTE that lists all pets, then select pets older than 5 years from the CTE*/

WITH AllPets AS (
    SELECT PetID,Name,Kind,Gender,Age,OwnerID
    FROM pets
)
SELECT PetID,Name,Kind,Gender,Age,OwnerID
FROM AllPets
WHERE Age > 5;