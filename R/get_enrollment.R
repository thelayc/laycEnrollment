#' get_enrollment()
#'
#' This function takes two dataframes 1)[INSERT REPORT NAME HERE], and 2) [INSERT REPORT NAME HERE] as inputs, and returns summary tables and charts about participants enrollment
#' @param enroll_data dataframe: a dataframe containing enrollment data.[INSERT REPORT NAME HERE]
#' @param program_type dataframe: a dataframe containing information about each program intervention type. [INSERT REPORT NAME HERE]
#' @param start_date character: All program start dates in enroll_data must be posterior or equal to this date. Date must be specified as "mm/dd/yyyy"
#' @param end_date character: All program end dates in enroll_data must be anterior or equal to this date. Date must be specified as "mm/dd/yyyy"
#' @return list
#' @export
#' @examples
#' enroll <- laycUtils::load_txt('./my_data_folder/enrollment.txt')
#' ptype <- laycUtils::load_txt('./my_data_folder/program_type.txt')
#' get_enrollment(enroll_data = enroll, program_type = ptype)

get_enrollment <- function(enroll_data, program_type,
                           start_date = '01/01/2008',
                           end_date = Sys.Date()) {
  # Clean data
  enroll_data <- clean_df(enroll_data, program_type, start_date = start_date, end_date = end_date)
  # Generate summary table
  enroll_summary <- get_summary(enroll_data)

}







