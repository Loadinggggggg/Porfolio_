# Load necessary packages
library(readr)
library(ggplot2)
library(dplyr)
library(tidyr)

# Load the dataset
hotel_data <- read_csv("/Users/liliamarzougui/Desktop/R/bookings.csv")
names(hotel_data)

# Basic Insights
cat("Average lead time for hotel bookings: ", mean(hotel_data$lead_time), "\n")
cat("Most popular month for hotel bookings: ", names(which.max(table(hotel_data$arrival_date_month))), "\n")
cat("Number of canceled bookings: ", sum(hotel_data$is_canceled), "\n")
cat("Percentage of bookings made by repeated guests: ", round(mean(hotel_data$is_repeated_guest) * 100, 2), "%", "\n\n")


# 1. Distribution of Adults, Children, and Babies
df_adults_children_babies <- hotel_data %>%
  select(adults, children, babies) %>%
  gather(key = "category", value = "count", adults: babies)

ggplot(df_adults_children_babies, aes(x = category, y = count, fill = category)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(x = "Category", y = "Count", fill = "Category") +
  ggtitle("Distribution of Adults, Children, and Babies") +
  theme_classic()

# 2. Number of Bookings by Meal Type
bookings_by_meal <- hotel_data %>%
  count(meal, name = "count")

ggplot(bookings_by_meal, aes(x = meal, y = count)) +
  geom_bar(stat = "identity", fill = "lightblue") +
  labs(x = "Meal Type", y = "Number of Bookings", title = "Bookings by Meal Type") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# 3. Number of Bookings by Distribution Channel
bookings_by_channel <- hotel_data %>%
  count(distribution_channel, name = "count")

ggplot(bookings_by_channel, aes(x = distribution_channel, y = count)) +
  geom_bar(stat = "identity", fill = "lightblue") +
  labs(x = "Distribution Channel", y = "Number of Bookings", title = "Bookings by Distribution Channel") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# 4. Number of Bookings by Repeated Guest Status
bookings_by_repeated_guest <- hotel_data %>%
  count(is_repeated_guest, name = "count")

ggplot(bookings_by_repeated_guest, aes(x = factor(is_repeated_guest), y = count)) +
  geom_bar(stat = "identity", fill = "lightblue") +
  labs(x = "Repeated Guest Status", y = "Number of Bookings", title = "Bookings by Repeated Guest Status") +
  theme_classic() +
  scale_x_discrete(labels = c("New Guest", "Repeated Guest"))

# 5. Number of Bookings by Deposit Type
bookings_by_deposit <- hotel_data %>%
  count(deposit_type, name = "count")

ggplot(bookings_by_deposit, aes(x = deposit_type, y = count)) +
  geom_bar(stat = "identity", fill = "lightblue") +
  labs(x = "Deposit Type", y = "Number of Bookings", title = "Bookings by Deposit Type") +
  theme_classic()

# Analyze seasonality of bookings and cancellation rate by month
booking_cancellation_data <- hotel_data %>%
  mutate(arrival_date_month = factor(arrival_date_month, levels = month.name)) %>%
  group_by(arrival_date_month) %>%
  summarise(total_bookings = n(), cancellation_rate = mean(is_canceled))

# Create the plot
ggplot(booking_cancellation_data, aes(x = arrival_date_month)) +
  geom_bar(aes(y = total_bookings), stat = "identity", fill = "lightblue") +
  labs(x = "Month", y = "Total Bookings", title = "Seasonality of Hotel Bookings") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  geom_line(aes(y = cancellation_rate * max(total_bookings), group = 1),
            color = "red", linetype = "dashed") +
  geom_text(aes(y = total_bookings, label = sprintf("%.2f%%", cancellation_rate * 100)),
            vjust = -0.5, color = "black", size = 3) +
  scale_y_continuous(
    sec.axis = sec_axis(~ . / max(booking_cancellation_data$total_bookings) * 100,
                        name = "Cancellation Rate",
                        labels = scales::percent_format(accuracy = 1))
  )

# 6. Average Daily Rate (ADR) by Customer Type and Deposit Type
adr_by_customer_deposit <- hotel_data %>%
  group_by(customer_type, deposit_type) %>%
  summarise(avg_adr = mean(adr))

ggplot(adr_by_customer_deposit, aes(x = customer_type, y = avg_adr, fill = deposit_type)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(x = "Customer Type", y = "Average Daily Rate (ADR)", fill = "Deposit Type",
       title = "Average Daily Rate (ADR) by Customer Type and Deposit Type") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# 7. Distribution of Booking Changes
ggplot(hotel_data, aes(x = booking_changes)) +
  geom_histogram(bins = 30, color = "black", fill = "lightblue") +
  labs(x = "Booking Changes", y = "Count", title = "Distribution of Booking Changes") +
  theme_classic()

# 8. Cancellation Rate by Market Segment
cancellation_by_market_segment <- hotel_data %>%
  group_by(market_segment) %>%
  summarise(cancellation_rate = mean(is_canceled))

ggplot(cancellation_by_market_segment, aes(x = market_segment, y = cancellation_rate)) +
  geom_bar(stat = "identity", fill = "lightblue") +
  labs(x = "Market Segment", y = "Cancellation Rate", title = "Cancellation Rate by Market Segment") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1))

# 9. Correlation Heatmap for Numerical Variables
numerical_vars <- hotel_data %>%
  select_if(is.numeric)

correlation_matrix <- cor(numerical_vars)
ggplot(as.data.frame(as.table(correlation_matrix)), aes(Var1, Var2, fill = Freq)) +
  geom_tile() +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# 10. Booking Cancellation by Country
cancellation_by_country <- hotel_data %>%
  group_by(country) %>%
  summarise(cancellation_rate = mean(is_canceled))

