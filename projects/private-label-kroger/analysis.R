# Private Label at Kroger — BZAN 535 Team Project 1
# Source author: Joseph Falcone
# Requires tidyverse and transaction_data.csv, product.csv, and
# hh_demographic.csv in your R working directory.

library(tidyverse)

transactions <- read_csv("transaction_data.csv")
products <- read_csv("product.csv")
demographics <- read_csv("hh_demographic.csv")

data <- transactions |>
    left_join(products, by = 'PRODUCT_ID') |>
    left_join(demographics, by = 'household_key')

glimpse(data)

# Count of private and national transactions
data |>
    count(BRAND)

# Count of transactions per department
data |>
    count(DEPARTMENT, sort = TRUE)

# Count of each income groups
data |>
    count(INCOME_DESC, sort = TRUE)

# Count of transactions with demographic info
data |>
    summarise(
        total_rows = n(),
        rows_with_income = sum(!is.na(INCOME_DESC)),
        percent_with_income = mean(!is.na(INCOME_DESC)) * 100
    )

data <- data |>
    mutate(
        private_sales = if_else(
            BRAND == 'Private',
            SALES_VALUE, 0
            )
    )

household_data <- data |>
    filter(!is.na(INCOME_DESC)) |>
    group_by(household_key, INCOME_DESC) |>
    summarise(
        total_sales = sum(SALES_VALUE, na.rm = TRUE),
        private_sales = sum(private_sales, na.rm = TRUE),
        .groups = 'drop'
    ) |>
        mutate(
            private_share = private_sales / total_sales
        )

glimpse(household_data)
summary(household_data$private_share)

household_data |>
    group_by(INCOME_DESC) |>
    summarise(
        n = n(),
        mean_private_share = mean(private_share, na.rm = TRUE),
        median_private_share = median(private_share, na.rm = TRUE),
        sd_private_share = sd(private_share, na.rm = TRUE)
    ) |>
        arrange(desc(mean_private_share))

ggplot(household_data, aes(x = private_share)) +
    geom_histogram(bins = 30) +
    labs(
        title = 'Distribution of Household Private Label Dollar Share',
        x = 'Private Label Dollar Share',
        y = 'Number of Households'
    )

ggplot(household_data, aes(x = INCOME_DESC, y = private_share)) +
    geom_boxplot() +
    coord_flip() +
    labs(
        title = 'Private Label Dollar Share by Household Income',
        x = 'Income Group',
        y = 'Private Label Dollar Share '
    )

income_summary <- household_data |>
    group_by(INCOME_DESC) |>
    summarise(
        n = n(),
        mean_private_share = mean(private_share, na.rm = TRUE),
        median_private_share = median(private_share, na.rm = TRUE),
        sd_private_share = sd(private_share, na.rm = TRUE)
    ) |>
        arrange(desc(mean_private_share))

income_summary

household_data <- household_data |>
    mutate(
        income_group = case_when(
            INCOME_DESC %in% c(
                "Under 15K",
                "15-24K",
                "25-34K",
                "35-49K"
            ) ~ "Below $50K",

            INCOME_DESC %in% c(
                "50-74K",
                "75-99K"
            ) ~ "$50K-$99K",

            INCOME_DESC %in% c(
                "100-124K",
                "125-149K",
                "150-174K",
                "175-199K",
                "200-249K",
                "250K+"
            ) ~ "$100K+"
        )
    )

income_group_summary <- household_data |>
    group_by(income_group) |>
    summarise(
        n = n(),
        mean_private_share = mean(private_share),
        median_private_share = median(private_share),
        sd_private_share = sd(private_share)
    )

income_group_summary

ggplot(
    household_data,
    aes(x = income_group, y = private_share)
) +
    geom_boxplot() +
    labs(
        title = "Private-Label Dollar Share by Household Income",
        x = "Household Income",
        y = "Private-Label Dollar Share"
    )

oneway.test(
    private_share ~ income_group,
    data = household_data,
    var.equal = FALSE
)

pairwise.t.test(
    household_data$private_share,
    household_data$income_group,
    p.adjust.method = "bonferroni",
    pool.sd = FALSE
)

