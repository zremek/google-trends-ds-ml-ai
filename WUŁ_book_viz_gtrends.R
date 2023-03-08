# gdzie skrypt? sprawdzić w530

ggplot2::theme_set(theme_minimal(base_size = 8))


w <- ggplot(with_ai) + 
  geom_line(aes(x = parse_date(Miesiąc, "%Y-%m"),
                y = Popularność, colour = Temat), 
            size = 1) +
  labs(title = 'A', x = "", 
       subtitle = 'Temat „sztuczna inteligencja” był najbardziej popularny wśród analizowanych.') + 
  scale_colour_brewer(palette = "Set1", name = "Temat") +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y", minor_breaks = NULL) +
  theme(legend.position = "bottom", legend.direction = "horizontal", legend.box.just = "left")

n <- ggplot(no_ai) + 
  geom_line(aes(x = parse_date(Miesiąc, "%Y-%m"),
                y = Popularność, colour = Temat), 
            size = 1) +
  labs(title = 'B', x = "",
       subtitle = 'Pomijając „sztuczną inteligencję”, temat „big data” był od lutego 2012 do marca 2017\nnajpopularniejszy. Później najpopularniejsze stało się „uczenie maszynowe”.\nŚrednio „data science” było najmniej popularnym tematem. Jednak od grudnia 2018\njego popularność przekracza popularność „big data”.',
       caption = 'Dane z Google Trends od 1.01.2008 do 30.09.2020, zakres geograficzny „Cały świat”') + 
  scale_colour_brewer(palette = "Set1") +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y", minor_breaks = NULL) +
  guides(colour = "none")

(p <- cowplot::plot_grid(w, n, nrow = 2))

# ggsave("1_1_gtends.jpg", units = "cm", width = 12.6, height = 12)


