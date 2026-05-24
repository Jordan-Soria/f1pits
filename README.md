
# f1pits <img src='hex.png' align="right" width="25%" min-width="120px"/>

Formula 1 pit stop data.

The package provides information on teams and drivers across seasons
(since 2019), pit stop awards (since 2015) and includes functions to
visualize pit stop performance.

[![CRAN RStudio mirror downloads](https://cranlogs.r-pkg.org/badges/last-week/f1pits?color=yellow)](https://r-pkg.org/pkg/f1pits)

# Vignette Info. Introduction:

The `f1pits` package provides datasets of Formula 1 race pit stops
(since 2019), extracted from [DHL
website](https://inmotion.dhl/en/formula-1/fastest-pit-stop-award) and
functions to visualize pit stop data.

This package can be considered complementary to the `f1dataR` package,
which provides Formula 1 race data. You can download `f1pits` package in
[GitHub](https://github.com/Jordan-Soria/f1pits).

# Exemple to use:

## Step 1: Pit Stops data

To extract the pit stop data for a specific race or an entire season,
use the `pits()` function. Check the documentation for the different
arguments of the function.

``` r
# Accessing the data, for example, round 1, Australian GP 2026:

pits(1, 2026) -> pitdata
```

    ## Australian Grand Prix 2026 / Round: 1

``` r
pitdata
```

    ## # A tibble: 30 × 8
    ##     Pos. Team         Driver     `Time (sec)`   Lap Points Round  Year
    ##    <dbl> <chr>        <chr>             <dbl> <dbl>  <dbl> <int> <dbl>
    ##  1     1 Mercedes     Russell            2.17    12     25     1  2026
    ##  2     2 Ferrari      Leclerc            2.22    25     18     1  2026
    ##  3     3 Red Bull     Verstappen         2.24    41     15     1  2026
    ##  4     4 Ferrari      Hamilton           2.26    28     12     1  2026
    ##  5     5 Red Bull     Verstappen         2.4     18      0     1  2026
    ##  6     6 Racing Bulls Lindblad           2.42    18     10     1  2026
    ##  7     7 Mercedes     Antonelli          2.49    12      8     1  2026
    ##  8     8 McLaren      Norris             2.52    34      6     1  2026
    ##  9     9 Racing Bulls Lawson             2.59    33      4     1  2026
    ## 10    10 Williams     Albon              2.63    33      2     1  2026
    ## # ℹ 20 more rows

The output generated is a tibble containing the columns:

**Pos.** (position according to pit stop time), **Team**, **Driver**,
**Time (sec)** is the time (in seconds) of each pitstop, **Lap** (lap of
the race; does NOT include sprint sessions), and **Points** (DHL points.
If a driver makes more than one pit stop among the top 10 fastest, the
second and subsequent pit stops by that driver do not receive points).

## Step 2: ELO team calculations

You can calculate ELO ratings of each team from a pit stop dataset,
using a single race or multiple races from the one or different seasons
with `pitelo()` function.

``` r
pitelo(pitdata)
```

    ## Using default median stats

    ## Using default batch calc

    ## Team family mode enabled

    ## elo_data is missing or is not a data.frame 
    ## Using ELO default value (1000)

    ##            Team Rating
    ## 1       Ferrari   1100
    ## 2      Red Bull   1080
    ## 3      Mercedes   1060
    ## 4  Racing Bulls   1040
    ## 5       McLaren   1020
    ## 6          Haas   1000
    ## 7        Alpine    980
    ## 8          Audi    960
    ## 9      Williams    940
    ## 10     Cadillac    920
    ## 11 Aston Martin    900

The ELO calculation is the *mean*, *median*, or *minimum* pit stop
position of the teams in each race (see `stat_fun` argument). On the
other hand, two methodologies can be applied for ELO calculation:
*sequential* or *batch* (see `calc` argument).

Also you can adjust the magnitude of the ELO change per race (`k`) and
the scaling factors (`c` and `d`). The default values in `pitelo()` are
based on [Hvattum and Arntzen
(2010)](https://doi.org/10.1016/j.ijforecast.2009.10.002).

``` r
pitelo(pitdata, stat_fun = 3, calc = 2, k = 40, c = 20, d = 1000)
```

    ## Using min stats

    ## Using sequential calc

    ## Team family mode enabled

    ## elo_data is missing or is not a data.frame 
    ## Using ELO default value (1000)

    ##            Team    Rating
    ## 1      Mercedes 1182.0120
    ## 2       Ferrari 1150.1299
    ## 3      Red Bull 1104.7946
    ## 4  Racing Bulls 1068.1140
    ## 5       McLaren 1036.9241
    ## 6      Williams  989.6870
    ## 7          Haas  960.5865
    ## 8          Audi  925.6730
    ## 9        Alpine  887.6324
    ## 10     Cadillac  866.2944
    ## 11 Aston Martin  828.1521

The different names that the same F1 team structure has had over the
years will be collapsed by default into the last used in the dataset,
for example: Toro Rosso (2019) → AlphaTauri (2020-2023) → RB (2024) →
Racing Bulls (2025-2026).

``` r
pits(1, 2024) -> pitdata24
```

    ## Bahrain Grand Prix 2024 / Round: 1

``` r
pits(1, 2025) -> pitdata25
```

    ## Australian Grand Prix 2025 / Round: 1

``` r
# Join datasets:
pitdata_multiple <- dplyr::bind_rows(pitdata, pitdata24, pitdata25)

# Show all teams in dataset:
unique(pitdata_multiple$Team)
```

    ##  [1] "Mercedes"     "Ferrari"      "Red Bull"     "Racing Bulls" "McLaren"     
    ##  [6] "Williams"     "Haas"         "Audi"         "Alpine"       "Cadillac"    
    ## [11] "Aston Martin" "RB"           "Sauber"

``` r
pitelo(pitdata_multiple, fml = TRUE)
```

    ## Using default median stats

    ## Using default batch calc

    ## Team family mode enabled

    ## elo_data is missing or is not a data.frame 
    ## Using ELO default value (1000)

    ##            Team    Rating
    ## 1       Ferrari 1211.7194
    ## 2      Red Bull 1151.5279
    ## 3  Racing Bulls 1115.4788
    ## 4      Mercedes 1086.2265
    ## 5          Haas 1022.2793
    ## 6       McLaren  969.3146
    ## 7      Cadillac  919.9927
    ## 8      Williams  893.2640
    ## 9  Aston Martin  887.8762
    ## 10       Alpine  883.1337
    ## 11         Audi  859.1870

``` r
pitelo(pitdata_multiple, fml = FALSE)
```

    ## Using default median stats

    ## Using default batch calc

    ## Team family mode disabled

    ## elo_data is missing or is not a data.frame 
    ## Using ELO default value (1000)

    ##            Team    Rating
    ## 1       Ferrari 1212.1202
    ## 2      Red Bull 1152.3461
    ## 3  Racing Bulls 1090.5688
    ## 4      Mercedes 1087.5134
    ## 5            RB 1050.0000
    ## 6          Haas 1023.6031
    ## 7       McLaren  971.1382
    ## 8          Audi  962.5177
    ## 9      Cadillac  922.5177
    ## 10     Williams  895.0968
    ## 11 Aston Martin  889.4979
    ## 12       Alpine  885.0422
    ## 13       Sauber  858.0380

Additionally, you can provide your own ELO rating to initialize the
calculations in the function (MUST have the same structure type as in
this example).

``` r
# Create an ELO tibble with a starting value of 1000 for all teams, except Cadillac.
# As a new team it will be slightly penalized 
# because its team structure is completely new.

elo_data <- tibble::tibble(
    Team = c("Ferrari", "Red Bull", "Mercedes", "Racing Bulls", "McLaren",
             "Haas", "Alpine", "Williams", "Audi", "Aston Martin", "Cadillac"),
    Rating = c(1000, 1000, 1000, 1000, 1000,
               1000, 1000, 1000, 1000, 1000, 950))

elo_data
```

    ## # A tibble: 11 × 2
    ##    Team         Rating
    ##    <chr>         <dbl>
    ##  1 Ferrari        1000
    ##  2 Red Bull       1000
    ##  3 Mercedes       1000
    ##  4 Racing Bulls   1000
    ##  5 McLaren        1000
    ##  6 Haas           1000
    ##  7 Alpine         1000
    ##  8 Williams       1000
    ##  9 Audi           1000
    ## 10 Aston Martin   1000
    ## 11 Cadillac        950

``` r
str(elo_data)
```

    ## tibble [11 × 2] (S3: tbl_df/tbl/data.frame)
    ##  $ Team  : chr [1:11] "Ferrari" "Red Bull" "Mercedes" "Racing Bulls" ...
    ##  $ Rating: num [1:11] 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 ...

``` r
pitelo(pitdata, elo = elo_data)
```

    ## Using default median stats

    ## Using default batch calc

    ## Team family mode enabled

    ## # A tibble: 11 × 2
    ##    Team         Rating
    ##    <chr>         <dbl>
    ##  1 Ferrari       1099.
    ##  2 Red Bull      1079.
    ##  3 Mercedes      1059.
    ##  4 Racing Bulls  1039.
    ##  5 McLaren       1019.
    ##  6 Haas           999.
    ##  7 Alpine         979.
    ##  8 Audi           959.
    ##  9 Williams       939.
    ## 10 Aston Martin   899.
    ## 11 Cadillac       884.

## Step 3 (if you want): Plotting

The `f1pits` package includes the `pitplot()` function, which takes the
data obtained from `pits()` and produces a ggplot object to visualize
pit stop performance. Remember that if you want to provide your own
data, the input must be a tibble (see the documentation of `pits()`).
Check the documentation for the different arguments of `pitplot()`
before using it.

``` r
# Plotting the data:

pitplot(pitdata, 2) -> pitplot_pitdata
```

    ## Processing...

    ##   O    _________    O
    ## /|\>  _\=..o..=/_  </|\ 
    ##  / \ |_|-// \\-|_| / \

``` r
pitplot_pitdata
```

![](f1pits_README_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

Finally, if you want a fun text for your plot, run the `pitart()`
function in the `title_text` argument:

``` r
pitplot(pitdata, 2, title_text = paste0(pitart(3), "    Pit Stop data")) -> pitplot_pitdata_title_edit
```

    ## Processing...

    ##   O    _________    O
    ## /|\>  _\=..o..=/_  </|\ 
    ##  / \ |_|-// \\-|_| / \ 
    ##   O    _________    O
    ## /|\>  _\=..o..=/_  </|\ 
    ##  / \ |_|-// \\-|_| / \

``` r
pitplot_pitdata_title_edit
```

![](f1pits_README_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

# Citation

This package makes extensive use of **‘dplyr’** for data manipulation
and **‘ggplot2’** for plotting the data. **‘httr’** and **‘jsonlite’**
also to access my repository data. **‘f1dataR’** has inspired me to
create this package as a complement.

<hr>

To cite this package in publications use:, Jordán-Soria J (2025).
*f1pits: F1 Pit Stop Datasets*. Formula 1 pit stop data. The package
provides information on teams and drivers across seasons (2019 or
higher). It also includes a function to visualize pit stop performance.,
<https://github.com/Jordan-Soria/f1pits>.

A BibTeX entry for LaTeX users is

@Manual{, title = {f1pits: F1 Pit Stop Datasets}, author = {José
Jordán-Soria}, year = {2025}, note = {Formula 1 pit stop data. The
package provides information on teams and drivers across seasons (2019
or higher). It also includes a function to visualize pit stop
performance.}, url = {<https://github.com/Jordan-Soria/f1pits>}, },
