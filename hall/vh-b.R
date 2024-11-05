library(dplyr)

# Cargar datos
data2 <- read.csv("D:/Documentos/lab-conttmpo/hall/electro-iman.csv")
data <- read.csv("D:/Documentos/lab-conttmpo/hall/0.04.csv")

# Obtener modelo del electroimán
modelo2 <- lm(B ~ I, data=data2)
predicciones <- predict(modelo2, newdata = data.frame(I = data$I), se.fit = TRUE)


# Calcular campo magnético y su incertidumbre usando el modelo del electroimán
data <- data %>%
  mutate(
    B = predicciones$fit,             # Campo magnético predicho
    B_uncertainty = predicciones$se.fit  # Incertidumbre en B
  )

#Ajuste lineal
modelo <- lm(V ~ B, data=data)

y_uncertainty <- 0.03*data$V
x_uncertainty <- 0.03*data$B+data$B_uncertainty
#Grafica del ajuste lineal
plot(data$B,
     data$V,
     main="Voltaje Hall contra campo magnetico", 
     xlab="B", 
     ylab=expression(V[H]),
     pch = 19,  # Point type
     cex = 0.4,
     col = "darkblue")  # cex controls point size (default is 1))
abline(modelo, col="orange")
segments(x0 = data$B, y0 = data$V - y_uncertainty, 
         x1 = data$B, y1 = data$V + y_uncertainty,
         col = "black",
         lwd = 1)  # Optional: Specify color for the uncertainty lines)
segments(y0 = data$V, x0 = data$B - x_uncertainty, 
         y1 = data$V, x1 = data$B + x_uncertainty,
         col = "black",
         lwd = 1)  # Optional: Specify color for the uncertainty lines)
summary(modelo)
