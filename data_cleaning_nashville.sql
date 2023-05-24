--Standardize Date Format (Removing timestamp from the date column)

Select SaleDate , CONVERT(Date, SaleDate)
  From PortfolioProject.dbo.NashvilleHousing

Update PortfolioProject.dbo.NashvilleHousing
SET SaleDate = CONVERT (Date, SaleDate)


ALTER TABLE NashvilleHousing
Add SaleDateConverted Date

Update PortfolioProject.dbo.NashvilleHousing
SET SaleDateConverted = CONVERT (Date, SaleDate)


--Populating Address data (populating null values in address data)

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
Where PropertyAddress is null 


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.ParcelID, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b 
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
 SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
	From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b 
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


-- Breaking the adress column in ti individual columns (Address, City, State)

Select PropertyAddress
  From PortfolioProject.dbo.NashvilleHousing;

Select 
  SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1) as Address,
  SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress) +1,LEN(PropertyAddress)) as Address
  From PortfolioProject.dbo.NashvilleHousing;


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1);


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress) +1,LEN(PropertyAddress));



Select OwnerAddress 
From PortfolioProject.dbo.NashvilleHousing;

Select 
PARSENAME(REPLACE(OwnerAddress,',','.') ,3),
PARSENAME(REPLACE(OwnerAddress,',','.') ,2),
PARSENAME(REPLACE(OwnerAddress,',','.') ,1)
From PortfolioProject.dbo.NashvilleHousing;


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.') ,3);


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.') ,2);


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.') ,1);



-- Changing Y and N responses to Yes and No in "SoldAsVacant" field

Select DISTINCT(SoldAsVacant), COUNT (SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order By 2;

Select SoldAsVacant
	,CASE When SoldAsVacant ='Y' THEN 'Yes'
		  When SoldAsVacant ='N' THEN 'No'
		  ELSE SoldAsVacant
		  END
From PortfolioProject.dbo.NashvilleHousing;


Update PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant ='Y' THEN 'Yes'
		  When SoldAsVacant ='N' THEN 'No'
		  ELSE SoldAsVacant
		  END;


-- Removing Duplicates

WITH RowNumCTE AS(
Select * ,
	ROW_NUMBER() Over (
	PARTITION By ParcelID,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID) row_num
From  PortfolioProject.dbo.NashvilleHousing)
DELETE 
FROM RowNumCTE
Where row_num >1;




Select *
  From PortfolioProject.dbo.NashvilleHousing