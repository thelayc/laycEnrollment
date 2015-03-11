#' get_histogram()
#'
#' Create a multiple histograms representing enrollment length by programt type (workforce, education, etc.)
#' @param df dataframe: a dataframe returned by the get_summary() function
#' @export
#' @import ggplot2
#' @return dataframe
#' @examples
#' enroll <- laycUtils::load_txt('./my_data_folder/enrollment.txt')
#' ptype <- laycUtils::load_txt('./my_data_folder/program_type.txt')
#' df <- clean_df(enroll_data = enroll, program_type = ptype)
#' summary <- get_summary(df)
#' get_histogram(summary)

get_histogram <- function(df) {
ggplot(df, aes(x = days)) +
    geom_histogram() +
    facet_wrap(~intervention_type) +
    laycUtils::theme_layc() +
    ggtitle('Lenght of enrollment in a program\nDistribution by main area of intervention') +
    theme(
      plot.title = element_text(size = rel(2), face = 'bold')
      )
}
