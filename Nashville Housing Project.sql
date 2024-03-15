create database nashville

use nashville

--- Data Cleaning
select * from [dbo].['Nashville Housing$']

drop table dbo.['Nashville Housing$']
-- Adjust Sale Date Format
alter table dbo.['Nashville Housing$']
alter column SaleDate Date
go

-- Populate Property Address
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from [dbo].['Nashville Housing$'] as a
join dbo.['Nashville Housing$'] as b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] != b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from [dbo].['Nashville Housing$'] as a
join dbo.['Nashville Housing$'] as b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] != b.[UniqueID ]
where a.PropertyAddress is null

select * from [dbo].['Nashville Housing$']
where PropertyAddress is null

-- Breaking Down the Property Address into separate columns
select PropertyAddress from dbo.['Nashville Housing$']

select 
SUBSTRING(PropertyAddress, 1, charindex(',',PropertyAddress) -1 ) as Address,
SUBSTRING(PropertyAddress, charindex(',',PropertyAddress) +1 , len(PropertyAddress)) as Address
from dbo.['Nashville Housing$']

alter table dbo.['Nashville Housing$']
add PropertySplitAddress nvarchar(255)

update dbo.['Nashville Housing$']
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, charindex(',',PropertyAddress) -1 ) 

alter table dbo.['Nashville Housing$']
add PropertySplitCity nvarchar(255)

update dbo.['Nashville Housing$']
set PropertySplitCity = SUBSTRING(PropertyAddress, charindex(',',PropertyAddress) +1 , len(PropertyAddress))


select * from dbo.['Nashville Housing$']

-- Breaking Down the Owner Address into separate columns
select
PARSENAME(replace(OwnerAddress, ',','.'), 3),
PARSENAME(replace(OwnerAddress, ',','.'), 2),
PARSENAME(replace(OwnerAddress, ',','.'), 1)
from dbo.['Nashville Housing$']

alter table dbo.['Nashville Housing$']
add OwnerSplitAddress nvarchar(255)

update dbo.['Nashville Housing$']
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress, ',','.'), 3)

alter table dbo.['Nashville Housing$']
add OwnerSplitCity nvarchar(255)

update dbo.['Nashville Housing$']
set OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',','.'), 2)

alter table dbo.['Nashville Housing$']
add OwnerSplitState nvarchar(255)

update dbo.['Nashville Housing$']
set OwnerSplitState = PARSENAME(replace(OwnerAddress, ',','.'), 1)

select * from dbo.['Nashville Housing$']

--- Changing Y and N to Yes and No in Sold As Vacant
-- Y 
update dbo.['Nashville Housing$']
set SoldAsVacant = 'Yes'
where SoldAsVacant = 'Y'

-- N
update dbo.['Nashville Housing$']
set SoldAsVacant = 'No'
where SoldAsVacant = 'N'

-- Remove Duplicates using CTE's
with RowNumCTE AS(
select *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID, PropertyAddress
, SalePrice, SaleDate, LegalReference
order by UniqueID) row_num
from dbo.['Nashville Housing$']
)
delete
from RowNumCTE
where row_num > 1



-- Delete Unused Columns
select * from dbo.['Nashville Housing$']

alter table dbo.['Nashville Housing$']
drop column OwnerAddress, PropertyAddress


----- Exploratory Data Analysis
--- Sales count per year
alter table dbo.['Nashville Housing$']
add SaleYear int

update dbo.['Nashville Housing$']
set SaleYear = datepart(YEAR, SaleDate)

delete from dbo.['Nashville Housing$'] where SaleYear = 2019

select SaleYear, count(SaleYear) as Number_of_Sales from dbo.['Nashville Housing$']
group by SaleYear
order by SaleYear

--- Sales Value per Year
select SaleYear, sum(SalePrice) as Total_Sales from dbo.['Nashville Housing$']
group by SaleYear
order by SaleYear

--- Sales made per month for the 3 years
alter table dbo.['Nashville Housing$']
add SaleMonth nvarchar(50)

update dbo.['Nashville Housing$']
set SaleMonth = datename(MONTH, SaleDate)

select SaleMonth, count(SaleMonth) as Number_of_Sales from dbo.['Nashville Housing$']
group by SaleMonth
order by case when SaleMonth = 'January' then 1
when SaleMonth = 'February' then 2
when SaleMonth = 'March' then 3
when SaleMonth = 'April' then 4
when SaleMonth = 'May' then 5
when SaleMonth = 'June' then 6
when SaleMonth = 'July' then 7
when SaleMonth = 'August' then 8
when SaleMonth = 'September' then 9
when SaleMonth = 'October' then 10
when SaleMonth = 'November' then 11
when SaleMonth = 'December' then 12
else Null end

--- Sales Value per Month
select SaleMonth, sum(SalePrice) as Number_of_Sales from dbo.['Nashville Housing$']
group by SaleMonth
order by case when SaleMonth = 'January' then 1
when SaleMonth = 'February' then 2
when SaleMonth = 'March' then 3
when SaleMonth = 'April' then 4
when SaleMonth = 'May' then 5
when SaleMonth = 'June' then 6
when SaleMonth = 'July' then 7
when SaleMonth = 'August' then 8
when SaleMonth = 'September' then 9
when SaleMonth = 'October' then 10
when SaleMonth = 'November' then 11
when SaleMonth = 'December' then 12
else Null end 

