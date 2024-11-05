#Caracterizacion del electro iman
library(dplyr)
#Se cargan los datos
data<-read.csv("D:/Documentos/lab-conttmpo/hall/theta_v_1.csv")
data
# Scatter plot of data
data<-data %>%
  rowwise() %>%
  mutate(
    Theta_rad=(pi*Theta)/180
    )
data

plot(data$Theta_rad, data$V, 
     main = "Voltaje Hall contra rotación de la punta Hall. ", 
     xlab = expression(theta), 
     ylab = expression(V[H]), 
     pch = 19,  # Point type
     cex = 0.4,
     col = "darkblue")  # cex controls point size (default is 1)

# Linear fit for V = k * sin(Theta)
modelo <- lm(V ~ sin(Theta_rad), data=data)

# Step 2: Generate a sequence of values for Theta_rad for a smooth curve
theta_values <- seq(min(data$Theta_rad), max(data$Theta_rad), length.out = 100)

# Step 3: Calculate predictions using sin(theta_values)
predicted_values <- predict(modelo, newdata = data.frame(Theta_rad = theta_values))

# Step 4: Add the predicted curve to the plot
lines(theta_values, predicted_values, col = "orange", lwd = 2)
#Uncertaty
# Define the uncertainty as 5% of the V values

y_uncertainty <- 0.05 * data$V  # Calculate 5% of each V value

# Create segments to represent the uncertainty
segments(x0 = data$Theta_rad, 
         y0 = data$V - y_uncertainty, 
         x1 = data$Theta_rad, 
         y1 = data$V + y_uncertainty, 
         col = "black",
         lwd = 1)  # Optional: Specify color for the uncertainty lines
summary(modelo)

