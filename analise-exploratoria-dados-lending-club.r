# Bibliotecas
library(dplyr)
library(ggmap)
library(ggplot2)
library(gridExtra)
library(maps)
library(mapdata)
library(reshape2)
library(stringr)
library(treemap)

# Conjunto de dados
loan_data <- read.csv("./datasets/loan.csv", sep = ",")

dim(loan_data)

# Distribuição das variáveis de empréstimo
par(mfrow = c(1, 3))

hist(loan_data$loan_amnt,
     main = "Loan Amount Requested by Borrower",
     xlab = "Amount",
     ylab = "Probabilities",
     col = "red",
     prob = TRUE)

lines(density(loan_data$loan_amnt, adjust=2), col="black", lty = "dotted")

hist(loan_data$funded_amnt,
     main = "Amount Funded by Lending Club",
     xlab = "Amount",
     ylab = "Probabilities",
     col = "orange",
     prob = TRUE)

lines(density(loan_data$funded_amnt, adjust=2), col="black", lty = "dotted")

hist(loan_data$funded_amnt_inv,
     main = "Total Committed by Investors",
     xlab = "Amount",
     ylab = "Probabilities",
     col = "blue",
     prob = TRUE)

lines(density(loan_data$funded_amnt_inv, adjust=2), col="black", lty = "dotted")

# Gráficos univariados e análise
loan_data$issue_month <- factor(str_sub(loan_data$issue_d, 1, 3))

loan_data$issue_year <- strtoi(str_sub(loan_data$issue_d, start = -4))

amount_volume <- loan_data %>%
        select(loan_amnt, issue_month, issue_year) %>%
        group_by(issue_year, issue_month) %>%
        arrange(issue_year, issue_month) %>%
        summarise(count = n(), sum_amount = sum(loan_amnt)) %>%
        mutate(date = paste(issue_month, issue_year, sep = "-"))

ggplot(data = amount_volume, aes(x = reorder(date, issue_year), y = sum_amount, group = 1)) + 
        geom_line(color = "red") + 
        scale_x_discrete(breaks = c("Jul-2007", "Jul-2008", "Jul-2009", 
                                    "Jul-2010", "Jul-2011", "Jul-2012", 
                                    "Jul-2013", "Jul-2014", "Jul-2015"),
                         labels = c("2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015")) + 
        labs(title = "Loan Amount", x = "Issue Date", y = "Amount ($)")

ggplot(data = amount_volume, aes(x = reorder(date, issue_year), y = count, group = 1)) + 
        geom_smooth(method = lm, formula = y ~ splines::bs(x, 3), se = FALSE, color = "black", size = 1.2) + 
        geom_line(color = "blue") + 
        scale_x_discrete(breaks = c("Jul-2007", "Jul-2008", "Jul-2009", 
                                    "Jul-2010", "Jul-2011", "Jul-2012", 
                                    "Jul-2013", "Jul-2014", "Jul-2015"),
                         labels = c("2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015")) + 
        labs(title = "Loan Volume", x = "Issue Date", y = "Volume")

gtvy <- loan_data %>% select(issue_year, grade, term)
gtvy <- gtvy[complete.cases(gtvy),]
gtvy <- gtvy[!gtvy$issue_year == 2016,]

graphic_gtvy <- ggplot(gtvy, aes(x = issue_year))
graphic_gtvy + geom_bar(aes(fill = grade)) + 
        facet_grid( ~ term) + 
        labs(title = 'Loan Volume by Year', x = 'Issued Year', y = 'Volume') + 
        theme_bw()

ggplot(data = amount_volume, aes(x = reorder(date, issue_year), y = (sum_amount / count), group = 1)) + 
        geom_smooth(method = lm, formula = y ~ splines::bs(x, 3), se = FALSE, color = "red", linetype = "dashed", size = 1.2) + 
        geom_point(color = "black") + 
        scale_x_discrete(breaks = c("Jul-2007", "Jul-2008", "Jul-2009", 
                                    "Jul-2010", "Jul-2011", "Jul-2012", 
                                    "Jul-2013", "Jul-2014", "Jul-2015"),
                         labels = c("2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015")) + 
        labs(title = "Average Loan", x = "Issue Date", y = "Average Amount ($)")

