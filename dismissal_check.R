library(ggplot2)
options(stringsAsFactors = FALSE)
list.files('./temp_data/')
library(dplyr)
library(stringr)

# Load data
df <- laycUtils::load_txt('./temp_data/raw_enrollment_report.txt')
#ptype <- laycUtils::load_txt('./temp_data/program_type.txt')
#ptype <- select(ptype, program_id, intervention_type)
pos <- laycUtils::load_txt('./temp_data/raw_dosage_report.txt')
tp <- laycUtils::load_txt('./temp_data/raw_touchpoint_report.txt')

# clean data
# df
headers <- names(df)
headers[1] <- 'id'
names(df) <- headers
df$days_enrolled <- as.numeric(df$days_enrolled)

keep <- !str_detect(df$program_name, '^rb -')
df <- filter(df, keep)

# pos
pos %>%
  select(id = tp_id, program_id = program_id_pos) %>%
  distinct ->
  pos
pos$service <- 1

# tp
tp %>%
  select(id = subject_id, program_id) %>%
  distinct ->
  tp
tp$service <- 1

service <- bind_rows(pos, tp)
service <- unique(service)

# merge
df %>%
  left_join(pos, by = c('id', 'program_id')) ->
  test

test %>% 
  filter(is.na(service)) ->
  issue

test %>% 
  filter(!is.na(pos)) %>%
  distinct(id) %>%
  count()
