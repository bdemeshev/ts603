library(fable)
library(feasts) # забыл!
library(tsibble)
library(tidyverse)
library(urca) # unit roots and cointegration analysis

trips = tsibble::tourism
glimpse(trips)
head(trips)

# мими-упражнение:
# извлеките в asa: Adelaide, South Australia, Business
asa = filter(trips, Region == "Adelaide",
             State == "South Australia",
             Purpose == "Business")

# library(forecast) ggseanplot()
# library(fable) gg_

gg_tsdisplay(asa, Trips)
gg_season(asa, Trips)
gg_lag(asa, Trips)
gg_subseries(asa, Trips)
gg_tsdisplay(asa, Trips, plot_type = "partial")
glimpse(asa)
auto = model(asa, m0 = ARIMA(Trips))
auto %>% report()
# df = tsibbledata::PBS
# head(df)

week = tsibbledata::ansett
head(week)
one = filter(week, Airports == "ADL-PER", Class == "Business")
gg_lag(one, Passengers)
gg_tsdisplay(one, Passengers)
gg_subseries(one, Passengers)

# data(package="tsibbledata")

# ARIMA за кадром:
# 1. проводит тест на един корень
# если ед корень есть, то y_t -> d(y_t) = y_t - y_{t-1}
# 2. проводит тест на сезон ед корень
# если сезон ед корень есть, то y_t -> seasd(y_t) = y_t - y_{t-4}
# 3. перебирает пачку моделей с небольшим числом параметров
# выбирает ту, у которой AIC меньше

# 000-101[4]
# (1 - 0.78 L^4) (y_t - 34.38) = (1 - 0.59 L^4) u_t
# если бы (!) был найден ед. корень
# 010-101[4]
# (1 - 0.78 L^4) (d(y_t) - 34.38) = (1 - 0.59 L^4) u_t

# тестов на ед корень много! DF, KPSS, PP...
# DF - просто рассказать, но у него на малой выборке плохи дела
# KPSS - сложнее рассказать, но экспериментально лучше
# ARIMA использует KPSS

# простой пример!
# A. y_t = 0.8 y_{t-1} + u_t <---- есть одно стац. решение
# lambda - 0.8 = 0, lambda = 0.8
# B. y_t = y_{t-1} + u_t <----- нет стац. решений
# lambda - 1 = 0, lambda = 1

# тест Дики-Фуллера
asa$Trips
summary(ur.df(asa$Trips))
# с помощью (обычной) регрессии оценивается модель
# d(y_t) = [что-то] + b2 y_{t-1} + b3 d(y_{t-1}) + u_t
# hat d(y_t) = -0.014 y_{t-1} -0.511 d(y_{t-1})
# а правда ли, что (H0: b2 = 0) ~ (H0: есть единичный корень)
# t = -0.476
# H0 не отвергается
?ARIMA

# DF: DF0 [ничего], DFc [c], DFt [c + b1*t]