ggplot(data = loan_data, aes(x = loan_data$grade)) + 
        geom_bar(fill = "black") +
        labs(title = "Loans' Grades", x = "Grade", y = "Frequency")

ggplot(loan_data, aes(x = loan_data$sub_grade)) + 
        geom_bar(fill = "black") +
        labs(title = "Loan's Subgrades", x = "Subgrade", y = "Frequency")

ggplot(data = loan_data, aes(x = loan_status)) + 
        geom_bar(fill = "black") + 
        scale_x_discrete(limits = c("Current", "Fully Paid", "Charged Off",
                                    "Late (31-120 days)", "Issued", "In Grace Period",
                                    "Late (16-30 days)", "Default"),
                         labels = c("Current", "Fully\nPaid", "Charged\nOff",
                                    "Late\n(31-120 days)", "Issued", "In Grace\nPeriod",
                                    "Late\n(16-30 days)", "Default")) + 
        labs(title = "Loan's Status", x = "Status", y = "Count")

ggplot(data = loan_data, aes(x = loan_status)) + 
        geom_bar(aes(y = (..count..) / sum(..count..)), fill = "black") +
        geom_text(aes(y = ((..count..)/sum(..count..)), label = scales::percent((..count..)/sum(..count..))), stat = "count", vjust = -0.25) +
        scale_x_discrete(limits = c("Current", "Fully Paid", "Charged Off",
                                    "Late (31-120 days)", "Issued", "In Grace Period",
                                    "Late (16-30 days)", "Default"),
                         labels = c("Current", "Fully\nPaid", "Charged\nOff",
                                    "Late\n(31-120 days)", "Issued", "In Grace\nPeriod",
                                    "Late\n(16-30 days)", "Default")) + 
        labs(title = "Loan's Status", x = "Status", y = "Percentage") + 
        scale_y_continuous(labels = scales::percent)

summary(loan_data$loan_status)

ggplot(data = loan_data, aes(int_rate)) +
        geom_histogram(fill = "black") + 
        geom_vline(xintercept = median(loan_data$int_rate), color = "red") + 
        geom_vline(xintercept = mean(loan_data$int_rate), color = "yellow") + 
        labs(x = "Interest Rate (%)", y = "Volume")

summary(loan_data$int_rate)

intRateAboveTwenty = sum(loan_data$int_rate >= 20.0)
percentageInTotal = intRateAboveTwenty / sum(loan_data$int_rate >= 0.0)

cat("Loans with the Interest Rate above or equal 20.0%:", intRateAboveTwenty, "\n")

cat("Percentage in total (%):", percentageInTotal * 100, "\n")

ggplot(data = loan_data, aes(loan_amnt)) + 
        geom_histogram(fill = "black") + 
        labs(x = "Loan Amount ($)", y = "Volume") + 
        geom_vline(xintercept = median(loan_data$loan_amnt), color = "red") + 
        geom_vline(xintercept = mean(loan_data$loan_amnt), color = "yellow")

summary(loan_data$loan_amnt)

cat("Median:", median(loan_data$loan_amnt), "\n")
cat("Mean:", mean(loan_data$loan_amnt), "\n")

# Gráficos multivariados e análise
states <- map_data("state")
state_pop <- read.csv("./datasets/census-state-populations.csv")
colnames(state_pop) <- c("addr_state", "population")
state_data <- loan_data %>%
        select(addr_state, loan_amnt) %>%
        group_by(addr_state) %>%
        summarise(count = n(), total = sum(loan_amnt))
state_data$addr_state <- state.name[match(state_data$addr_state, state.abb)]
state_data <- merge(state_data, state_pop, by = "addr_state")
state_data$addr_state <- tolower(state_data$addr_state)
colnames(state_data) <- c("region", "count", "total", "population")
state_data <- inner_join(states, state_data, by = "region")

ditch_the_axes <- theme(
        axis.text = element_blank(),
        axis.line = element_blank(),
        axis.ticks = element_blank(),
        panel.border = element_blank(),
        panel.grid = element_blank(),
        axis.title = element_blank())

