#Caracterizacion del electro iman
library(dplyr)
#Se cargan los datos
data<-read.csv("D:/Documentos/lab-conttmpo/hall/electro-iman.csv")
modelo <- lm(I ~ B, data=data)
x_uncertainty <- 0.03*data$I
y_uncertainty <- 0.05*data$B
plot(data$B,
     data$I,
     main="Corriente eléctrica contra campo magnético", 
     xlab="I", 
     ylab="B",
     pch = 19,  # Point type
     cex = 0.4,
     col = "darkblue")  # cex controls point size (default is 1))
abline(modelo, col="orange")
segments(x0 = data$I, y0 = data$B - y_uncertainty, 
         x1 = data$I, y1 = data$B + y_uncertainty,
         col = "black",
         lwd = 1)  # Optional: Specify color for the uncertainty lines)
segments(y0 = data$B, x0 = data$I - x_uncertainty, 
         y1 = data$B, x1 = data$I + x_uncertainty,
         col = "black",
         lwd = 1)  # Optional: Specify color for the uncertainty lines)
summary(modelo)
