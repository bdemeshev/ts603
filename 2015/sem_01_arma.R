
# y_t = 7 + e_t + 1*e_{t_1} + 2*e_{t-2}
# теоретическая ACF
ARMAacf(ma = c(1, 2), lag.max = 10)
# теоретическая PACF
ARMAacf(ma = c(1, 2), lag.max = 10, pacf = TRUE)

# для работы с временными рядами:
library("xts")
library("forecast")

# для загрузки данных
library("quantmod")
library("sophisthse")

# для установки sophisthse нужно:
# 1. установить (стандратно) пакет devtools
# 2. выполнить команду
# devtools::install_github("bdemeshev/sophisthse")

# сгенерируем искусственно
# y_t = 6 + e_t + 1*e_{t-1} + 2*e_{t-2}
y <- arima.sim(n = 1000,
               list(ma = c(1, 2))) + 6
y
# графики для ряда
Acf(y)
Pacf(y)
tsdisplay(y)

# оценим ряд:
# попытаемся оценить MA(2)=ARIMA(0,0,2)
ma2 <- Arima(y, order = c(0, 0, 2))
summary(ma2)

# попытаемся оценить AR(3)=ARIMA(3,0,0)
ar3 <- Arima(y, order = c(3, 0, 0))
summary(ar3)

# попытаемся оценить ARMA(1,1)=ARIMA(1,0,1)
arma11 <- Arima(y, order = c(1, 0, 1))
summary(arma11)

# прогноз на 5 шагов вперед
forecast(ma2, h = 5)

# график прогноза
future <- forecast(ma2, h = 50)
plot(future)

# отбор моделей
# штрафной критерий AIC
AIC(ma2)
AIC(ar3)
AIC(arma11)
# по AIC ma2 лучше

# автоподбор модели по AIC
auto_model <- auto.arima(y)
summary(auto_model)

# макропоказатель
# прозводство товаров и услуг
# sophist.hse.ru
pti <- sophisthse("BBR_EA_M_I")
y <- pti[ ,1]
head(y, 24)
tsdisplay(y)

# автоподбор модели по AIC
auto_model <- auto.arima(y)
summary(auto_model)


future <- forecast(auto_model, h = 12)
future
plot(future)

# дз:
y <- LakeHuron
y
# визуально модель AR? MA?
# сравните несколько конкурирующих моделей
# выпишите оценённые уравнения
# выберите наилучшую по AIC
# сделайте авто подбор модели
# спрогнозируете уровень воды в озере на 5 лет вперед



