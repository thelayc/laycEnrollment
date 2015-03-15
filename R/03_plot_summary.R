#' plot_summary()
#'
#' Plot summary statistics about enrollment
#' @param df dataframe: a dataframe returned by the get_summary() function
#' @export
#' @import ggplot2
#' @return dataframe
#' @examples
#' enroll <- laycUtils::load_txt('./my_data_folder/enrollment.txt')
#' ptype <- laycUtils::load_txt('./my_data_folder/program_type.txt')
#' df <- clean_df(enroll_data = enroll, program_type = ptype)
#' summary <- get_summary(df)
#' plot_summary(summary)

plot_summary <- function(df) {
  ymax <- max(df$av_days)
  df$max[df$av_days == ymax] <- 1
  df$max[df$av_days < ymax] <- 0
  df$max <- as.factor(df$max)

  p <- ggplot(df, 
              aes(x = reorder(intervention_type, av_days)), 
              environment = environment()) +
    geom_bar(aes(y = av_days, fill = max), stat = 'identity') +
    geom_text(aes(y = av_days + ymax / 25, label = round(av_days, 0)), size = rel(4), fontface = 'bold') +
    scale_fill_manual(values = c('#474747', '#C00000')) +
    laycUtils::theme_layc() +
    coord_flip(ylim = c(0, ymax * 1.25)) +
    ggtitle('Average enrollment length (in days)\nby area of intervention\n') +
    theme(
      plot.title = element_text(size = rel(1.5), face = 'bold'),
      axis.ticks = element_blank(),
      axis.text.x = element_blank(),
      axis.text.y = element_text(size = rel(1.5), face = 'bold'),
      axis.title = element_blank(),
      panel.border = element_blank(),
      legend.position = 'none'
    )

  return(p)
}

