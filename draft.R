library(ggplot2)
options(stringsAsFactors = FALSE)
list.files('./temp_data/')
library(dplyr)
library(stringr)

# Load data
df <- laycUtils::load_txt('./temp_data/raw_enrollment_report.txt')
ptype <- laycUtils::load_txt('./temp_data/program_type.txt')
ptype <- select(ptype, program_id, intervention_type)
dosage <- laycUtils::load_txt('./temp_data/raw_dosage_report.txt')

# Merge data
df <- dplyr::left_join(df, ptype, by = c('program_id'))

# clean data
headers <- names(df)
headers[1] <- 'id'
names(df) <- headers
df$days_enrolled <- as.numeric(df$days_enrolled)

keep <- !str_detect(df$program_name, '^rb -')
df <- filter(df, keep)

# Number of participants served by program area
df %>%
  group_by(intervention_type) %>%
  summarise(n = length(id)) ->
  test

##########################################
length(unique(df$id))
sort(unique(df$program_name))

df %>%
  filter(is.na(intervention_type)) %>%
  select(program_name) %>%
  distinct -> missing

missing <- missing[, 1]

for (prog in missing) {
  print(prog)
  print(df[(df$program_name == prog), c('id', 'program_name', 'start', 'end')])
}









