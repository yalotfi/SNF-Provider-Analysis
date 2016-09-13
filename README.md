# SNF-Provider-Analysis
A cursory look at Skilled Nursing Facilities (SNFs) and their state markets.

**Data:**

The Center for Medicaire and Medicaid Services (CMS) manages a national database of Standard Analytic Files (SAF) and Healthcare Cost Report Information System (HCRIS).  As such, one can submit a formal request to access to payment information for healthcare providers. As a disclaimer, I am not uploading the raw SAF or HCRIS data.  It's not exactly open-source, but it is protected by the FOIA.  The csv file included is basically the result a lot of pre-processing in a SQL database to reach a result that can be visualized in R.  I may include the SQL scripts at a later time.

Read about [the data here](https://www.cms.gov/Research-Statistics-Data-and-Systems/Downloadable-Public-Use-Files/Cost-Reports/).
  
**Purpose:**

The cool bit about SAF and HCRIS data is that one can create a workflow that replicates something called the PEPPER report.  It is a standardized methodology that individual providers can use to identify areas of potential improper billing.  The problem is that only that provider can see its actual report.  So given the billing and coding data from SAF and HCRIS, you can reverse engineer the PEPPER report for not just one provider, but entire parent-child networks (Management company) or proivder types (Inpatient vs SNF).  By identifying potential cases of improper billing or coding, an analyst can by extension find relative vulnerability to litigation.
  
**Method:**

These are large datasets (not Big Data, big, but will strain your computational power nonetheless).  Millions of anonymized patients per year for just SNFs.  Billions in Medicaire and Medicaid charges and reimbursments. 

* Aggregate patient level data up to provider level... Effectively reduce the dimensionality from ~9 million rows to ~16,000
  
* Calculate target area ratios (from PEPPER guide).  Varies provider type to type, but for SNFs, you're looking at instensive therapy codes as a proportion of total billed days
  
* Percent rank of the providers in terms of the amount they're coding intensive/expensive activities
  
* Provider above the 80th percentile are likely billing improperly and are therefore at greater risk of litigation
  
At this point, most analysis is done in SQL.  What I am uploading here was a simple visualization in R and ggplot2 that aggregates SNFs by state, averaging the percent rank in each rank.  Basically, what state markets are misbilling more and therefore could see more whistleblower cases or federal investigations and lawsuits.  Going forward, I would want to correlate the amount of litigation (how many providers are being sued) and the state percent rank from this analysis.
