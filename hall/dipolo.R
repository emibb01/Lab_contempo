library(dplyr)

# Se cargan los datos
data <- read.csv("D:/Documentos/lab-conttmpo/hall/distancia.csv")

# Creamos una nueva variable para la transformación 1/d^3
data <- data %>%
  mutate(inverse_d3 = 1 / (d^3))

# Ajustamos el modelo lineal: i en función de 1/d^2
modelo <- lm(v ~ inverse_d3, data = data)

# Generamos predicciones y tomamos las incertidumbres
predicciones <- predict(modelo, newdata = data.frame(inverse_d3 = data$inverse_d3), se.fit = TRUE)

# Agregamos las predicciones e incertidumbres al data frame
data <- data %>%
  mutate(
    v_pred = predicciones$fit,          # Valores predichos de v
    v_uncertainty = predicciones$se.fit  # Incertidumbre en v
  )

# Incertidumbre en d
delta_d <- 0.005

# Calculo de la incertidumbre en 1/d^3
data <- data %>%
  mutate(
    inverse_d3_uncertainty = 3 * delta_d / (data$d^4)
  )

# Calculamos incertidumbres en x e y
y_uncertainty <- 0.03 * data$v + data$v_uncertainty+data$inverse_d3_uncertainty
x_uncertainty <- 0.005


# Visualizamos el gráfico
plot(data$d,
     data$v,
     main="Voltaje Hall contra distancia",
     xlab="d", 
     ylab=expression(V[H]),
     pch = 19,  # Tipo de punto
     cex = 0.4,
     col = "darkblue")



# Añadimos la curva ajustada al gráfico
# Generamos valores de predicción para un rango de valores de d
d_vals <- seq(min(data$d), max(data$d), length.out = 100)
inverse_d3_vals <- 1 / (d_vals^3)
v_pred <- predict(modelo, newdata = data.frame(inverse_d3 = inverse_d3_vals))

# Graficamos la curva predicha
lines(d_vals, v_pred, col = "orange", lwd = 2)

#Agregamos las lineas de incertidumbre 
segments(x0 = data$d, y0 = data$v - y_uncertainty, 
         x1 = data$d, y1 = data$v + y_uncertainty,
         col = "black",
         lwd = 1)  # Optional: Specify color for the uncertainty lines)
segments(y0 = data$v, x0 = data$i - x_uncertainty, 
         y1 = data$v, x1 = data$i + x_uncertainty,
         col = "black",
         lwd = 1)  # Optional: Specify color for the uncertainty lines)

