library(tidyverse)
library(cowplot)
library(PerformanceAnalytics)

# https://trends.google.com/trends/explore?date=2008-01-01%202020-09-30&q=%2Fm%2F0bs2j8q,%2Fm%2F01hyh_,%2Fm%2F0jt3_q3,%2Fm%2F0mkz&hl=en-US
with_ai <- read_csv("multiTimeline.csv", 
                    skip = 2, col_types = "ccccc")

# https://trends.google.com/trends/explore?date=2008-01-01%202020-09-30&q=%2Fm%2F0bs2j8q,%2Fm%2F01hyh_,%2Fm%2F0jt3_q3&hl=en-US
no_ai <- read_csv("multiTimeline(1).csv",
                  skip = 2, col_types = "cccc")

with_ai[with_ai == "<1"] <- "0.5"
no_ai[no_ai == "<1"] <- "0.5"

with_ai[,2:5] <- apply(with_ai[,2:5], 2, as.numeric)
no_ai[,2:4] <- apply(no_ai[,2:4], 2, as.numeric)

with_ai <- rename(with_ai, 
                  `big data` = `Big data: (Cały świat)`,
                  `uczenie maszynowe` = `Uczenie maszynowe: (Cały świat)`,
                  `data science` = `Danologia: (Cały świat)`,
                  `sztuczna inteligencja` = `Sztuczna inteligencja: (Cały świat)`)

no_ai <- rename(no_ai, 
                  `big data` = `Big data: (Cały świat)`,
                  `uczenie maszynowe` = `Uczenie maszynowe: (Cały świat)`,
                  `data science` = `Danologia: (Cały świat)`)

# chart.Correlation(with_ai[,2:5], histogram = TRUE, method = "pearson")
# chart.Correlation(no_ai[,2:4], histogram = TRUE, method = "spearman")
# 
# summary(lm(log(`data science`) ~ parse_date(Miesiąc, "%Y-%m"), no_ai))
# 
# ggplot(no_ai, aes(parse_date(Miesiąc, "%Y-%m"), `data science`, 10)) + geom_point() +
#   geom_smooth()

with_ai <- gather(with_ai, "Temat", "Popularność", -Miesiąc)
no_ai <- gather(no_ai, "Temat", "Popularność", -Miesiąc)

with_ai$Temat <- fct_relevel(with_ai$Temat,
                             "big data",
                             "data science",
                             "uczenie maszynowe",
                             "sztuczna inteligencja")

w <- ggplot(with_ai) + 
  geom_line(aes(x = parse_date(Miesiąc, "%Y-%m"),
                y = Popularność, colour = Temat), 
            size = 1) +
  labs(title = '1A', x = "", 
       subtitle = 'Temat "sztuczna inteligencja" był najbardziej popularnym wśród analizowanych') + 
  scale_colour_brewer(palette = "Set1", name = "Temat w wyszukiwarce\nGoogle") +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y", minor_breaks = NULL) +
  theme_minimal(base_family = "serif", base_size = 10) +
  theme(legend.position = "bottom", legend.direction = "horizontal", legend.box.just = "left")

n <- ggplot(no_ai) + 
  geom_line(aes(x = parse_date(Miesiąc, "%Y-%m"),
                y = Popularność, colour = Temat), 
            size = 1) +
  labs(title = '1B', x = "",
       subtitle = 'Pomijając "sztuczną inteligencję", temat "big data" był od 02.2012 do 03.2017 najpopularniejszym.\nPóźniej najbardziej popularny stał się temat "uczenia maszynowego".\nŚrednio "data science" było najmniej popularnym tematem. Jednak od grudnia 2018 jego popularność\nprzekracza popularność tematu "big data"',
       caption = 'Dane z Google Trends od 01.01.2008 do 30.09.2020, zakres geograficzny "Cały świat"') + 
  scale_colour_brewer(palette = "Set1") +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y", minor_breaks = NULL) +
  theme_minimal(base_family = "serif", base_size = 10) +
  guides(colour = "none")

# (p <- cowplot::plot_grid(w, n, nrow = 2))
# 
# png("google-trends.png", width = 160, height = 190, units = "mm", res = 300)
# plot(p) # Rys. 1.
# dev.off()

