--memfilter data yang akan digunakan.
--mencari nett_sales
--persentase_gross_laba

create table datamart as(
select distinct
  ft.transaction_id,
  ft.customer_name,
  extract(year from ft.date) as year,
  ft.branch_id,
  kc.branch_name,
  kc.kota,
  kc.provinsi,
  ft.rating as rating_transaksi,
  kc.rating as rating_cabang,
  p.product_id,
  p.product_name,
  p.price,
  ft.discount_percentage,
  p.price - (p.price * ft.discount_percentage) as nett_sales,
  case
   when p.price <= 50000 then 0.10
   when p.price > 50000 and p.price <= 100000 then 0.15
   when p.price > 100000 and p.price <= 300000 then 0.20
   when p.price > 300000 and p.price <= 500000 then 0.25
   else 0.30
  end as persentase_gross_laba
from kf_final_transaction as ft
join kf_kantor_cabang as kc
on ft.branch_id = kc.branch_id
join kf_product as p
on ft.product_id = p.product_id
order by year asc)

create table final_datamart as(
select * ,
round(price - (price/(1+ persentase_gross_laba)),2) as nett_profit 
from datamart
order by year asc)

