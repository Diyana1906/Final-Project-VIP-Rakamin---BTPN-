
-- Menggabungkan tabel category_db, Education_db, marital_db ke dalam tabel customer_data story 
Alter table ProjectBTPN..customer_data_history$
alter column Card_Categoryid nvarchar

select *
from ProjectBTPN..customer_data_history$ cdh
	join ProjectBTPN..category_db$ cd on cdh.card_categoryid = cd.id
	join ProjectBTPN..education_db$ ed on cdh.Educationid = ed.id
	join ProjectBTPN..marital_db$ md on cdh.Maritalid = md.id
-- 1. Membuat kolom baru 
Alter table ProjectBTPN..customer_data_history$
add Card_Category nvarchar(50), Education nvarchar(50), MaritalStatus nvarchar(50),Status nvarchar(50)
-- 2. Menggabung kan data 
Update cdh 
set cdh.Card_category= cd.Card_Category,
	cdh.Education = ed.Education_Level,
	cdh.MaritalStatus = md.Marital_Status,
	cdh.Status = sd.status
from ProjectBTPN..customer_data_history$ cdh
	join ProjectBTPN..category_db$ cd on cdh.card_categoryid = cd.id
	join ProjectBTPN..education_db$ ed on cdh.Educationid = ed.id
	join ProjectBTPN..marital_db$ md on cdh.Maritalid = md.id
	join ProjectBTPN..status_db$ sd on cdh.idstatus = sd.id 
where cdh.card_categoryid = cd.id
	 and cdh.educationid = ed.id
	and cdh.Maritalid = md.id
	and cdh.idstatus = sd.id
-- cek apakah berhasil 
select idstatus, status,Educationid, education, Maritalid,Maritalstatus, card_categoryid, card_category
from ProjectBTPN..customer_data_history$

-------------------------------------------------------------------------------------------------------------------------------

--Menghapus kolom yang tidak penting 
Alter table  ProjectBTPN..customer_data_history$
drop column idstatus, educationid, Maritalid, card_categoryid

select *
from ProjectBTPN..customer_data_history$

-------------------------------------------------------------------------------------------------------------------------------
-- EDA (Explorasi Data Analysis)
-------------------------------------------------------------------------------------------------------------------------------
-- KATEGORI PENDAPATAN 
------------------------------------------------------------------------------------------------------------------------------


--Membandingkan status customer(atrisi) dengan tingkat pendapatan
select count(Income_Category) as CountIncomecategory, 
	Income_Category, status
from ProjectBTPN..customer_data_history$
group by Income_Category, status
order by 3,1 desc
--Hasil tingkat pendapatan terendah memiliki tingkat atrisi yang tinggi 

----------------------------------------------------------------------------------------------------------------------------
--Membandingkan status customer (atrisi) dengan tingkat pendidikan 

select count(Income_Category) as CountIncome, 
	Education,Income_Category
from ProjectBTPN..customer_data_history$
where 
status = 'Attrited Customer'
group by Education, Income_Category
order by 1 desc

--(Hasil: Tingkat atrisi tertinggi pada tingkat 
--pendidikan Sarjana dan SMA dengan pendapatan Less than 40K)

select count(Income_Category) as CountIncome, 
	Education,Income_Category
from ProjectBTPN..customer_data_history$
where 
status = 'Existing Customer'
group by Education, Income_Category
order by 3 desc
---------------------------------------------------------------------------------------------------------------------------------
---Melihat Korelasi antara Credit limit dengan 
--korelasi bergulir pada setiap kategory income

select count(Credit_limit) as CountCredLimit, 
	Credit_Limit, Total_Revolving_Bal
from ProjectBTPN..customer_data_history$
where 
Income_Category = 'Less than $40K '
and 
Status = 'Attrited Customer'
group by Credit_Limit,Total_Revolving_Bal
order by 1 desc

