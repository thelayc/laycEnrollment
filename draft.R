library(ggplot2)
options(stringsAsFactors = FALSE)
list.files('./temp_data/')
library(dplyr)

# Load data
df <- laycUtils::load_txt('./temp_data/raw_enrollment_report.txt')
ptype <- laycUtils::load_txt('./temp_data/program_type.txt')

# Merge data
df <- dplyr::left_join(df, ptype)

# clean data
headers <- names(df)
headers[1] <- 'id'
names(df) <- headers
df$days <- as.numeric(df$days)

# Viz

p <- ggplot(df[df$days > 600, ], aes(x = days, fill = intervention_type))
p <- p + geom_histogram()
p <- p + facet_wrap(~program_name)
p

# Summarise
df %>%
  group_by(factor(intervention_type)) %>%
  summarise(enrolled = count(id2))

# Test
df %>%
  filter(intervention_type == 'education') %>%
  select(id, start:dismissal_reason) %>%
  summarise()
  
length(unique(test$id)) 
  
  
  
  
  
  
  
  
  






  