enroll_data <- laycUtils::load_txt('../temp_data/fy14/raw_enrollment_report.txt')
keep <- !str_detect(enroll_data$program_name, '^rb -')
enroll_data <- filter(enroll_data, keep)
enroll_data <- filter(enroll_data, program_name != 'ss - case management')

program_type <- laycUtils::load_txt('../temp_data/fy14/program_type.txt')