--(Hasil tingkat kredit limit yang rendah memiliki jumlah customer  yang tinggi yaitu 195
-- namun dengan korelasi bergulir 0 pada kategori pendapatan customer paling rendah

select count(Credit_limit) as CountCredLimit, 
	Credit_Limit, Total_Revolving_Bal
from ProjectBTPN..customer_data_history$
where 
Income_Category = '$40K - $60K'
and Status = 'Attrited Customer'
group by Credit_Limit,Total_Revolving_Bal
order by 1 desc

--(Hasil tingkat kredit limit yang rendah memiliki jumlah customer  yang tinggi yaitu 64
-- namun dengan korelasi bergulir 0 pada kategori pendapatan customer $40K - $60K

select count(Credit_limit) as CountCredLimit, 
	Credit_Limit, Total_Revolving_Bal
from ProjectBTPN..customer_data_history$
where 
Income_Category = '$60K - $80K' 
and Status = 'Attrited Customer'
group by Credit_Limit,Total_Revolving_Bal
order by 1 desc

--(Hasil tingkat kredit limit yang rendah memiliki jumlah customer  yang tinggi yaitu 21
-- namun dengan korelasi bergulir 0 pada kategori pendapatan customer $60K - $80K

select count(Credit_limit) as CountCredLimit, 
	Credit_Limit, Total_Revolving_Bal
from ProjectBTPN..customer_data_history$
where 
Income_Category = '$80K - $120K'
and Status = 'Attrited Customer'
group by Credit_Limit,Total_Revolving_Bal
order by 1 desc

--(Hasil tingkat kredit limit yang paling tinggi memiliki jumlah customer  yang tinggi yaitu 43
-- namun dengan korelasi bergulir 0 pada kategori pendapatan customer $80K - $120K


select count(Credit_limit) as CountCredLimit, 
	Credit_Limit, Total_Revolving_Bal
from ProjectBTPN..customer_data_history$
where 
Income_Category = 'More then $120K'
and Status = 'Attrited Customer'
group by Credit_Limit,Total_Revolving_Bal
order by 1 desc

--(Hasil tingkat kredit limit yang paling tinggi memiliki jumlah customer  yang tinggi yaitu 43
-- namun dengan korelasi bergulir 0 pada kategori pendapatan customer  More then $120K

----------------------------------------------------------------------------------------------------------------------------------------
--Metrix Tingkat Aktivitas 
-- Melihat tingkat aktivitas consumer dari rata rata rasio penggunaan kartu kredit,
--frekuensi transaksi dan jumlah transaksi
--1.Pada tingkat More then $120K
select count(Avg_Utilization_Ratio) as CountAvgUti, 
	count(total_Trans_amt) as JumlahTransaksi,
	count(total_trans_ct) as FrekuensiTransaksi
from ProjectBTPN..customer_data_history$
where 
Income_Category = 'More then $120K'
and Status = 'Attrited Customer'
--group by Credit_Limit,Total_Revolving_Bal
--order by 1 desc

--2.Pada tingkat $80K - $120K
select count(Avg_Utilization_Ratio) as CountAvgUti, 
	count(total_Trans_amt) as JumlahTransaksi,
	count(total_trans_ct) as FrekuensiTransaksi
from ProjectBTPN..customer_data_history$
where 
Income_Category = '$80K - $120K'
and Status = 'Attrited Customer'

--3.Pada tingkat $60K - $80K
select count(Avg_Utilization_Ratio) as CountAvgUti, 
	count(total_Trans_amt) as JumlahTransaksi,
	count(total_trans_ct) as FrekuensiTransaksi
from ProjectBTPN..customer_data_history$
where 
Income_Category = '$60K - $80K'
and Status = 'Attrited Customer'

--4.Pada tingkat $40K - $60K
select count(Avg_Utilization_Ratio) as CountAvgUti, 
	count(total_Trans_amt) as JumlahTransaksi,
	count(total_trans_ct) as FrekuensiTransaksi
from ProjectBTPN..customer_data_history$
where 
Income_Category = '$40K - $60K'
and Status = 'Attrited Customer'

--5.Pada tingkat Less than $40K
select count(Avg_Utilization_Ratio) as CountAvgUti, 
	count(total_Trans_amt) as JumlahTransaksi,
	count(total_trans_ct) as FrekuensiTransaksi
from ProjectBTPN..customer_data_history$
where 
Income_Category = 'Less than $40K'
and Status = 'Attrited Customer'

-----------------------------------------------------------------------------------------------------------------------------------------
--KATEGORI KARTU
--Tujuan menjelajari kategori kartu adalah untuk melihat
--apakah klien kami puas dengan penawaran produk yang ditawarkan institusi 
-------------------------------------------------------------------------------------------------------------------------------------------

-- Tingkat Atrisi pada kategori kartu 

select count(Card_Category) as CountCard, 
	 Card_Category, status
from ProjectBTPN..customer_data_history$
group by Card_Category, status
order by 3,1 desc

------------------------------------------------------------------------------------------------------------------------------------------

-- Tingkat Atrisi pada Total Transaksi vs Kategori Kartu 

select Card_Category, sum(Total_Trans_Amt)over(Partition by Card_Category) as TotalTrans
from ProjectBTPN..customer_data_history$
where 
Status = 'Attrited Customer'
--group by Card_Category,Total_Trans_Amt
order by 1 asc
---
Select sum(Total_Trans_Amt) as TotaltransBlue,Status
from ProjectBTPN..customer_data_history$
where 
Card_Category = 'Blue'
group by status
---
Select sum(Total_Trans_Amt)TotaltransSilver,Status
from ProjectBTPN..customer_data_history$
where 
Card_Category = 'silver'
group by status
---
Select sum(Total_Trans_Amt)TotaltransPlatinum,Status
from ProjectBTPN..customer_data_history$
where 
Card_Category = 'Platinum'
group by status
---
Select sum(Total_Trans_Amt)TotaltransGold,Status
from ProjectBTPN..customer_data_history$
where 
Card_Category = 'Gold'
group by status



--------------------------------------------------------------------------------------------------------------------------------

-- Tingkat Atrisi vs Bulan Tidak Aktif 
Select count(Months_Inactive_12_mon) as TotalInactive
, Months_Inactive_12_mon, Status
from ProjectBTPN..customer_data_history$
--where 
group by Months_Inactive_12_mon, status
order by 3,1 desc

--menghitung median 
with RankedTable as (
Select count(Months_Inactive_12_mon) as TotalInactive
, Months_Inactive_12_mon, status
from ProjectBTPN..customer_data_history$
--where 
--status = 'Attrited Customer'
group by Months_Inactive_12_mon, status
)

--select *
--from RankedTable
----where 
----status = 'Attrited Customer'
--order by Months_Inactive_12_mon asc

--select sum(TotalInactive) / 2
--from RankedTable
--where 
--status = 'Attrited Customer'


--select sum(TotalInactive) / 2
--from RankedTable
--where 
--status = 'Existing Customer'

select *
from RankedTable
where 
status = 'Existing Customer'
order by Months_Inactive_12_mon asc
--(median month inactive 12 month pada customes attrited yaitu pada data 813 & 814 yaitu 3,5 bulan)
--(median month inactive 12 month pada customes existing yaitu pada data 4250 & 4251 yaitu 2,5  bulan)

------------------------------------------------------------------------------------------------------------------------------------------------

--Tingkat Atrisi Vs Saldo bergulir 

with RankedTable as (
Select Total_Revolving_Bal, status,
case 
when Total_Revolving_Bal < (select avg(Total_Revolving_Bal) from ProjectBTPN..customer_data_history$) then 'true'
else 'false'
end as tr 
from ProjectBTPN..customer_data_history$
where 
status = 'Attrited Customer' )
--select count(tr)
--from RankedTable
--where 
--tr = 'true'

select count(tr)
from RankedTable
where 
tr = 'false'

Select sum(Total_Revolving_Bal)
from ProjectBTPN..customer_data_history$
where 
status = 'Existing Customer'

--Pelanggan yang memiliki saldo bergulir yang rendah (dibawah rata-rata saldo bergulir) adalah yang paling mungkin untuk pergi (attrited Consumen) 
