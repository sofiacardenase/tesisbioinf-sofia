#!/usr/bin/env Rscript
# Perfiles de mutación tipo signature SBS96, usando trinucleótidos y colapsando a la base pirimidina de referencia (C o T), como en COSMIC.
# Salida: figuras/por_caso/*.png (facet = profundidad) y figuras/por_profundidad/*.png (facet = caso).

library(tidyverse)

revcomp <- function(x) chartr("ACGT", "TGCA", stringi::stri_reverse(x))

plot_sbs <- function(df, filas, titulo) {
  ggplot(df, aes(tri, prop, fill = tipo)) +
    geom_col() +
    scale_fill_manual(values = paleta) +
    facet_grid(rows = vars({{ filas }}), cols = vars(tipo), scales = "free_x") +
    labs(title = titulo, x = "Contexto", y = "Proporción", fill = "Mutación") +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, size = 5))
}


paleta <- c(
  "C>A" = "#4DB8E8", "C>G" = "#3D4A5C", "C>T" = "#E8605A",
  "T>A" = "#A8A8A8", "T>C" = "#8CC56B", "T>G" = "#E8A3B3"
)

d <- list.files("data", pattern = "\\.csv$", full.names = TRUE) |>
  map_dfr(read_csv, show_col_types = FALSE)

sbs <- d |>
  mutate(
    tri = substr(motif, 2, 4),
    ref = substr(mutacion, 1, 1),
    alt = substr(mutacion, 3, 3),
    purina = ref %in% c("A", "G"),
    tri = if_else(purina, revcomp(tri), tri),
    ref = if_else(purina, chartr("AG", "TC", ref), ref),
    alt = if_else(purina, chartr("ACGT", "TGCA", alt), alt),
    tipo = paste0(ref, ">", alt)
  ) |>
  count(escenario, profundidad, tipo, tri, wt = conteo, name = "n")

# completa las combinaciones faltantes con 0
clases <- expand_grid(
  tipo = c("C>A", "C>G", "C>T", "T>A", "T>C", "T>G"),
  b5 = c("A", "C", "G", "T"),
  b3 = c("A", "C", "G", "T")
) |>
  mutate(tri = paste0(b5, substr(tipo, 1, 1), b3)) |>
  select(tipo, tri)

sbs <- sbs |>
  right_join(expand_grid(distinct(sbs, escenario, profundidad), clases),
    by = c("escenario", "profundidad", "tipo", "tri")
  ) |>
  mutate(n = replace_na(n, 0)) |>
  group_by(escenario, profundidad) |>
  mutate(prop = n / sum(n)) |>
  ungroup() |>
  mutate(
    tri = factor(tri, levels = unique(clases$tri)),
    profundidad = factor(profundidad, levels = sort(unique(profundidad)))
  )

dir.create("figuras/por_caso", recursive = TRUE, showWarnings = FALSE)
dir.create("figuras/por_profundidad", recursive = TRUE, showWarnings = FALSE)

# 1) una figura por caso, facet = profundidad
for (esc in unique(sbs$escenario)) {
  df <- filter(sbs, escenario == esc)
  ggsave(file.path("figuras/por_caso", paste0("sbs96_caso_", esc, ".png")),
    plot_sbs(df, profundidad, paste("Caso", esc)),
    width = 10, height = 1 + 0.9 * n_distinct(df$profundidad), dpi = 200
  )
}

# 2) una figura por profundidad, facet = caso
for (p in levels(sbs$profundidad)) {
  df <- filter(sbs, profundidad == p)
  ggsave(file.path("figuras/por_profundidad", paste0("sbs96_prof_", p, ".png")),
    plot_sbs(df, escenario, paste("Profundidad:", p, "secuencias")),
    width = 10, height = 1 + 1.2 * n_distinct(df$escenario), dpi = 200
  )
}