ggplot(data = state_data) +
        geom_polygon(aes(x = long, y = lat, fill = total, group = group), 
                     color = "white") +
        coord_fixed(1.3) +
        theme_bw() +
        ditch_the_axes +
        
        scale_fill_distiller("Total Loans ($)", trans = "reverse")

ggplot(data = state_data) +
        geom_polygon(aes(x = long, y = lat, fill = total / population, group = group), 
                     color = "white") +
        coord_fixed(1.3) +
        theme_bw() +
        ditch_the_axes +
        scale_fill_distiller("Total Loans ÷ Population", trans = "reverse")

ggplot(data = loan_data, aes(x = term, y = int_rate)) + 
        geom_boxplot() + 
        labs(x = "Term", y = "Interest Rate (%)")

ggplot(data = loan_data, aes(x = term, y = loan_amnt)) + 
        geom_boxplot() +
        labs(x = "Term", y = "Loan Amount ($)")

values_proportion <- function(data, var1, var2) {
        sum_by <- data %>%
                select_(var1, var2) %>%
                group_by_(var2, var1) %>%
                summarise(count = n())
        
        count_by <- by(sum_by$count, sum_by[[var2]], sum)
        
        count_by<- sapply(count_by, I)
        
        count_by <- data.frame(levels(sum_by[[var2]]), count_by)
        
        colnames(count_by) <- c(var2, "total")
        
        breakdown <- merge(sum_by, count_by, by = var2)
        breakdown$percentage <- breakdown$count / breakdown$total
        
        return(breakdown)
}

grade_term_proportion <- values_proportion(loan_data, "grade", "term")

ggplot(data = grade_term_proportion, aes(x = term, y = percentage)) +
        geom_bar(stat = "identity", aes(fill = grade)) +
        scale_y_continuous(breaks = seq(0, 1, 0.25),
                           labels = c("0%", "25%", "50%", "75%", "100%")) +
        labs(x = "Term", y = "Percentage of Loans") +
        scale_fill_brewer()

term_status_breakdown <- values_proportion(
        subset(loan_data, !(loan_status %in% c("Does not meet the credit policy. Status:Charged Off",
                                               "Does not meet the credit policy. Status:Fully Paid"))),
        "loan_status", "term")

ggplot(data = term_status_breakdown, aes(x = term, y = percentage)) +
        geom_bar(stat = "identity", aes(fill = loan_status)) +
        scale_y_continuous(breaks = seq(0, 1, 0.25),
                           labels = c("0%", "25%", "50%", "75%", "100%")) +
        labs(x = "Term ", y = "Percentage of Loans")

status_grade_breakdown <- values_proportion(subset(loan_data, !(loan_status %in% c("Does not meet the credit policy. Status:Charged Off", "Does not meet the credit policy. Status:Fully Paid"))), "loan_status", "grade")

ggplot(data = status_grade_breakdown, aes(x = grade, y = percentage)) + 
        geom_bar(stat = "identity", aes(fill = loan_status)) +
        scale_y_continuous(breaks = seq(0, 1, 0.25), labels = c("0%", "25%", "50%", "75%", "100%")) + 
        labs(x = "Grade", y = "Percentage of Loans")

purpose_grade_breakdown <- values_proportion(loan_data, "purpose", "grade")

ggplot(data = purpose_grade_breakdown, aes(x = grade, y = percentage)) + 
        geom_bar(stat = "identity", aes(fill = purpose)) + 
        labs(x = "Grade", y = "Percentage of Loans")

purposes <- loan_data %>% select(purpose, loan_amnt) %>% na.omit() %>% group_by(purpose) %>% 
        dplyr::summarise(volume = n(), average_amnt = sum(as.numeric(loan_amnt), rm.na = TRUE)/ n())

purposes <- purposes[!purposes$purpose == '',]
treemap(purposes, 
        index = 'purpose', 
        vSize = 'volume', 
        vColor = 'average_amnt',
        range = c(6000, 16000), 
        type = 'manual', 
        palette = c('yellow', 'green', 'orange', 'orange2', 'firebrick'), 
        algorithm = 'pivotSize', 
        sortID = '-size', 
        title = 'Purposes of Loans', 
        title.legend = 'Average Amount', 
        fontsize.labels = 12, 
        fontsize.legend = 10, 
        fontface.labels = 1, 
        position.legend = 'bottom', 
        force.print.labels = T, 
        border.col = 'white')

