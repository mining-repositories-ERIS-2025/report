# Implementation

- Overview of the implementation steps
- Highlights constraints of our implementations (e.g we shouldn't scrape too often from github)
- Share experiences of discovered pitfalls in the implementation
- Briefly document that our implementation works and where the code/dockerfile can be found and how to execute it

## Raw data gathering
The first phase of the data pipeline is the raw data extraction, to perform the raw data extraction a python libary named "Pydriller" was used.
Pydriller is a libary that automatically extract commits data given a repository URL, and is a usefull tool in the context of this project, from Pydriller we extracted the commits hash, the message, the author, the timestamp, and the authors timezone, aswell as the line modified amount. 

The reason we chose to extract this data is that it was all the tabular data it was possible to extract, i.e all Key-Value data pairs relevant to git commits. We chose to keep this data as broad as possible because it is easier to filter off data than it is to rescan the data again.

Aditionally if a file contained less chan 20 line changes and only one ".py" file change. The files name, it's cyclomatic complexity aswell as the deleted and added lines. The technological reason for limiting it to 20 line changes it could become difficult to perform syntax based analysis and relate it to the specific error fixed if the git diff is to large. 

The last thing to make the data extraction complete is gathering large amount of indexed github repositories containing python code, currently github does not index this information neatly on a page. Therefore an alternative had to be found.
Luckly someone on github had made a ranking board that allows you to get the top N repositories ranked by gitstars, aswell as listing the most used language in the repo.
Using the website https://gitstar-ranking.com we could scrape the repo URLs arranged by star count and feed them incrementally into Pydriller.

We did this for the top 10000 repositories on github filtering all repos not made using python. Additionally for each repo we found we limited all commits to the latest 5 years of repos and capped it at 10000 commits per repo.
This lead to 1.300.000 total commits. This process took 40 compute hours. 

## Data cleaning

The data cleaning phase is the second part of the pipeline and is for refining the data such that only the data currently needed for processing is used. 
This mean all commits that dont contain any line changes within the ".py" file. 
additionally reduntant data in the context of analysing commits is trimmed.  This means that only repositoy, hashId, commit message, deleted and added lines are left.
The reason for this step existing is because our future pipelines should work with as little data as possible and as such only data directly needed is used.
However should the scope of our analysis expand, we can change the filtering without running the scraping again.