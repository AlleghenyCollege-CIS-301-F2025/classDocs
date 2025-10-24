# What Do You Know? Activity

## Learning Goals

- Practice data-driven reasoning and pattern recognition
- Understand how word frequency analysis can reveal information about text sources
- Gain experience with basic data visualization and interpretation

## Deliverable

+ Nothing to submit
+ Speaking in class about your findings
## Overview

Working in groups, if you like, this activity explores how we can infer the type or subject of a news article by analyzing the frequency and distribution of words, without reading the article itself. The goal of this activity is to use data-driven techniques to make educated guesses about the article's origin or topic.

## Data Description

- The `data/` directory contains several files, each listing words and their counts as extracted from different news articles. Each file represents a unique article or article type.
- These files are formatted as either tab- or comma-separated values, with each line showing a word and its frequency in the article.

## Visualization

- The `scatterPlots/` directory contains scatter plots generated from the word count data. These visualizations help us see patterns, clusters, and outliers in the word usage for each article.
- By examining these scatter plots, we can look for distinguishing features (such as high frequency of certain words, or unique word distributions) that may indicate the article's topic or origin.

## Activity Instructions

1. With your group member, please review the word count files in the `data/` directory. Try to note particular trends that you find. Discuss the trends to articulate them. What do you see?
2. Open the corresponding scatter plots in the `scatterPlots/` directory. Do your trends seem to be important? Can you use these trends to determine the original article? What other patters do you see?
3. Based on the visualizations and word data, try to infer:
   - What type of article each word list came from (e.g., science, politics, sports, etc.)
   - What clues in the data led you to your conclusion
4. Discuss your findings with your group or class. Compare your inferences and reasoning. We will go around the room and share insights.

## Tools Used

- Word count data from `data/`
- Scatter plots from `scatterPlots/`
- Python plotting tools (see `src/plotterTool.py` for generating new plots)
   - Commands for using the code
   - **Scatter plots**: `python3 src/plotterTool.py data/wordList_5.csv --plot scatter --x word --y count`
   - **Histogram plots**: `python3 src/ plotterTool.py data/wordList_5.csv --plot histogram --x word --y count`

---

## Conclusion
This activity demonstrates how much we can learn from data alone, and encourages critical thinking about the relationship between language and information.
