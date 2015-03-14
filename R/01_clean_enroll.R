#' clean_enroll()
#'
#' This function takes two dataframes exported from the following ETO Results reports: 1)"[Admin] raw_enrollment_report", and 2) "[Admin] raw_program_type_report" as inputs. It does some specific cleaning, merge them, and returns one dataframe ready for further analysis.
#' @param enroll_data dataframe: a dataframe containing enrollment data."[Admin] raw_enrollment_report"
#' @param program_type dataframe: a dataframe containing information about each program intervention type. "[Admin] raw_program_type_report"
#' @param start_date character: All program start dates in enroll_data must be posterior or equal to this date. Date must be specified as "mm/dd/yyyy"
#' @param end_date character: All program end dates in enroll_data must be anterior or equal to this date. Date must be specified as "mm/dd/yyyy"
#' @return dataframe
#' @export
#' @examples
#' enroll <- laycUtils::load_txt('./my_data_folder/enrollment.txt')
#' enroll <- laycUtils::clean_data(enroll)
#' ptype <- laycUtils::load_txt('./my_data_folder/program_type.txt')
#' ptype <- laycUtils::clean_data(ptype)
#' clean_enroll(enroll_data = enroll, program_type = ptype)

clean_enroll <- function(enroll_data, program_type,
                     start_date = NULL,
                     end_date = Sys.Date()) {
  
  # Remove extra columns for a cleaner merge with enroll_data
  program_type <- dplyr::select_(program_type, ~program_id, ~intervention_type)
  
  # Clean end date
  if(class(end_date) == "Date") {
    end_date <- as.character(end_date)
    end_date <- lubridate::ymd(end_date)
  } else {
    end_date <- lubridate::mdy(end_date)
  }
  
  enroll_data$end[is.na(enroll_data$end)] <- end_date
  enroll_data$end[enroll_data$end > end_date] <- end_date
  
  # Clean start date
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