tig <- select(loan_data, int_rate, sub_grade, grade, term, issue_year)

graphic_tig <- ggplot(tig, aes(grade, int_rate)) 
graphic_tig + 
        geom_boxplot(outlier.size = 0.5, color = 'black') +
        facet_grid(term ~ issue_year) + 
        labs(title = 'Interest Rate Distribution by Grade', x = 'Grade', y = 'Interest Rate (%)') + 
        theme_bw()

tisub <- mutate(tig, term = ifelse(term == ' 36 months', '36', '60'))

tisub_abcd <- filter(tisub, grade %in% c('A', 'B', 'C', 'D'))
tisub_efg <- filter(tisub, grade %in% c('E', 'F', 'G'))

graphic_tisub_abcd <- ggplot(tisub_abcd, aes(term, int_rate))

graphic_tisub_abcd + 
        geom_boxplot(outlier.size = 0.5, aes(color = term)) + 
        guides(color = F) + 
        facet_wrap(~ sub_grade, nrow = 1) + 
        labs(title = 'Interest Rate Distribution by Term of Grades A, B, C and D', x = 'Term', y = 'Interest Rate (%)') + 
        theme_bw()

graphic_tisub_efg <- ggplot(tisub_efg, aes(term, int_rate))

graphic_tisub_efg + 
        geom_boxplot(outlier.size = 0.5, aes(color = term)) + 
        guides(color = F) + 
        facet_wrap(~ sub_grade, nrow = 1) + 
        labs(title = 'Interest Rate Distribution by Term of Grades E, F and G', x = 'Term', y = 'Interest Rate (%)') + 
        theme_bw()

loan_status_count <- loan_data %>%
        select(loan_status) %>%
        group_by(loan_status) %>%
        summarise(count = n()) %>%
        mutate(percentage = count / sum(count))

ggplot(data = loan_status_count, aes(x = loan_status, y = count)) + 
        geom_bar(stat="identity", aes(fill = loan_status)) + 
        scale_x_discrete(limits = c("Current", "Fully Paid", "Charged Off",
                                    "Late (31-120 days)", "Issued", "In Grace Period",
                                    "Late (16-30 days)", "Default"),
                         labels = c("Current", "Fully\nPaid", "Charged\nOff",
                                    "Late\n(31-120 days)", "Issued", "In Grace\nPeriod",
                                    "Late\n(16-30 days)", "Default")) + 
        scale_y_continuous(breaks = seq(0, 600000, 100000),
                           labels = c("0", "100000", "200000", "300000", "400000", "500000", "600000")) + 
        labs(title = "Loan's Status", x = "Status", y = "Number of Loans") + 
        guides(fill = FALSE) + 
        geom_text(aes(label = scales::percent(percentage), y = percentage ), stat= "identity", vjust = -0.75)

ggplot(data = loan_data, aes(x = term, y = int_rate)) + 
        geom_boxplot() + 
        labs(title = "Term's Interest Rate", x = "Term", y = "Interest Rate (%)")

purposes <- loan_data %>% select(purpose, loan_amnt) %>% na.omit() %>% group_by(purpose) %>% 
        dplyr::summarise(volume = n(), average_amnt = sum(as.numeric(loan_amnt), rm.na = TRUE)/ n())

purposes <- purposes[!purposes$purpose == '',]
treemap(purposes, 
        index = 'purpose', 
        vSize = 'volume', 
        vColor = 'average_amnt',
        range = c(6000, 16000), 
        type = 'manual', 
        palette = c('yellow', 'green', 'orange', 'orange2', 'firebrick'), 
        algorithm = 'pivotSize', 
        sortID = '-size', 
        title = 'Purposes of Loans', 
        title.legend = 'Average Amount', 
        fontsize.labels = 12, 
        fontsize.legend = 10, 
        fontface.labels = 1, 
        position.legend = 'bottom', 
        force.print.labels = T, 
        border.col = 'white')