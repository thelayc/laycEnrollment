library(ggplot2)
library(ggthemes)
options(stringsAsFactors = FALSE)
list.files('./temp_data/')
library(dplyr)
library(stringr)

# Set constants
end_date <- lubridate::mdy('9/30/2014')
start_date <- lubridate::mdy('1/1/2008')

# Load data
df <- laycUtils::load_txt('../temp_data/fy14/raw_enrollment_report.txt')
ptype <- laycUtils::load_txt('../temp_data/fy14/program_type.txt')
ptype <- select(ptype, program_id, intervention_type)
dosage <- laycUtils::load_txt('../temp_data/fy14/raw_pos_report.txt')

# Merge data
df <- dplyr::left_join(df, ptype, by = c('program_id'))

# clean data
#headers <- names(df)
#headers[1] <- 'id'
#names(df) <- headers
df$days_enrolled <- as.numeric(df$days_enrolled)
# TO DO: ELIMINATE NEXT LINES, SHOULD BE DONE OUTSIDE THE MAIN FUNCTION
keep <- !str_detect(df$program_name, '^rb -')
df <- filter(df, keep)

#df %>% filter(id == '64,392') -> df

## TO DO: CREATE A CLEAN FUNCTION
# Clean end date
df$end <- lubridate::mdy(df$end)
df$end[is.na(df$end)] <- end_date
# Clean start date
df$start <- lubridate::mdy(df$start)
df$start[df$start < start_date] <- start_date

span <- lubridate::new_interval(df$start, df$end) #interval

df$days <- lubridate::as.period(span, units = "day")
df$days <- lubridate::day(df$days)

ggplot(df, aes(x = days)) + geom_histogram() + facet_wrap(~intervention_type)






# Number of participants served by program area
df %>%
  filter(program_name != 'ss - case management') %>%
  group_by(intervention_type) %>%
  summarise(n = length(id),
            av_days = mean(days),
            std_days = sd(days)) ->
  test

# Plot results
p <- ggplot(test, aes(x = reorder(intervention_type, av_days))) + coord_flip()
p <- p + geom_point(aes(y = av_days, color = intervention_type), size = 4)
p <- p + geom_errorbar(aes(ymin = av_days - std_days, ymax = av_days + std_days, color = intervention_type),
                       width = .1)
p <- p + scale_colour_tableau()
p <- p + theme_few()
p

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









