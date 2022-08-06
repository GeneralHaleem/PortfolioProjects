#SELECTING MY ENTIRE DATA
SELECT 
    *
FROM
    nashville_housing;
    
#Creating Duplicates for Backup
CREATE TABLE dup_nashville_housing AS SELECT * FROM
    nashville_housing; 
    
#STANDARDIZING THE DATE FORMART   
   
SELECT 
    SaleDate, CONVERT( SaleDate , DATE)
FROM
    nashville_housing;

#Updateing the Table
SET sql_safe_updates = 0;

UPDATE nashville_housing 
SET 
    SaleDate = CONVERT( SaleDate , DATE);

#POPULATING PROPERTY ADDRESS DATA

SELECT 
    *
FROM
    nashville_housing
WHERE
    PropertyAddress IS NULL;
    
#Since they are some duplicated ParcelID and they have similar ProperyAddress
#I'd use the ParcelID to populate the property address
#Self join the table to itself
    
UPDATE nashville_housing A
        JOIN
    nashville_housing B ON A.ParcelID = B.ParcelID
        AND A.UniqueID != B.UniqueID 
SET 
    A.PropertyAddress = IFNULL(A.PropertyAddress, B.PropertyAddress)
WHERE
    A.PropertyAddress IS NULL; 

#Checking
SELECT 
    PropertyAddress
FROM
    nashville_housing
WHERE
    PropertyAddress IS NULL;
    
#BREAKING ADDRESS INTO INDIVIDUAL COLUMNS (Address, City, Country)

#Working on PropertyAddress
SELECT 
    PropertyAddress
FROM
    nashville_housing;

SELECT 
    SUBSTRING(PropertyAddress,
        1,
        LOCATE(',', PropertyAddress) - 1) AS Address,
    SUBSTRING(PropertyAddress,
        LOCATE(',', PropertyAddress) + 1) AS City
FROM
    nashville_housing;
    
#Creating  columns for the New address

ALTER TABLE nashville_housing
ADD Property_Address VARCHAR(200); 

ALTER TABLE nashville_housing
ADD Property_City VARCHAR(200); 

#Inserting the values into the newly Created Column

UPDATE nashville_housing 
SET 
    Property_Address = SUBSTRING(PropertyAddress,
        1,
        LOCATE(',', PropertyAddress) - 1);
        
UPDATE nashville_housing 
SET 
    Property_City = SUBSTRING(PropertyAddress,
        LOCATE(',', PropertyAddress) + 1); 
        
#Working on OwnerAddress  
SELECT 
    OwnerAddress
FROM
    nashville_housing;
    
SELECT 
    SUBSTRING(OwnerAddress,
        1,
        LOCATE(',', OwnerAddress) - 1) AS OwnersplitAddress,
    SUBSTRING(OwnerAddress,
        LOCATE(',', OwnerAddress) + 1) AS OwnersplitCity
FROM
    nashville_housing;
    
#Creating the columns    
ALTER TABLE nashville_housing
ADD Owner_Address VARCHAR(200);  

ALTER TABLE nashville_housing
ADD Owner_City VARCHAR(200);

#Inserting the values into the newly Created columns
UPDATE nashville_housing 
SET 
    Owner_Address = SUBSTRING(OwnerAddress,
        1,
        LOCATE(',', OwnerAddress) - 1);

SET sql_safe_updates = 0;

UPDATE nashville_housing 
SET 
    Owner_City =     SUBSTRING(OwnerAddress,
        LOCATE(',', OwnerAddress) + 1);  
        
SELECT 
    SUBSTRING(Owner_City,
        LOCATE(',', Owner_City) + 1) AS Ownercountry
FROM nashville_housing;       


ALTER TABLE nashville_housing
ADD Owner_Country VARCHAR(200);

UPDATE nashville_housing 
SET 
    Owner_Country =      SUBSTRING(Owner_City,
        LOCATE(',', Owner_City) + 1);
 
 
SELECT 
    SUBSTRING(Owner_City,
        1,
        LOCATE(',', Owner_City) - 1)
FROM
    nashville_housing;

ALTER TABLE nashville_housing
ADD OwnerCity VARCHAR(200);

UPDATE nashville_housing 
SET 
    OwnerCity = SUBSTRING(Owner_City,
        1,
        LOCATE(',', Owner_City) - 1);  

        
#Changing Y and N to YES and NO in SoldAsVacant COLUMN

SELECT 
    SoldAsVacant
FROM
    nashville_housing;        
        
    
UPDATE nashville_housing 
SET 
    SoldAsVacant = CASE
        WHEN SoldAsVacant = 'Y' THEN 'Yes'
        WHEN SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant
    END;
    
#Deleting unused columns

SELECT 
    *
FROM
    nashville_housing;

ALTER TABLE nashville_housing
DROP COLUMN PropertyAddress;

ALTER TABLE nashville_housing
DROP COLUMN OwnerAddress;

ALTER TABLE nashville_housing
DROP COLUMN PropertyAddress;
   
#Re-Spelling wrongly spelt columns
ALTER TABLE nashville_housing
CHANGE Acreage Average DOUBLE;

#OVERALL VIEW
	
SELECT 
    *
FROM
    nashville_housing;
    

    
   
    

    