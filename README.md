# My Data Warehouse Project 

Welcome to my project! so this is a data warehouse I built from scratch. I think it is a great way to practice data engineering and ETL processes. 

first, I want to talk about the data architecture. I decided to use the Medallion Architecture because it makes sense to me to organize data in stages. 

* **Bronze Layer:** here, i just imported the raw data from CSV files directly into my SQL Server.
* **Silver Layer:** then, i cleaned the data. there was some errors and missing things, so I fixed them and standardized everything.
* **Gold Layer:** last, after cleaning, I created a star schema. I think this is the best way to get it ready for reporting and dashboards.

so what did I actually do in this project?

* I designed the whole DWH architecture.
* I built ETL pipelines to move and transform the data.
* I wrote SQL queries to get some cool insights from the data.

I used tools that are completely free, which is awesome:

* SQL Server Express and SSMS to manage the database.
* Git and GitHub for saving my scripts.


first the main goal was to take sales data from two different systems ERP and CRM. then I had to clean it and merge it into one clear model. I didn't do data historization because I think focusing on the latest data is enough for this scope.



## Data Flow Diagram

```mermaid
flowchart LR
    subgraph SRC [Sources]
        CRM[📁 CRM]
        ERP[📁 ERP]
    end
    
    subgraph BRZ [Bronze Layer]
        B1[crm_sales_details]
        B2[crm_cust_info]
        B3[crm_prd_info]
        B4[erp_cust_az12]
        B5[erp_loc_a101]
        B6[erp_px_cat_g1v2]
    end
    
    subgraph SLV [Silver Layer]
        S1[crm_sales_details]
        S2[crm_cust_info]
        S3[crm_prd_info]
        S4[erp_cust_az12]
        S5[erp_loc_a101]
        S6[erp_px_cat_g1v2]
    end
    
    subgraph GLD [Gold Layer]
        G1[fact_sales]
        G2[dim_customers]
        G3[dim_products]
    end
    
    CRM --> B1 & B2 & B3
    ERP --> B4 & B5 & B6
    
    B1 --> S1
    B2 --> S2
    B3 --> S3
    B4 --> S4
    B5 --> S5
    B6 --> S6
    
    S1 --> G1
    S2 --> G2
    S3 --> G3
    S4 --> G2
    S5 --> G2
    S6 --> G3
    
    style B1 fill:#FAECE7,stroke:#D85A30
    style B2 fill:#FAECE7,stroke:#D85A30
    style B3 fill:#FAECE7,stroke:#D85A30
    style B4 fill:#FAECE7,stroke:#D85A30
    style B5 fill:#FAECE7,stroke:#D85A30
    style B6 fill:#FAECE7,stroke:#D85A30
    style S1 fill:#F1EFE8,stroke:#888780
    style S2 fill:#F1EFE8,stroke:#888780
    style S3 fill:#F1EFE8,stroke:#888780
    style S4 fill:#F1EFE8,stroke:#888780
    style S5 fill:#F1EFE8,stroke:#888780
    style S6 fill:#F1EFE8,stroke:#888780
    style G1 fill:#FAEEDA,stroke:#EF9F27
    style G2 fill:#FAEEDA,stroke:#EF9F27
    style G3 fill:#FAEEDA,stroke:#EF9F27
```


