library(ggplot2)
library(ggthemes)
library(laycUtils)
options(stringsAsFactors = FALSE, digits = 2)
list.files('./temp_data/')
library(dplyr)
library(stringr)
library(extrafont)

# Set constants
end_date <- lubridate::mdy('9/30/2014')
start_date <- lubridate::mdy('1/1/2008')

# Load data
df <- laycUtils::load_txt('../temp_data/fy14/raw_enrollment_report.txt')
ptype <- laycUtils::load_txt('../temp_data/fy14/program_type.txt')
ptype <- select(ptype, program_id, intervention_type)
#dosage <- laycUtils::load_txt('../temp_data/fy14/raw_pos_report.txt')

# Merge data
df <- dplyr::left_join(df, ptype, by = c('program_id'))

# clean data
#headers <- names(df)
#headers[1] <- 'id'
#names(df) <- headers


p <- ggplot(df, aes(x = days)) + geom_histogram() + facet_wrap(~intervention_type)
p <- p + theme_layc()
p <- p + ggtitle('qwertyuiopasdfghjklzxcvbnm\n')
p <- p + theme(plot.title = element_text(size = rel(5), face = 'bold'))
p


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
p <- p + geom_bar(aes(y = av_days, fill = intervention_type), stat = 'identity')
# p <- p + geom_point(aes(y = av_days, color = intervention_type), size = 4)
# p <- p + geom_errorbar(aes(ymin = av_days - std_days, ymax = av_days + std_days, color = intervention_type),
#                        width = .1)
p <- p + scale_fill_tableau()
p <- p + theme_layc()
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









