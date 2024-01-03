/* Data Cleaning in SQL */

select * from NashvilleHousing

-- Apply Standard Date format
select SaleDate, CONVERT(Date, SaleDate) from NashvilleHousing

-- Updating the SaleDate to the Nashville Housing Table
Update NashvilleHousing
set SaleDate = CONVERT(Date, SaleDate)

-- some time it doesn;t work so we will alter the column
Alter Table NashvilleHousing
add SaleDateConverted Date;

Update NashvilleHousing
set SaleDateConverted = CONVERT(Date, SaleDate)

select SaleDateConverted from NashvilleHousing


--	Populate property Adress
select PropertyAddress from NashvilleHousing
where PropertyAddress is null

select * from NashvilleHousing
--where PropertyAddress is null


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
JOIN NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
JOIN NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


-- Breaking Addess into multiple column (Address, City, State)

select PropertyAddress from NashvilleHousing

Select SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)  as Address,
SUBSTRING(PropertyAddress,  CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress)) as City 
from NashvilleHousing


Alter Table NashvilleHousing
add propertySpilitAddress nvarchar(255);

Update NashvilleHousing
set propertySpilitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)


Alter Table NashvilleHousing
add propertySpilitCity nvarchar(255);

Update NashvilleHousing
set propertySpilitCity = SUBSTRING(PropertyAddress,  CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress))


-- Spiliting owner address

select OwnerAddress from NashvilleHousing

select
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from NashvilleHousing


-- UPDATE COLUMNS IN TABLE

Alter Table NashvilleHousing
add OwnerSpilitAddress nvarchar(255);

Update NashvilleHousing
set OwnerSpilitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

---
Alter Table NashvilleHousing
add OwnerSpilitCity nvarchar(255);

Update NashvilleHousing
set OwnerSpilitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

---

Alter Table NashvilleHousing
add OwnerSpilitState nvarchar(255);

Update NashvilleHousing
set OwnerSpilitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


------ convert Y and N to yes and No

select distinct(soldasvacant), count(soldasvacant) 
from NashvilleHousing
group by soldasvacant
order by 2


select soldasvacant,
CASE when soldasvacant = 'Y' Then 'Yes' 
	 when soldasvacant = 'N' Then 'No'
	 else soldasvacant
END
from NashvilleHousing
order by 2

--- UPDATING TABLE

UPDATE NashvilleHousing
SET soldasvacant = CASE when soldasvacant = 'Y' Then 'Yes' 
	 when soldasvacant = 'N' Then 'No'
	 else soldasvacant
END


-- REMOVE Duplicates
WITH Row_dupCTE AS (
select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER  BY UniqueID) row_dup
from NashvilleHousing
--order by ParcelID 
)
SELECT * FROM Row_dupCTE
WHERE row_dup > 1

-- DELETING DUPLICATES

WITH Row_dupCTE AS (
select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER  BY UniqueID) row_dup
from NashvilleHousing
--order by ParcelID 
)
DELETE FROM Row_dupCTE
WHERE row_dup > 1



---DELETE UNUSED DATA
SELECT * FROM NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, PropertyAddress, TaxDistrict



ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate
