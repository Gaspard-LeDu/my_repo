# Training Project: Fixing a Broken R Pipeline

This folder contains a teaching exercise: diagnose and repair a broken data pipeline in R.

## Files

| File | Description |
|------|-------------|
| `broken_pipeline.R` | Original broken script (left untouched for reference) |
| `fixed_pipeline.R` | Corrected, runnable version |
| `output/` | Where the plot is saved (`output/my_plot.png`) |

## What the pipeline does

1. Loads the built-in `swiss` dataset (fertility and socioeconomic indicators for 47 Swiss cantons, ~1888).
2. Keeps cantons where `Catholic > 50` and flags them with `is_majority`.
3. Computes summary statistics for that subset.
4. Plots average fertility vs. average education and saves a PNG.

## Diagnosis: what was broken

R stops at the first error, so issues should be fixed top-to-bottom.

### 1. Wrong package name (line 4)

```r
library(ggplot)   # no package called "ggplot"
```

**Fix:** use `library(ggplot2)`, or drop the line — `tidyverse` already loads ggplot2.

### 2. Typo in object name (line 8)

```r
df <- swis   # object 'swis' not found
```

**Fix:** `df <- swiss` (double `s`).

### 3. R is case-sensitive (line 13)

```r
mutate(is_majority = True)   # looks for an object named 'True'
```

**Fix:** `mutate(is_majority = TRUE)` — booleans are always uppercase in R.

### 4. Unclosed parenthesis (line 19)

```r
avg_education = mean(Education, na.rm = T,   # mean( never closed
max_ag = max(Agriculture)
)
```

`max_ag = max(...)` was swallowed as an argument to `mean()`, `summarize(` never closed, and sourcing the file failed with a parse error at `plot`.

**Fix:**

```r
avg_education = mean(Education, na.rm = TRUE),
max_ag = max(Agriculture)
```

### 5. Broken ggplot construction (lines 24–27)

```r
plot <- ggplot(...) |>
  geom_point(color = "red") +
  theme_minimal()
  labs(title = "...")   # separate statement — title never applied
```

Mixing `|>` with ggplot’s `+` does not chain as intended, and `labs(...)` was not connected with `+`, so the title was never added to `plot`.

**Fix:** use `+` throughout:

```r
plot <- ggplot(summary_stats, aes(x = avg_fertility, y = avg_education)) +
  geom_point(color = "red") +
  theme_minimal() +
  labs(title = "Fertility vs Education in Majority Catholic Swiss Provinces")
```

### 6. Missing output directory (line 29)

```r
ggsave("outputs/my_plot.png", plot)   # outputs/ did not exist
```

**Fix:**

```r
dir.create("output", showWarnings = FALSE)
ggsave("output/my_plot.png", plot)
```

## How to run the fixed script

From this directory:

```bash
Rscript fixed_pipeline.R
```

Or in R / RStudio:

```r
source("fixed_pipeline.R")
```

Expected: console reports `Saving 7 x 7 in image` and `output/my_plot.png` is created.

## Output

- **`output/my_plot.png`** — scatter plot of average fertility vs. average education for majority-Catholic cantons (single aggregated point, one red marker).

## Learning takeaways

1. **R is case-sensitive** — `True`/`False` are not `TRUE`/`FALSE`.
2. **Match every parenthesis** — one missing `)` can break the whole file with a confusing parse error far from the real mistake.
3. **ggplot2 uses `+`, not `|>`** — do not mix them in one plot chain; finish with `+ labs(...)` etc.
4. **Create output folders before saving** — `ggsave()` does not create directories for you.
5. **`summarize()` without `group_by()` returns one row** — so this plot shows a single point. If you want one point per province, plot `high_catholic` directly instead of `summary_stats`.
6. Prefer `TRUE` over the shortcut `T`, which can be accidentally overwritten.
