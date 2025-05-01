I have cleaned and imported the csv file in 3 PostgreSQL tables and I have reached my findings based on this data.
For this project, I have made some assumptions and based on that I have gone forward to the requirement: 

1. Abrechnung_Rechnungen: Invoices Table
    Each record represents an invoice sent to a customer.
    ReNummer: Invoice number (Primary Key).
    SummeNetto: Total net amount of the invoice. Added by MwStSatz percentage turns to ZahlungsbetragBrutto.
    MwStSatz: VAT rate (e.g., 0%, 7%, 19%).
    ZahlungsbetragBrutto: Total gross payment received (can be missing if unpaid).
    KdNr: Customer number (links to Abrechnung_Kunden).
    SUMMENEBENKOSTEN: The extra price, SummeNetto deducted by this value turns to ZahlungsbetragBrutto.
    ReDatum: Invoice date.
    Zahlungsdatum: Payment date (can be NULL if unpaid).

2. Abrechnung_Positionen: Invoice Line Items / Positions Table.
  If a purchase has multiple items or a license as its visible in the package proposals, this table gets multiple records. Therefore, sum of Nettobetrag in this table must be equal to the summenetto of the linked invoice.
  Each record represents a single line item inside an invoice.
  Matches through ReId AND KdNr to Abrechnung_Rechnungen table.
  id: Unique identifier for the position.
  ReId: Linked invoice number (ReNummer) → Foreign Key.
  KdNr: Customer number.
  Nettobetrag: Net revenue for this line item.
  Bildnummer: ID of the media/content sold (photo, video, etc.).
  VerDatum: Sale date or media usage date.

3. Abrechnung_Kunden: Customers Table
  Each record represents a customer.
  id: Technical ID (not used in business joins).
  Kdnr: Customer number (business key).
  Verlagsname: Name of the customer (publisher, agency, brand, etc.).
  Region: Geographical region of the customer.
4. Invoice or position dates: Records less than the company’s founding year (1990) or greater than today are invalid

5. Customer Journey: I have had a customer journey on purchasing a product to get to know abit about the business and make some assumptions that are at least close to the real story. I have created a user on IMAGO website and proceeded till submitting an order. Based on    this Journey, I have assumed: 

      The orders placed are prepaid, meaning that you cannot start using a license unless you pay on the payment portal and have a successful payment. 
      
      I assume zahlungsdatum which is the payment date must be greater or at least equal to the redatum which is the issue date of invoice.

6. Collaboration with other colleagues: If I could have more knowledge and data on order funnel and business flow, all the nonconformities and data model refactor could have more precise structure.

Plz finde attached the following parts included in the repository:

data-investigation file which had a huge help on me understanding the business, non conformities and assumptions.

data-analysis file which covers the first section of the challenge.

data -pipeline file which covers the nonconformities finding and data pipeline section.

data-modeling file which has ideas on warehouse design restructuring

modern-technologies file which covers the dbt, Airflow, Dagster and migration section

data-investigation.sql
