library(tidyverse)
library(rio)
library(fable)
library(lubridate)
library(tsibble)
euro = import("~/Downloads/eu_data_2.xlsx") # наны в германии, потому что данных нет

euro = import("Desktop/Диплом/eu_data.xlsx") # наны в германии, потому что данных нет
warnings() ## как указать наны, чтоб он понял или просто убрать?
glimpse(euro)
tail(euro)
euro <- na.omit(euro)
# все имена с маленькой 
euro1 = rename(euro, date = Date, country = Country, 
              variable = Indicator_ID, value = Indicator)
glimpse(euro1)
# распознаём строку в дату
euro2 = mutate(euro1, date = dmy(date))
glimpse(euro2)
# упрощаем дату до месяца, чтобы дальше tsibble понял, что у нас частота месячная
euro3 = mutate(euro2, date = yearmonth(date))
glimpse(euro3)

# переводим в формат tsibble
# идентификатором ряда является страна и название переменной (key)
# за время отвечает переменная date
eu = as_tsibble(euro3, key = c(country, variable), index = date)
glimpse(eu)
frequency(eu)

scan_gaps(eu) ## выводит что-то непонятное
warnings()

# наивная + ETS безработица без доп переменных
eu1 = filter(eu, variable == c("unemployment_numb", "unemployment_share"))
mtable1 = model(eu1, 
               snaive = SNAIVE(value),
               ets = ETS(value), arima = ARIMA(value))
warnings() # надо разобраться, какие не оценились
head(mtable1, 10)
frequency(eu1)

## Прогноз на 2 года
fcst = forecast(mtable1, h = "2 years")
augment(mtable1)

## Смотрим на Германию, NaNы отрезались, модели зафитились, прогнозы есть
fcst %>% 
  filter(country == "germany", variable == "unemployment_numb") %>%
  autoplot(eu)

## проверка качества модели.Что я делаю не так, если мои гистограмы большой такой разброс показваают
## Он не понимает, как сделать так, чтоб влезли все страны на одной странице
aug = augment(mtable1)
qplot(data = aug, x = .resid)+geom_histogram(binwidth=2,colour="white")+facet_grid(country ~ .model)
### `stat_bin()` using `bins = 30`. Pick better value with `binwidth`. Warning message: Removed 324 rows containing non-finite values (stat_bin). 
aug1 = filter(aug, variable == "unemployment_numb", .resid < 200)
head(aug1)
qplot(data = aug1, x = .resid)+facet_grid(country ~ .model) ## я просто хотела шапочки

accuracy(mtable1)
## хочу увидеть все строки


##fasster не работал, потому что он не скачан был, но он все равно не начал работать
devtools::install_github("tidyverts/fasster")
library(fasster) ## не получается скачать
mtable2 = model(eu1,fasster = FASSTER(value ~ poly(1)))

## Модели с трендом. Не уверена, что сделала правильно

eu_wider = pivot_wider(eu, names_from = variable, values_from = value)
eu_wider
eu_wider2 <- na.omit(eu_wider)
head(eu_wider2) 
eu_wider_tsib = as_tsibble(eu_wider2, key = country, index = date)
glimpse(eu_wider_tsib)
frequency(eu_wider_tsib)
mtable1_tr = model(eu_wider_tsib, arima_ind = ARIMA(unemployment_numb~ lag(indeed)),
                                               arima_link =ARIMA(unemployment_numb~ lag(linkedin)) )

mtable1_tr
## надо научиться красиво выгружать качество


####### конец содержательной части
eu1
mtable
sum(is.na(eu1))#3 nan == 0 

fcst = forecast(mtable, h = "2 years")
augment(mtable)

head(fcst, 10)
## Можно ли написать код, чтоб оно выдавало автоматом все графики
fcst %>% 
  filter(country == "austria", variable == "unemployment_numb") %>%
  autoplot(eu)


eu2 = filter(eu, country == 'Germany', date >= as.Date('2007-01-01'))
mtable1 = model(eu2, 
               snaive = SNAIVE(value),
               ets = ETS(value))
warnings() # надо разобраться, какие не оценились ETS does not support missing values.
head(mtable1, 10)

fcst1 = forecast(mtable1, h = "2 years")
head(fcst, 10)
## Можно ли написать код, чтоб оно выдавало автоматом все графики
fcst1 %>% 
  filter(country == "Germany", variable == "Unemployment_numb") %>%
  autoplot(eu)+ labs(title = "Germany unemployment forecast") +
  xlab("Year")+ ylab ('Unemployment, thousand people')
## все равно остаются пропуски, но теперь я знаю, что она ругается, но строит
## хочу считать качество, а mtable не помогает


## хочу отрезать и на нем проверить качество
eu11 <- filter(eu, date <= as.Date('2018-11-01'))
tail(eu11)

augment(mtable11)

mtable11 = model(eu11, 
                snaive = SNAIVE(unemployment_numb),
                ets = ETS(unemployment_numb))
warnings() # надо разобраться, какие не оценились ETS does not support missing values.
head(mtable11, 10)

fcst1 = forecast(mtable11, h = "2 years")
head(fcst1, 10)

eu11  %>% 
  filter(country == "germany", variable == "unemployment_numb") %>% features(feat_acf)


