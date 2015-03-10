#' get_enrollment()
#'
#' This function takes two dataframes 1)[INSERT REPORT NAME HERE], and 2) [INSERT REPORT NAME HERE] as inputs, and returns summary tables and charts about participants enrollment
#' @param enroll_data dataframe: a dataframe containing enrollment data.[INSERT REPORT NAME HERE] 
#' @param program_type dataframe: a dataframe containing information about each program intervention type. [INSERT REPORT NAME HERE]
#' @return list
#' @export
#' @examples
#' enroll <- laycUtils::load_txt('../temp_data/fy14/raw_enrollment_report.txt')
#' ptype <- laycUtils::load_txt('../temp_data/fy14/program_type.txt')
#' get_enrollment(enroll_data = enroll, program_type = ptype)

get_enrollment <- function(enroll_data, program_type, 
                           start_date = '01/01/2008',
                           end_date = Sys.Date()) {
  # Clean dataframes
  # Merge dataframes
  # Plot histogram
  # Get summary table
  # plot enrollment
  
}




