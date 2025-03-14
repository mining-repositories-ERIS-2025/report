# Introduction

- What field are we in
- What problems is the field facing
- Any other important points for contextualizing this project
- What are our contributions

INSERT introduction to the general field of mining software repositories

A multitude of information on bugs occurance and their fixes can be deduced from software repositories. This information have been used to categorize bugs and patches and further to evaluate their mutual relevance. The use cases are expanded with the improvements of automated program repair (APR) techniques. The APR approaches are used to automatically generate a patch solution to a bug-fix. In contrary this paper presents a tool to infer bug-types based on a given patch automatically. The solution is a dataset for mapping bug type to code patch semantics and frequencies. The dataset enables users to evaluate and identify statistical information for a specific patch.
The mapping dataset is constructed based on historical data from mining software repositories. The targeted mined repositories consists of popular open source python projects. A rule-based approach is leveraged to analyze the data by applying a simple regex-based filtering on the commit messages to extract bug-fix patches and identify the related bugs.