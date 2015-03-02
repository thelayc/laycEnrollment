library(ggplot2)
options(stringsAsFactors = FALSE)
list.files('./temp_data/')
library(dplyr)
library(stringr)

# Load data
df <- laycUtils::load_txt('./temp_data/raw_enrollment_report.txt')
#ptype <- laycUtils::load_txt('./temp_data/program_type.txt')
#ptype <- select(ptype, program_id, intervention_type)
pos <- laycUtils::load_txt('./temp_data/raw_pos_report.txt')
tp <- laycUtils::load_txt('./temp_data/raw_touchpoint_report.txt')
ref <- laycUtils::load_txt('./temp_data/raw_referrals_report.txt')
asmt <- laycUtils::load_txt('./temp_data/raw_assessment_report.txt')

# clean data
# df
# headers <- names(df)
# headers[1] <- 'id'
# names(df) <- headers
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

# asmt
asmt %>%
  select(id = subject_id, program_id) %>%
  distinct ->
  asmt
asmt$service <- 1

# ref
ref %>%
  select(id = subject_id, program_id) %>%
  distinct ->
  ref
ref$service <- 1

service <- bind_rows(pos, tp, asmt, ref)
service <- unique(service)

# merge
df %>%
  select(-id) %>%
  rename(id = subject_id) %>%
  left_join(service, by = c('id', 'program_id')) ->
  test

test %>%
  filter(is.na(service)) ->
  issue

# Save list of participants with issue
programs <- sort(unique(issue$program_name))

for (program in programs) {
  out <- issue[issue$program_name == program, ]
  write.csv(out, file = paste0('./output/', program, '.csv'), row.names = FALSE)
}


issue %>%
  group_by(program_name) %>%
  summarise(n = length(id)) %>%
  arrange(desc(n)) %>%
  filter(n > 20) ->
  issue_summary

my_title <- 'Number of participants active in a program during FY14\nwithout any other type of information recorded in ETO\n'
p <- ggplot(issue_summary, aes(x = reorder(program_name, n), y = n)) + coord_flip()
p <- p + geom_point()
p <- p + ggtitle(my_title)
p <- p + ylim(c(0, 200))
p

test %>%
  filter(!is.na(service)) %>%
  distinct(id) %>%
  count()
