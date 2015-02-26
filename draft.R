library(ggplot2)
options(stringsAsFactors = FALSE)
list.files('./temp_data/')

# Load data
df <- laycUtils::load_txt('./temp_data/raw_enrollment_report.txt')
ptype <- laycUtils::load_txt('./temp_data/program_type.txt')

# Merge data
df <- dplyr::left_join(df, ptype)

# clean data
df$days <- as.numeric(df$days)

# Viz

p <- ggplot(df[df$days > 365, ], aes(x = days, fill = intervention_type))
p <- p + geom_histogram()
p <- p + facet_wrap(~program_name)
p