t.test(
    private_share ~ income_group,
    data = household_data |>
        filter(income_group %in% c("Below $50K", "$100K+"))
)

department_data <- data |>
    filter(!is.na(INCOME_DESC)) |>
    mutate(
        income_group = case_when(
            INCOME_DESC %in% c(
                "Under 15K",
                "15-24K",
                "25-34K",
                "35-49K"
            ) ~ "Below $50K",

            INCOME_DESC %in% c(
                "50-74K",
                "75-99K"
            ) ~ "$50K-$99K",

            INCOME_DESC %in% c(
                "100-124K",
                "125-149K",
                "150-174K",
                "175-199K",
                "200-249K",
                "250K+"
            ) ~ "$100K+"
        )
    ) |>
    filter(income_group %in% c("Below $50K", "$100K+")) |>
    group_by(household_key, income_group, DEPARTMENT) |>
    summarise(
        total_sales = sum(SALES_VALUE, na.rm = TRUE),
        private_sales = sum(private_sales, na.rm = TRUE),
        .groups = "drop"
    ) |>
    mutate(
        private_share = private_sales / total_sales
    )

department_summary <- department_data |>
    group_by(DEPARTMENT, income_group) |>
    summarise(
        n = n(),
        mean_private_share = mean(private_share, na.rm = TRUE),
        .groups = "drop"
    )

department_summary

department_summary |>
    filter(DEPARTMENT == "GROCERY")

t.test(
    private_share ~ income_group,
    data = department_data |>
        filter(DEPARTMENT == "GROCERY")
)

top_grocery_commodities <- data |>
    filter(
        DEPARTMENT == "GROCERY",
        !is.na(COMMODITY_DESC)
    ) |>
    group_by(COMMODITY_DESC) |>
    summarise(
        total_sales = sum(SALES_VALUE, na.rm = TRUE),
        .groups = "drop"
    ) |>
    arrange(desc(total_sales))

top_grocery_commodities

top_categories <- c(
    "SOFT DRINKS",
    "FLUID MILK PRODUCTS",
    "CHEESE",
    "FRZN MEAT/MEAT DINNERS",
    "BAG SNACKS"
)

commodity_data <- data |>
    filter(
        DEPARTMENT == "GROCERY",
        COMMODITY_DESC %in% top_categories,
        !is.na(INCOME_DESC)
    ) |>
    mutate(
        income_group = case_when(
            INCOME_DESC %in% c(
                "Under 15K",
                "15-24K",
                "25-34K",
                "35-49K"
            ) ~ "Below $50K",

            INCOME_DESC %in% c(
                "100-124K",
                "125-149K",
                "150-174K",
                "175-199K",
                "200-249K",
                "250K+"
            ) ~ "$100K+"
        )
    ) |>
    filter(!is.na(income_group)) |>
    group_by(
        household_key,
        income_group,
        COMMODITY_DESC
    ) |>
    summarise(
        total_sales = sum(SALES_VALUE, na.rm = TRUE),
        private_sales = sum(private_sales, na.rm = TRUE),
        .groups = "drop"
    ) |>
    mutate(
        private_share = private_sales / total_sales
    )

commodity_summary <- commodity_data |>
    group_by(COMMODITY_DESC, income_group) |>
    summarise(
        n = n(),
        mean_private_share = mean(private_share),
        median_private_share = median(private_share),
        .groups = "drop"
    )

commodity_summary

commodity_tests <- commodity_data |>
    group_by(COMMODITY_DESC) |>
    group_modify(~ {
        test <- t.test(
            private_share ~ income_group,
            data = .x
        )

        tibble(
            difference = unname(
                test$estimate["mean in group Below $50K"] -
                test$estimate["mean in group $100K+"]
            ),
            conf_low = -test$conf.int[2],
            conf_high = -test$conf.int[1],
            p_value = test$p.value
        )
    }) |>
    ungroup() |>
    mutate(
        p_adjusted = p.adjust(p_value, method = "bonferroni")
    )

commodity_tests
