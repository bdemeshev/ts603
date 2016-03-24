
x <- arima.sim(n = 200,
        model = list(ar = 0.6))
y <- arima.sim(n = 200,
        model = list(ma = c(0.7, 0.2)))
library("forecast")
tsdisplay(x)
tsdisplay(y)


model <- lm(y ~ x)
summary(model)

x2 <- cumsum(x)
y2 <- cumsum(y)

tsdisplay(x2)
tsdisplay(y2)

model <- lm(y2 ~ x2)
summary(model)

library(tseries)
adf.test(y2)

