#' clean_df()
#'
#' This function takes two dataframes 1)[INSERT REPORT NAME HERE], and 2) [INSERT REPORT NAME HERE] as inputs, does some cleaning, merge them, and returns one dataframe ready for further analysis.
#' @param enroll_data dataframe: a dataframe containing enrollment data.[INSERT REPORT NAME HERE]
#' @param program_type dataframe: a dataframe containing information about each program intervention type. [INSERT REPORT NAME HERE]
#' @param start_date character: All program start dates in enroll_data must be posterior or equal to this date. Date must be specified as "mm/dd/yyyy"
#' @param end_date character: All program end dates in enroll_data must be anterior or equal to this date. Date must be specified as "mm/dd/yyyy"
#' @return dataframe
#' @export
#' @examples
#' enroll <- laycUtils::load_txt('./my_data_folder/enrollment.txt')
#' ptype <- laycUtils::load_txt('./my_data_folder/program_type.txt')
#' clean_df(enroll_data = enroll, program_type = ptype)

clean_df <- function(enroll_data, program_type,
                     start_date = NULL,
                     end_date = Sys.Date()) {
  # Remove extra columns for a cleaner merge with enroll_data
  program_type <- dplyr::select_(program_type, ~program_id, ~intervention_type)
  # Change days_enrolled to numeric for plottingand computations
  enroll_data$days_enrolled <- as.numeric(enroll_data$days_enrolled)
  # Clean end date
  if(class(end_date) == "Date") {
    end_date <- as.character(end_date)
    end_date <- lubridate::ymd(end_date)
  } else {
    end_date <- lubridate::mdy(end_date)
  }
  enroll_data$end <- lubridate::mdy(enroll_data$end)
  enroll_data$end[is.na(enroll_data$end)] <- end_date
  enroll_data$end[enroll_data$end > end_date] <- end_date
  # Clean start date
  enroll_data$start <- lubridate::mdy(enroll_data$start)
  if (!is.null(start_date)) {
    start_date <- lubridate::mdy(start_date)
    enroll_data$start[enroll_data$start < start_date] <- start_date
  }
  # Compute enrollment time (in days)
  span <- lubridate::new_interval(enroll_data$start, enroll_data$end) #interval
  enroll_data$days <- lubridate::as.period(span, units = "day")
  enroll_data$days <- lubridate::day(enroll_data$days)
  # Merge dataframes
  enroll_data <- dplyr::left_join(enroll_data, program_type, by = c('program_id'))

  return(enroll_data)
}
