-- Solution 
select CalMonth, AddrCatCode1, sum(ExtCost) as tot_cost,
 sum(Quantity) as tot_qty
from inventory_fact i, cust_vendor_dim c, date_dim d
where TransTypeKey = 5 and
 d.Calyear = 2021 and
 i.CustVendorKey = c.CustVendorKey and
 i.DateKey = d.DateKey
group by CUBE(AddrCatCode1, d.calmonth);
-- GROUPING SETS solution
-- Solution not in the problem specification
select CalMonth, AddrCatCode1, sum(ExtCost) as tot_cost,
 sum(Quantity) as tot_qty
from inventory_fact i, cust_vendor_dim c, date_dim d
where TransTypeKey = 5 and
 d.Calyear = 2021 and
 i.CustVendorKey = c.CustVendorKey and
 i.DateKey = d.DateKey
group by GROUPING SETS((AddrCatCode1, d.calmonth), AddrCatCode1, d.calmonth,
());

-- Assignment requires GROUPING SETS solution
select Name, Zip, CalQuarter, sum(ExtCost) as tot_cost, count(*) as Cnt
from inventory_fact i, cust_vendor_dim c, date_dim d
where TransTypeKey = 5 and
 d.Calyear BETWEEN 2021 AND 2022 AND
 d.datekey = i.datekey and
 i.CustVendorKey = c.CustVendorKey AND
 i.DateKey = d.DateKey
group by GROUPING SETS((c.Name, c.Zip, d.CalQuarter), (c.Name, c.Zip),
(c.Name, d.CalQuarter), (c.Zip, d.CalQuarter),
 c.Name, c.Zip, d.CalQuarter, ());

 -- Assignment requires GROUPING SETS solution
select Name, Zip, CalQuarter, sum(ExtCost) as tot_cost, count(*) as Cnt
from inventory_fact i, cust_vendor_dim c, date_dim d
where TransTypeKey = 5 and
 d.Calyear BETWEEN 2021 AND 2022 AND
 d.datekey = i.datekey and
 i.CustVendorKey = c.CustVendorKey AND
 i.DateKey = d.DateKey
group by GROUPING SETS((c.Name, c.Zip, d.CalQuarter), (c.Name, c.Zip),
(c.Name, d.CalQuarter), (c.Zip, d.CalQuarter),
 c.Name, c.Zip, d.CalQuarter, ());


 