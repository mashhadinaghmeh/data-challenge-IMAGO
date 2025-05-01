SELECT id, kdnr, verlagsname, region
FROM public.abrechnung_kunden; 600



SELECT i.*
FROM public.abrechnung_rechnungen i --2000
where zahlungsdatum is not null


SELECT count(*) count --50
FROM public.abrechnung_rechnungen i 
where i.redatum > i.zahlungsdatum 
and i.zahlungsdatum is not null


SELECT count(*) count --1457
FROM public.abrechnung_rechnungen i 
where i.redatum < i.zahlungsdatum 
and i.zahlungsdatum is not null

SELECT i.*
FROM public.abrechnung_rechnungen i --2000
where zahlungsdatum is not null
--and i.mwstsatz > 0
and summenebenkosten > 0

select count(*) count --0
from public.abrechnung_rechnungen i 
where i.kdnr is null or i.redatum is null


WITH position_data AS (
    SELECT 
        p.reid, 
        p.kdnr, 
        SUM(p.nettobetrag)::text AS sum_amount
    FROM public.abrechnung_positionen p
    GROUP BY p.reid, p.kdnr
)

SELECT COUNT(DISTINCT i.renummer)
FROM public.abrechnung_rechnungen i
LEFT JOIN position_data p
    ON (i.renummer = p.reid AND i.kdnr = p.kdnr)
WHERE i.zahlungsdatum IS NOT NULL
  AND i.summenetto <> (REPLACE(REPLACE(p.sum_amount, '$', ''), ',', '')::numeric);







--no duplicate invoice id

SELECT sum(Nettobetrag), count(*), count(distinct bildnummer)--id, reid, kdnr, nettobetrag, bildnummer, verdatum, "id,ReId,KdNr,Nettobetrag,Bildnummer,VerDatum" --124000
FROM public.abrechnung_positionen p
where p.reid = 102038



--$8,387.46


SELECT id, reid, kdnr, nettobetrag, bildnummer, verdatum, "id,ReId,KdNr,Nettobetrag,Bildnummer,VerDatum" --124000
FROM public.abrechnung_positionen p
where p.reid = 102038

--$8,387.46

SELECT count(*) --i.*, c.*
FROM public.abrechnung_rechnungen i
left join public.abrechnung_kunden c
	on i.kdnr = c.kdnr 
where c.id is null  -- all have valid customer

SELECT c.*, i.*, p.*   
FROM public.abrechnung_rechnungen i
left join public.abrechnung_kunden c
	on i.kdnr = c.kdnr 
left join public.abrechnung_positionen p
	on i.renummer = p.reid 
where i.renummer = 102038
and i.kdnr <> p.kdnr   

--no duplicate invoice id but wrong customers assigned to invoices

select count(*)-- c.*, i.*, p.*   
FROM public.abrechnung_rechnungen i
left join public.abrechnung_kunden c
	on i.kdnr = c.kdnr 
left join public.abrechnung_positionen p
	on (i.renummer = p.reid and i.kdnr = p.kdnr) 
where i.zahlungsdatum is null   --if customer reaches the payment stage but does not pay


select c.*, i.*, p.*   
FROM public.abrechnung_rechnungen i
left join public.abrechnung_kunden c
	on i.kdnr = c.kdnr 
left join public.abrechnung_positionen p
	on (i.renummer = p.reid and i.kdnr = p.kdnr) 
where p.reid = 102038
and i.zahlungsdatum is null   --all have paid


select c.*, i.*, p.*   
FROM public.abrechnung_rechnungen i
left join public.abrechnung_kunden c
	on i.kdnr = c.kdnr 
left join public.abrechnung_positionen p
	on (i.renummer = p.reid and i.kdnr = p.kdnr) 
where p.reid = 102038
and i.zahlungsdatum is null   --all have paid

select count(*)--c.*, i.*, p.*   
FROM public.abrechnung_rechnungen i
left join public.abrechnung_kunden c
	on i.kdnr = c.kdnr 
left join public.abrechnung_positionen p
	on (i.renummer = p.reid ) 
where i.kdnr <> p.kdnr  --70737


select i.renummer, count(distinct p.kdnr) count --1237
FROM public.abrechnung_rechnungen i
left join public.abrechnung_positionen p
	on (i.renummer = p.reid )