--- Sales made by quarter for the 3 years
alter table dbo.['Nashville Housing$']
add SaleQuarter nvarchar(50)

update dbo.['Nashville Housing$']
set SaleQuarter = datepart(QUARTER, SaleDate)

update dbo.['Nashville Housing$']
set SaleQuarter = 'Q'+ SaleQuarter

select SaleQuarter, count(SaleQuarter) as Total_Sales from dbo.['Nashville Housing$']
group by SaleQuarter
order by SaleQuarter

-- Sales Value per Quarter
select SaleQuarter, sum(SalePrice) as Total_Sales from dbo.['Nashville Housing$']
group by SaleQuarter
order by SaleQuarter

-- Sales count by land use
select distinct LandUse from dbo.['Nashville Housing$']
select LandUse, count(LandUse) as Total_Sales from dbo.['Nashville Housing$']
group by LandUse
order by Total_Sales desc

--Sales Value by Land Use
select LandUse, sum(SalePrice) as Total_Sales from dbo.['Nashville Housing$']
group by LandUse
order by Total_Sales desc

-- Price Range of Sales
select max(SalePrice) as Most_Expensive, min(SalePrice) as Least_Expensive
from dbo.['Nashville Housing$']

select case
when SalePrice >= 1 and SalePrice <= 200000 then '0-200k'
when SalePrice >= 200001 and SalePrice <= 400000 then '200k-400k'
when SalePrice >= 400001 and SalePrice <= 600000 then '400k-600k'
when SalePrice >= 600001 and SalePrice <= 800000 then '600k-800k'
when SalePrice >= 800001 and SalePrice <= 1000000 then '800k-1m'
else 'Above 1m'
end as Sale_Price_Range,
COUNT(*) as Sales_Count
from dbo.['Nashville Housing$']
group by case
when SalePrice >= 1 and SalePrice <= 200000 then '0-200k'
when SalePrice >= 200001 and SalePrice <= 400000 then '200k-400k'
when SalePrice >= 400001 and SalePrice <= 600000 then '400k-600k'
when SalePrice >= 600001 and SalePrice <= 800000 then '600k-800k'
when SalePrice >= 800001 and SalePrice <= 1000000 then '800k-1m'
else 'Above 1m'
end
order by case
when SalePrice >= 1 and SalePrice <= 200000 then '0-200k'
when SalePrice >= 200001 and SalePrice <= 400000 then '200k-400k'
when SalePrice >= 400001 and SalePrice <= 600000 then '400k-600k'
when SalePrice >= 600001 and SalePrice <= 800000 then '600k-800k'
when SalePrice >= 800001 and SalePrice <= 1000000 then '800k-1m'
else 'Above 1m'
end

--- Count of Sales whether vacant or not
select SoldAsVacant, count(SoldAsVacant) as Number_of_Sales from dbo.['Nashville Housing$']
group by SoldAsVacant
order by Number_of_Sales desc

--Sales Value by Land Use
select SoldAsVacant, sum(SalePrice) as Sales_Value from dbo.['Nashville Housing$']
group by SoldAsVacant
order by Sales_Value desc

-- Sales count by tax district
select distinct TaxDistrict from dbo.['Nashville Housing$']
select TaxDistrict, count(TaxDistrict) as Number_of_Sales from dbo.['Nashville Housing$']
where TaxDistrict is not null
group by TaxDistrict
order by Number_of_Sales desc

--Sales Value by tax district
select TaxDistrict, sum(SalePrice) as Sales_Value from dbo.['Nashville Housing$']
where TaxDistrict is not null
group by TaxDistrict
order by Sales_Value desc

-- Sales count by Property City
select distinct PropertySplitCity from dbo.['Nashville Housing$']
select PropertySplitCity, count(PropertySplitCity) as Number_of_Sales from dbo.['Nashville Housing$']
where PropertySplitCity != 'UNKOWN'
group by PropertySplitCity
order by Number_of_Sales desc

--Sales Value by Property City
select PropertySplitCity, sum(SalePrice) as Sales_Value from dbo.['Nashville Housing$']
where PropertySplitCity != 'UNKOWN'
group by PropertySplitCity
order by Sales_Value desc

-- Sales count by Owner City
select distinct OwnerSplitCity from dbo.['Nashville Housing$']
select OwnerSplitCity, count(PropertySplitCity) as Number_of_Sales from dbo.['Nashville Housing$']
where OwnerSplitCity is not null
group by OwnerSplitCity
order by Number_of_Sales desc

--Sales Value by Owner City
select OwnerSplitCity, sum(SalePrice) as Sales_Value from dbo.['Nashville Housing$']
where OwnerSplitCity is not null
group by OwnerSplitCity
order by Sales_Value desc

-- Average Price per land use
select  landuse, round(avg(saleprice),0) as Avg_Price from [dbo].['Nashville Housing$']
group by landuse
order by Avg_Price
