x <- arima.sim(n = 200,
        model = list(ar = 0.6))
y <- arima.sim(n = 200,
        model = list(ma = c(0.7, 0.2)))
library("forecast")
tsdisplay(x)
tsdisplay(y)

model <- lm(y~x)
summary(model)
