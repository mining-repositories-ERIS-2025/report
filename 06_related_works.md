# Related works

- Brief summary of related works
- Draw similarities between the related works and our approahc
- Postulate how our data could improve the related works


- automatically  retrieve commit histories
- extract metadata
- rule-based commit analysis
  - regex-based filtering to identify bug type
  - manual analysis to classify filtered commit messaged to bug type
- use diff tools or AST parsers to analyze code changes in corresponding patches

PrevaRank a heuristic straight forward approach to rank patches for bug fixes in relation to historical proven solutions. A similar ranking solution could be developed with machine learning algorithms. However it is lightweight and effective and can be implemented as part of the post-processing step of any APR pipeline without considerable overhead. It showcased an improvement of 29% from outside to inside the top 3-ranks relative to the original tool. And only a 2% deterioration of ranking correct patches from inside to outside the top-3 ranks.

PrevaRank (Bhuiyan et al., 2024) ranks plausible patches for automated program repair (APR) based on their similarity to historical fixes, and then improves the prioritization of correct patches. This project differ as it does not focus on automated patch ranking, however both approaches leverage commit histories of targeted git repositories to extract relevant bug-fix patterns.

Our project focuses on what instead of APR-generated patches?
    deterministic heuristics?
    static code analysis?
    could PrevaRank be used to enhance our rule-based approach for example by utizing its insights into historical fix frequencies by incorporating patterns of common bug resolutions?


Classification of bugs into categories
