
DROP SEQUENCE IF EXISTS inventory_seq;

DROP TABLE IF EXISTS inventory_fact;
DROP TABLE IF EXISTS branch_plant_dim;
DROP TABLE IF EXISTS cust_vendor_dim;
DROP TABLE IF EXISTS item_master_dim;
DROP TABLE IF EXISTS addr_cat_code1;
DROP TABLE IF EXISTS addr_cat_code2;
DROP TABLE IF EXISTS item_cat_code1;
DROP TABLE IF EXISTS item_cat_code2;
DROP TABLE IF EXISTS company_dim;
DROP TABLE IF EXISTS zip_codes;
DROP TABLE IF EXISTS date_dim;
DROP TABLE IF EXISTS trans_type_dim;
DROP TABLE IF EXISTS Currency_Dim;

CREATE SEQUENCE inventory_seq START WITH 18301 INCREMENT BY 1;

CREATE TABLE Currency_Dim
(
  Currency_ID   VARCHAR(3),
    Exchange_Rate DECIMAL(8,2)
);

CREATE TABLE addr_cat_code1
(
  AddrCatCodeKey  INTEGER NOT NULL,
  AddrCatCodeId   VARCHAR(4) NOT NULL,
  AddrCatDesc     VARCHAR(30) NOT NULL,
  CONSTRAINT addr_cat_code1_PK PRIMARY KEY(AddrCatCodeKey)
);
  
CREATE TABLE addr_cat_code2
(
  AddrCatCodeKey  INTEGER NOT NULL,
  AddrCatCodeId   VARCHAR(4) NOT NULL,
  AddrCatDesc     VARCHAR(30) NOT NULL,
  CONSTRAINT addr_cat_code2_PK PRIMARY KEY(AddrCatCodeKey)
);

CREATE TABLE item_cat_code1
(
  ItemCatCodeKey  INTEGER NOT NULL,
  ItemCatCodeId   VARCHAR(4) NOT NULL,
  ItemCatDesc     VARCHAR(30) NOT NULL,
  CONSTRAINT item_cat_code1_PK PRIMARY KEY(ItemCatCodeKey)
);

CREATE TABLE item_cat_code2
(
  ItemCatCodeKey  INTEGER NOT NULL,
  ItemCatCodeId   VARCHAR(4) NOT NULL,
  ItemCatDesc     VARCHAR(30) NOT NULL,
  CONSTRAINT item_cat_code2_PK PRIMARY KEY(ItemCatCodeKey)
);

CREATE TABLE zip_codes
(
  ZipKey    INTEGER NOT NULL,
  ZipCity   VARCHAR(20) NOT NULL,
  ZipState  VARCHAR(2) NOT NULL,
  ZipZip    INTEGER,
  ZipConsec INTEGER,   -- number of consecutive zip codes...
  ZipWeight INTEGER,   -- weight rating for zip code genreation
  CONSTRAINT zip_codes_PK PRIMARY KEY(ZipKey)
);

CREATE TABLE date_dim
(
  DateKey       INTEGER NOT NULL, 
  DateJulian    INTEGER NOT NULL,  -- julian date in the format of yyyy-mm-ddd
  CalDay        INTEGER NOT NULL CHECK (CalDay >= 0 and CalDay <= 31),  -- from 1 to 31
  CalMonth      INTEGER NOT NULL CHECK (CalMonth >= 0 and CalMonth <= 12),  -- from 1 to 12
  CalQuarter    INTEGER NOT NULL CHECK (CalQuarter >= 0 and CalQuarter <= 4),  -- from 1 to 4
  CalYear       INTEGER NOT NULL CHECK (CalYear >= 1900 and CalYear <= 2100),  -- valid for 1900 to 2100
  DayOfWeek     INTEGER NOT NULL CHECK (DayOfWeek >= 0 and DayOfWeek <= 6),  -- 1 to 7 1 is Sunday, 2 is monday...
  FiscalYear    INTEGER NOT NULL,
  FiscalPeriod  INTEGER NOT NULL,
  CONSTRAINT date_dim_pk PRIMARY KEY(DateKey)
);

CREATE TABLE trans_type_dim
(
  TransTypeKey      INTEGER NOT NULL CHECK (TransTypeKey >= 1 and TransTypeKey <= 5),
  TransTypeCodeId   VARCHAR(2) NOT NULL,
  TransDescription  VARCHAR(30) NOT NULL,
  CONSTRAINT trans_type_pk PRIMARY KEY(TransTypeKey)
  -- TransTypeKey = 1 then TransTypeCodeId = 'IA' (inventory adjustment)
  -- TransTypeKey = 2 then TransTypeCodeId = 'IT' (inventory transfer)
  -- TransTypeKey = 3 then TransTypeCodeId = 'IS' (inventory simple issue)
  -- TransTypeKey = 4 then TransTypeCodeId = 'OV' (purchase order receipt)
  -- TransTypeKey = 5 then TransTypeCodeId = 'AR' (sales order shipment)   
);

