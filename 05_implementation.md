# Implementation
This section pertains to the implementation of the datapipeline, as mentioned previously, this pipeline starts at stage 1 where conditional scraping was performed on the top 10000 repositories, and as we progress through the stage the amount of data we are working with decreases and the insight from the data increases, where at stage 6 we have a smaller amount of data with higher amount of insight.

## Stage 1 - Raw data gathering
The first phase of the data pipeline is the raw data extraction, to perform the raw data extraction a python libary named "Pydriller" was used.
Pydriller is a libary that automatically extract commits data given a repository URL, and is a usefull tool in the context of this project, from Pydriller we extracted the commits hash, the message, the author, the timestamp, and the authors timezone, aswell as the line modified amount. 

The reason we chose to extract this data is that it was all the tabular data it was possible to extract, i.e all Key-Value data pairs relevant to git commits. We chose to keep this data as broad as possible because it is easier to filter off data than it is to rescan the data again.

Aditionally if a file contained less chan 20 line changes and only one ".py" file change. The files name, it's cyclomatic complexity aswell as the deleted and added lines. The technological reason for limiting it to 20 line changes it could become difficult to perform syntax based analysis and relate it to the specific error fixed if the git diff is to large. 

The last thing to make the data extraction complete is gathering large amount of indexed github repositories containing python code, currently github does not index this information neatly on a page. Therefore an alternative had to be found.
Luckly someone on github had made a ranking board that allows you to get the top N repositories ranked by gitstars, aswell as listing the most used language in the repo.
Using the website https://gitstar-ranking.com we could scrape the repo URLs arranged by star count and feed them incrementally into Pydriller.

We did this for the top 10000 repositories on github filtering all repos not made using python. Additionally for each repo we found we limited all commits to the latest 5 years of repos and capped it at 10000 commits per repo.
This lead to 1.300.000 total commits. This process took 40 compute hours. 

## Stage 2 - Data cleaning

The data cleaning phase is the second part of the pipeline and is for refining the data such that only the data currently needed for processing is used. 
This mean all commits that dont contain any line changes within the ".py" file. 
additionally reduntant data in the context of analysing commits is trimmed.  This means that only repositoy, hashId, commit message, deleted and added lines are left.
The reason for this step existing is because our future pipelines should work with as little data as possible and as such only data directly needed is used.
However should the scope of our analysis expand, we can change the filtering without running the scraping again.

## Stage 3 - Patching

Following stage 2, the 3rd stage is last raw data preparation pipeline where no classification is performed. This stage is lossless as it doesn't filter out any existing data entries.
In this stage, the github commit code is tokenized. However due to the problem that commit diffs often don't contain valid/runnable code. A traditional python-parser wouldn't work. So it was decided that a classical tokenizer was used.
This has the limitation that certain tokens are grouped together, meaning we lose some syntaxical meaning from our 
Once the code diffs have been tokenized a frequency array for the added tokens, deleted tokens and tokens changes which consists of the added tokens - deleted tokens. Where frequency is not 0.

## Stage 4 - Bug categorisation

This stage is the first of 2 categorisation stages. Here is where we take the patched commits, and put them into distinct categories. The patching is set up such that a commit can only be classified as a single bug, however the criteria for each classification are not mutually exclusive, to resolve this. Bug classifications are handed out based on order defined in the schema.
This does arguable pose some limiation. Given that it means some commits might get wrongly classified. So to midiate this the bugs were ranked by most restrictive criteria to most restrictive criteria. Such that the bugs which was believed to be the most stringent were prioritiesed over more generic bugs. 

### Classification Algorithm

Earlier it was described that a schema was used to perform the classification. The schema is a JSON schema that must follow a very strict structure. It consists of a dict of arrays, wherein either strings or array of strings are contained.

The outermost dictionary contains each bug category as a *key* and the *value* is an array. This means that our schema looks like this

``
    {
        'null pointer exceptions': [...]
        'logical errors': [...]
    }
``
In this above example null pointer exceptions are ranked above logical errors, only if the criteria inside the 'null pointer exceptions' array are satisfied. 
Delving deeper, the array inside the dictionary contains a bunch of strings, these strings are used for substring matching and doesn't support regex.

``
    'null pointer exceptions': [
        ' null ', 
        'null-pointer'
    ]
``

The above example would classify any commits that contain the substring ' null ' or 'null-pointer' in their message header. and give them the bug label 'null pointer exceptions' if true. This works flawlessly for most bugs, however it limits us to explicitly defining every substring variant individually and as such leads us to filtering out a bunch of commits creating a bunch of false-negatives.  
So give us more variation and specificity on our substrings, it was also added such that you can use an array inside the array if more specificity is needed.

``
    'logical errors': [
        ['indentation ', ' error '],
        ' edge case '
    ]
``

This above classifies all commits into logical errors if they contain ' indentation ' and ' error ' in their commit message or the substring ' edge case '. 

Whilst this format for doesn't provide as much freedom for filtering as a regex would, this implementation is both easier to work with, and more lightweight than a complete regex implementation.

## Stage 5 - Patch categorisation

The second last stage of the pipeline performs another classification on which patch type the code is. This type of classification is independant compared to the bug classification. 

Given that patch classification is a lot harder to do than bug classification, we opted to make use of a rule based classifier. This classifier consists of a bunch of if/elif's statements arranged below each other creating a tier based classifier. 
This classifer makes use of the tokenisation performed in Stage 3 to make it's classifications making it more advanced than the classifier used in Stage 4. Like in stage 4 we arranged the classifiers such that the most stringent criterias were evaluated first. 
Using a hard coded rule based classifier like the one has limitations for extendability outside of modifying the code. We decided to use it since the criteris we needed to work with were much more stringent than what a json based classifier like the one made in Stage 4 could deliver.

## Stage 6 - Data aggregation

The last stage doesn't modify and data and merely acts as a data visualisation stage Here we take the insight extracted in Stage 5 and convert it into wisdom related to the overall relation between bug types and patch types. The stage produces a matrix plot with rows being patch types and columns being bug types. 