group by i.renummer
having count(distinct p.kdnr) > 1



--1) How many positions are linked to invoices that are missing payment info
select count(distinct p.id) --c.*, i.*, p.*   
FROM  public.abrechnung_positionen p 
left join public.abrechnung_rechnungen i
	on (i.renummer = p.reid and i.kdnr = p.kdnr) 
where (i.zahlungsdatum is null or i.zahlungsbetragbrutto = 0)
--where (i.zahlungsdatum is null   or i.zahlungsbetragbrutto is null) 


select count(distinct p.id) --c.*, i.*, p.*   
FROM  public.abrechnung_positionen p 
left join public.abrechnung_rechnungen i
	on (i.renummer = p.reid /*and i.kdnr = p.kdnr*/) 
--where (i.zahlungsdatum is null   or i.zahlungsbetragbrutto is null) --missing payment info
where i.zahlungsdatum is null


--2)How much revenue is attributed to placeholder media ID '100000000'
-- I assume the revenue without tax and other deductions --> netto
-- I assume the revenue with tax and other deductions --> bruto

select sum(i.summenetto) net, sum(i.zahlungsbetragbrutto) gross
FROM public.abrechnung_rechnungen i
left join public.abrechnung_kunden c
	on i.kdnr = c.kdnr 
left join public.abrechnung_positionen p
	on (i.renummer = p.reid and i.kdnr = p.kdnr) 
where p.bildnummer = 100000000
and i.zahlungsdatum is not null
and i.zahlungsbetragbrutto > 0



--3) How many invoices have no positions attached 
select count(distinct p.id)
FROM public.abrechnung_positionen p 
left join public.abrechnung_rechnungen i
	on (i.renummer = p.reid and i.kdnr = p.kdnr) 
where i.renummer is null --70737

select count(distinct p.id)
FROM public.abrechnung_positionen p 
left join public.abrechnung_rechnungen i
	on (i.renummer = p.reid and i.kdnr = p.kdnr) 
where i.renummer is null --70737


select count(distinct p.id)
FROM public.abrechnung_rechnungen i
left join public.abrechnung_positionen p
	on (i.renummer = p.reid and i.kdnr = p.kdnr) 
where p.id is null  --2
and i.zahlungsdatum is not null
and i.zahlungsbetragbrutto <> 0 --0



----------

select c.*, i.*, p.*   
FROM public.abrechnung_rechnungen i
left join public.abrechnung_kunden c
	on i.kdnr = c.kdnr 
left join public.abrechnung_positionen p
	on (i.renummer = p.reid and i.kdnr = p.kdnr) 
--where i.renummer  = 103508
where i.zahlungsdatum is not null


select *
FROM public.abrechnung_rechnungen i
where i.zahlungsdatum is not null 
and i.zahlungsbetragbrutto = 0




---positions that occure after invoice 
--positons that create before invoce


select *, i.redatum - i.zahlungsdatum 
from abrechnung_rechnungen i
where i.zahlungsdatum < i.redatum 

--- define range for dates > 1950 



select i.*, p.*, i.zahlungsdatum - p.verdatum  --14114
from abrechnung_rechnungen i
inner join abrechnung_positionen p
	on (i.renummer = p.reid and i.kdnr = p.kdnr) 
where i.zahlungsdatum  < p.verdatum 


select count(*)-- i.*, p.*, i.zahlungsdatum - p.verdatum  --34174
from abrechnung_rechnungen i
inner join abrechnung_positionen p
	on (i.renummer = p.reid and i.kdnr = p.kdnr) 
where i.zahlungsdatum > p.verdatum 


select i.*, p.*, i.redatum  - p.verdatum  --18246
from abrechnung_rechnungen i
inner join abrechnung_positionen p
	on (i.renummer = p.reid and i.kdnr = p.kdnr) 
where i.redatum  < p.verdatum 


select count(*) --i.*, p.*, i.redatum  - p.verdatum  --32812
from abrechnung_rechnungen i
inner join abrechnung_positionen p
	on (i.renummer = p.reid and i.kdnr = p.kdnr) 
where i.redatum  > p.verdatum 


the process is not clear, so if prepaid, the payment date must be bigger than the invoice date




