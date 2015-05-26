#' get_enroll()
#'
#' This function returns the number of ubduplicated participants who enrolled in a specific program or group of programs. It takes one dataframe as input. The data comes from the following ETO Results report: "[Admin] raw_enrollment_report".
#' @param enroll_data dataframe: a dataframe containing enrollment data."[Admin] raw_enrollment_report"
#' @param eto_programs character vector:  a vector of character containing the name of ETO programs to keep for analysis.
#' @param min_enroll numeric:  The minimum number of days enrolled to be consiedered an active participant
#' @return numeric
#' @export
#' @examples
#' enroll <- laycUtils::load_txt('./my_data_folder/enrollment.txt')
#' enroll <- laycUtils::format_data(enroll)
#'
#' get_enroll(enroll_data = enroll)

get_enroll <- function(enroll_data, eto_programs = NULL, min_enroll = 8)
{

  # CHECK inputs validity
  assertthat::assert_that(is.data.frame(enroll_data))
  assertthat::assert_that(is.character(eto_programs))
  assertthat::assert_that(is.numeric(min_enroll))

  # Subset data if necessary
  if (!is.null(eto_programs)) {
    enroll_data <- enroll_data[enroll_data$program_name %in% eto_programs, ]
  }

  # Keep only active participants
  enroll_data <- enroll_data[enroll_data$days_enrolled > min_enroll, ]

  # Return unduplicated count of participants
  out <- length(unique(enroll_data$subject_id))
  return(out)
}
