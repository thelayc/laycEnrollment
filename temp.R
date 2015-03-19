# Load libraries
library(laycUtils)
library(laycEnrollment)
library(dplyr)
library(stringr)
# Load and basic cleaning
enroll_data <- laycUtils::load_txt('../temp_data/fy14/raw_enrollment_report.txt')
enroll_data <- laycUtils::clean_data(enroll_data)
program_type <- laycUtils::load_txt('../temp_data/fy14/program_type.txt')
program_type <- laycUtils::clean_data(program_type)
# Subset data
keep <- !stringr::str_detect(enroll_data$program_name, '^rb -')
enroll_data <- dplyr::filter(enroll_data, keep)
enroll_data <- dplyr::filter(enroll_data, program_name != 'ss - case management')
enroll_data <- clean_enroll(enroll_data, program_type,
                            start_date = '01/01/2008',
                            end_date = '09/30/2014')
# Pull summary statistics
get_summary(enroll_data)