CREATE TABLE cust_vendor_dim
(
  CustVendorKey INTEGER NOT NULL,
  AddrBookId    INTEGER NOT NULL UNIQUE,
  Name          VARCHAR(30) NOT NULL,
  Address       VARCHAR(30) NOT NULL,
  City          VARCHAR(20) NOT NULL,
  State         VARCHAR(2) NOT NULL,
  PrimZip       INTEGER NOT NULL,
  Zip           VARCHAR(10) NOT NULL,
  Country       VARCHAR(3) DEFAULT 'USA',
  AddrCatCode1  INTEGER,
  AddrCatCode2  INTEGER,
  CONSTRAINT cust_vend_dim_pk PRIMARY KEY(CustVendorKey),
  CONSTRAINT cust_vend_CatCode1_FK FOREIGN KEY(AddrCatCode1) REFERENCES addr_cat_code1 (AddrCatCodeKey),
  CONSTRAINT cust_vend_CatCode2_FK FOREIGN KEY(AddrCatCode2) REFERENCES addr_cat_code2 (AddrCatCodeKey)
);
  
CREATE TABLE item_master_dim
(
  ItemMasterKey INTEGER NOT NULL,
  ShortItemId   INTEGER NOT NULL,
  SecondItemId  VARCHAR(30) NOT NULL,
  ThirdItemId   VARCHAR(30) NOT NULL,
  ItemCatCode1  INTEGER,
  ItemCatCode2  INTEGER,
  ItemDesc      VARCHAR(30),
  UOM           VARCHAR(3),
  CONSTRAINT item_master_dim_pk PRIMARY KEY(ItemMasterkey),
  CONSTRAINT item_master_CatCode1_FK FOREIGN KEY(ItemCatCode1) REFERENCES item_cat_code1 (ItemCatCodeKey),
  CONSTRAINT item_master_CatCode2_FK FOREIGN KEY(ItemCatCode2) REFERENCES item_cat_code2 (ItemCatCodeKey),
  CONSTRAINT UniqueShortItemId UNIQUE (ShortItemId)
);

CREATE TABLE company_dim
(
  CompanyKey    INTEGER,
  CompanyId     VARCHAR(5) NOT NULL,
  CompanyName   VARCHAR(30) NOT NULL,
  CurrencyCode  VARCHAR(5) NOT NULL,
  CurrencyDesc  VARCHAR(30) NOT NULL,
  CONSTRAINT company_dim_pk PRIMARY KEY (CompanyKey)
);

CREATE TABLE branch_plant_dim
(
  BranchPlantKey  INTEGER,
  BranchPlantId   VARCHAR(12) NOT NULL,
  CompanyKey      INTEGER,
  CarryingCost    DECIMAL(3,2) NOT NULL,
  CostMethod      VARCHAR(2) NOT NULL,
  BPName          VARCHAR(30),
  CONSTRAINT branch_plant_dim_pk PRIMARY KEY (BranchPlantKey),
  CONSTRAINT branch_plant_CompanyId_FK FOREIGN KEY(CompanyKey) REFERENCES company_dim (CompanyKey)
);

CREATE TABLE inventory_fact(
  InventoryKey    INTEGER,  -- AUTO INCREMENT used for fact table
  BranchPlantKey  INTEGER NOT NULL,
  DateKey         INTEGER NOT NULL,
  ItemMasterKey   INTEGER NOT NULL,
  TransTypeKey    INTEGER NOT NULL,
  CustVendorKey   INTEGER,
  UnitCost        DECIMAL(12,4),
  Quantity        DECIMAL(9,4),
  ExtCost         DECIMAL(14,2),
  CONSTRAINT inv_fact_PK PRIMARY KEY(InventoryKey),
  CONSTRAINT inv_fact_Branch_Plant_FK FOREIGN KEY(BranchPlantKey) REFERENCES branch_plant_dim (BranchPlantKey),
  CONSTRAINT inv_fact_DateId_FK FOREIGN KEY(DateKey) REFERENCES Date_dim (DateKey),
  CONSTRAINT inv_fact_CustVendorKey_FK FOREIGN KEY(CustVendorKey) REFERENCES cust_vendor_dim (CustVendorKey),
  CONSTRAINT inv_fact_TransTypeId_FK FOREIGN KEY(TransTypeKey) REFERENCES trans_type_dim (TransTypeKey),
  CONSTRAINT inv_fact_ShortItemId_FK FOREIGN KEY(ItemMasterKey) REFERENCES item_master_dim (ItemMasterKey) 
);


