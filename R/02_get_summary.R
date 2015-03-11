#' get_summary()
#'
#' Compute summary statistics about enrollment, by program type (education, workforce, etc.)
#' @param df dataframe: a dataframe returned by the clean_df() function
#' @export
#' @return dataframe
#' @examples
#' enroll <- laycUtils::load_txt('./my_data_folder/enrollment.txt')
#' ptype <- laycUtils::load_txt('./my_data_folder/program_type.txt')
#' df <- clean_df(enroll_data = enroll, program_type = ptype)
#' get_summary(df)

get_summary <- function(df){
  df %>%
    group_by_(~intervention_type) %>%
    summarise_(n = ~length(id),
               av_days = ~mean(days),
               std_days = ~sd(days)) ->
    df
}
