# есть 6 процессов
library(fable) # ETS, ARIMA
library(tsibble) # формат хранения рядов
library(feasts) # графики + описат статист
library(tidyverse) # манипуляции с табличками
library(lubridate) # даты
library(urca) # ед корни и коинтеграция

n_obs = 1000

set.seed(777)
six = tsibble(day = ymd("2020-01-01") + days(0:(n_obs - 1)),
              u = rnorm(n_obs, mean = 0, sd = 1), index = day)

six
gg_tsdisplay(six, u)

# d
# delta d_t = u_t: d_t - d_{t-1} = u_t
# d_t - нестац с един корнем
# d_0 = 0
six = mutate(six, d = cumsum(u))
# d_1 = u_1
# d_2 = u_1 + u_2 
# d_3 = u_1 + u_2 + u_3
gg_tsdisplay(six, d)

# delta a_t = -0.2 a_{t-1} + u_t
# a_t - a_{t-1} = -0.2 a_{t-1} + u_t
# a_t = 0.8 a_{t-1} + u_t
# AR(1)
six = mutate(six, a = arima.sim(n = n_obs, model = list(ar = 0.8)))

gg_tsdisplay(six, a)

ur.df(pull(six, a), type = "none") %>% summary()
# statistic < crit value => H0: (unit root) is rejected

ur.df(pull(six, d), type = "none") %>% summary()
# statistic > crit value => H0: (unit root) is not rejected
