# Lecture 1 plus 2. ETS models

ETS =  Error, Trend, Seasonality


* How to skip current lecture?
 
[Foreasting principles and practice](https://otexts.com/fpp3/ets.html)

[ETC3550 Slides on ETS](https://github.com/robjhyndman/ETC3550Slides/raw/fable/8-ets.pdf)

### Stationarity, White-Noise 

* def. **Stochastic (Random) process** — just the sequence of random variables, $(y_t)$!

$y_1$, $y_2$, $y_3$, $y_4$, ...

* def. **White noise process**, $(u_t)$

$E(u_t) = 0$ — zero expected value

$Var(u_t) = \sigma^2_u$ — constant variance

$Cov(u_t, u_s) = 0$ for $t\neq s$

* Process $(y_t)$ is **weakly statinary** if 

$E(y_t) = \mu_y$ — constant expected value

$Var(y_t) = \sigma^2_y$ — constant variance

$Cov(y_t, y_s) = \gamma_{t-s}$ — covaraince depends only on difference of $t$ and $s$

Ie that means: $Cov(y_1, y_2) = Cov(y_3, y_4)$.

Q. $Cov(y_1, y_{10})$, $Cov(y_{10}, y_{19})$, $Cov(y_3, y_{10})$ which are equal?

A. $Cov(y_1, y_{10}) = Cov(y_{10}, y_{19})$

Theorem. White noise is a stationary process :)

Proof. Just check the definition.

* def. **Random walk**, $(y_t)$:

$y_0$ — constant

$y_t = y_{t-1} + u_t$, where $(u_t)$ — is a white noise process.

Q. Let $(y_t)$ be a random walk

$$
\begin{cases}
y_0 = 0 \\
y_t = y_{t-1} + u_t
\end{cases},
$$

$(u_t)$ is a white noise process with variance $\sigma^2_u$.

Find $E(y_t)$, $Var(y_t)$?

Is $(y_t)$ weakly stationary?


A. $y_1 = y_0 + u_1 = u_1$

$y_2 = y_1 + u_2 = u_1 + u_2$

$y_3 = y_2 + u_3 = u_1 + u_2 + u_3$

...

$y_t = u_1 + u_2 + \ldots + u_t = \sum_{i=1}^t u_i$

$E(y_t) = E(u_1) + E(u_2) + \ldots + E(u_t) = 0 + 0 + \ldots + 0$

$Var(y_1) = Var(u_1) = \sigma^2_u$

$Var(y_2) = Var(u_1 + u_2) = \sigma^2_u + \sigma^2_u  = 2\sigma^2_u$



$Var(y_t) = Var(u_1 + u_2 + \ldots + u_t) = Var(u_1) + Var(u_t) + \ldots + Var(u_t) = t\cdot \sigma^2_u$.

Random walk is not stationary!


### ETS(AAA) model without random noise

$(y_t)$ — quarterly time series

trend + seasonal effects

$y_t$ — observed time series

$\ell_t$ — time series cleared from seasonal effects

$b_t$ — current growth rate of $\ell_t$

$s_t$ — current seasonal effect

Let's write equations!
Current values depend on past values!

ETS(AAA) without noise:
$$
\begin{cases}
b_t = b_{t-1} \\
s_t = s_{t-4} \\
\ell_t = \ell_{t-1} + b_{t-1} \\
y_t = \ell_{t-1} + b_{t-1} + s_{t-4} \\
s_0 + s_{-1} + s_{-2} + s_{-3} = 0 \\
\end{cases}
$$

Initial values:
$b_0 = 2$, $\ell_0 = 100$, 

$s_0 = 3$, $s_{-1} = 2$, $s_{-2} = -4$, $s_{-3} = -1$.

Initial values are estimated by maximum likelihood on computer. 

* notation: $\Delta \ell_t = \ell_t - \ell_{t-1}$

Q. $y_{101}$? $y_{102}$?

A.
$b_{1} = b_2 = \ldots = 2$

$s_{101} = \ldots = s_{-3} = -1$

$\ell_{100} = \ell_0 + b_0 + b_1 + \ldots + b_{99} = 100 + 2\times 100 = 300$.

$\ell_1 = \ell_0 + b_0 = 100 + 2 = 102$

$\ell_2 = \ell_1 + b_1 = 102 + 2 = 104$

$\ell_3 = \ell_2 + b_2 = 104 + 2 = 106 = 100 + 3\times 2$

$y_{101} = \ell_{100}  + b_{100} + s_{97} =300 + 2 + (-1) = 301$

We need equation $s_0 + s_{-1} + s_{-2} + s_{-3} = 0$ to interpret $\ell_t$ as version of $y_t$ cleared from seasonal effects. 

Q. ETS(AAA) without noise.

How many parameters do we need to estimate for quarterly data?

A. 5 parameters: $b_0$, $\ell_0$, $s_0$, $s_{-1}$ and $s_{-2}$.

Q. ETS(AAA) without noise.

How many parameters do we need to estimate for monthly data?

### ETS(AAA) model with random noise

Random noise: $(u_t)$

ETS(AAA) with noise:
$$
\begin{cases}
u_t \sim N(0;\sigma^2_u), \text{ independent} \\
b_t = b_{t-1} + \beta u_t\\
s_t = s_{t-4} + \gamma u_t \\
\ell_t = \ell_{t-1} + b_{t-1} + \alpha u_t \\
y_t = \ell_{t-1} + b_{t-1} + s_{t-4} + u_t \\
s_0 + s_{-1} + s_{-2} + s_{-3} = 0 \\
\end{cases}
$$

Q. ETS(AAA) with noise.

How many parameters do we need to estimate for quarterly data?

A. 5 + alpha + beta + gamma + sigma = 9 parameters


#### Miracle

Observed values: $y_1$, $y_2$, ..., $y_{100}$.

Maximum Likelihood magick :)

Imagine that 9 parameters are already estimated:

$\hat\alpha$, $\hat\beta$, $\hat\gamma$, $\hat \ell_0$, ...

#### How to make seasonal decomposition using estimated ETS model?

For simplicity I will omit «hat» above estimated parameters. I will think of true values of parameters. 

Observed values: $y_1 = 101$, $y_2 = 104$, $y_3 = 106$, ...

True parameters: $b_0 = 2$, $\ell_0 = 100$, $s_0 = 1$, $s_{-1} = 2$, $s_{-2} = -2$, $\alpha = 0.5$, $\beta = 0.5$, $\gamma = 0.5$, $\sigma = 2$. 

Q. Decompose $y_1$, $y_2$, $y_3$ into error, trend and seasonal effect. 

Find $\ell_1$, $\ell_2$, $\ell_3$, 
$s_1$, $s_2$, $s_3$, $b_1$, $b_2$, $b_3$,
$u_1$, $u_2$, $u_t$.

$$
\begin{cases}
u_t \sim N(0;\sigma^2_u), \text{ independent} \\
b_t = b_{t-1} + \beta u_t\\
s_t = s_{t-4} + \gamma u_t \\
\ell_t = \ell_{t-1} + b_{t-1} + \alpha u_t \\
y_t = \ell_{t-1} + b_{t-1} + s_{t-4} + u_t \\
s_0 + s_{-1} + s_{-2} + s_{-3} = 0 \\
\end{cases}
$$

Sequence: 

Step 1. Search for $u_1$, $b_1$, $s_1$, $\ell_1$

Look at the equation for $y_t$:

$y_1 = \ell_0 + b_0 + s_{-3} + u_1$

From $101 = 100 + 2 + (-1) + u_1$ we  have $u_1 = 0$.

Look at the equation for $b_1$:

$b_1 = b_0 + \beta u_1 = 2 + 0.5 \times 0 = 2$

Look at the equation for $s_1$:

$s_1 = s_{-3} + \gamma u_1 = -1 + 0.5 \times 0 = -1$.

Look at the equation for $\ell_1$:

$\ell_1 =\ell_0 + b_0 + \alpha u_1 = ... = 102$.


Step 2. Search for $u_2$, $b_2$, $s_2$, $\ell_2$ 

$u_2 = 2$, $b_2 = 3$, $s_2 = -1$, $\ell_2 = 105$

Step 3. $u_3$, $b_3$, $s_3$, $\ell_3$



#### How to make predictions using estimated ETS model?

True parameters: $b_0 = 2$, $\ell_0 = 100$, $s_0 = 1$, $s_{-1} = 2$, $s_{-2} = -2$, $\alpha = 0.5$, $\beta = 0.5$, $\gamma = 0.5$, $\sigma = 2$. 

We have done seasonal decomposition up to $y_{100}$. 

The last step gave me:

$b_{100} = 3$, $\ell_{100} = 400$, $s_{100} = 2$, $s_{99} = 1$, $s_{98} = -3$, 
$s_{97}= -2$. 

Q. Find point forecast for $y_{101}$. Find 95% predictive interval for $y_{101}$.

$y_{101} = \ell_{100} + b_{100} + s_{97} + u_{101} = 400 + 3 + (-2) + u_{101}$

Given my information:
$y_{101} = 401 + u_{101}$.

$\mathcal{F}_{100}$ — all available information up to time $100$. 

Conditional expected value:
$E(y_{101}\mid \mathcal{F}_{100})=E_{100}(y_{101}) = 401 + 0$

Future noise $u_{101}$ is independed of my information $\mathcal{F}_{100}$.

$E(u_{101}\mid \mathcal{F}_{100}) =E(u_{101}) = 0$

Point prediction: $E(u_{101}\mid \mathcal{F}_{100}) = E_{100}(u_{101}) = \hat y_{101\mid 100} = 401$.

Let's do **two steps** ahead point prediction:

$y_{102} = \ell_{101} + b_{101} + s_{98} + u_{102} = (\ell_{100} + b_{100} + \alpha u_{101}) + (b_{100} + \beta u_{101}) + s_{98}+ u_{102}$

$y_{102} = (400 + 3 + 0.5u_{101}) + (3 + 0.5 u_{101}) + (-3) + u_{102} = 403 + u_{101} + u_{102}$

Point forecast:

$\hat y_{102\mid 100} = E(y_{102} \mid \mathcal{F}_{100}) = 403$

Let's $u_{101}$ is not zero!

We have decomposed $y_{101}$ into two parts: predictable ($\ell_{100} + b_{100} + s_{97}$) and not predictable $u_{101}$.

My best prediction for $u_{101}$ is zero: $E(u_{101}\mid \mathcal F_{100}) = 0$. 

Interval forecasts!

Let's calculate conditional variance!

$Var(y_{101} \mid \mathcal F_{100}) = Var(401 + u_{101} \mid \mathcal F_{100})  = Var(u_{101} \mid \mathcal F_{100}) = Var(u_{101}) = 2^2 = 4$

Summary:

$(y_{101} \mid \mathcal F_{100}) \sim N(401; 4)$

95% predictive interval (critical value is 1.96)

$[401 - 1.96 \sqrt{4}; 401 + 1.96 \sqrt{4}]$

Normal Elephant is in $[E(Elephant) - 1.96\sqrt{Var(Elephant)};E(Elephant) + 1.96\sqrt{Var(Elephant)} ]$ with probability 0.95;


Let's move on to two steps ahead forecasts:
$y_{102} = 403 + u_{101} + u_{102}$

$E(y_{102} \mid \mathcal{F}_{100})=403$;

$Var(y_{102} \mid \mathcal{F}_{100})=Var(403 + u_{101}+ u_{102} \mid \mathcal{F}_{100}) = Var(u_{101}+ u_{102} ) = 4 + 4 =8$

Summary:

$(y_{102} \mid \mathcal F_{100}) \sim N(403; 8)$

95% predictive interval (critical value is 1.96)

$[403 - 1.96 \sqrt{8}; 403 + 1.96 \sqrt{8}]$



#### Write likelihood functions

#### Versions of ETS model

ETS(AAA)

Additive Error 

Additive Trend 

Additive Seasonal 

We can switch off some components

ETS(ANA)

Additive Error 

No Trend: $b_t=0$

Additive Seasonal

ETS(ANN)

Additive Error 

No Trend: $b_t=0$

No Seasonal: $s_t = 0$


We can consider Multiplicative components:

ETS(AAA)
$y_t = \ell_{t-1} + b_{t-1} + s_{t-4} + u_t$

ETS(MMM)
$y_t = \ell_{t-1} \cdot b_{t-1} \cdot s_{t-4} \cdot (1 + u_t)$

ETS(MAM)
$y_t = (\ell_{t-1} + b_{t-1}) \cdot s_{t-4} \cdot (1 + u_t)$

ETS(NNN): We never use it :)
$\ell_t = \ell_{t-1}$
$y_t = \ell_{t-1}$


### Train-test split

$y_1$, $y_2$, ..., $y_{100}$

Training sample: $y_1$, ..., $y_{80}$

Test sample $y_{81}$, ..., $y_{100}$.

Estimate my models (ETS(AAA), ETS(MAM)) using training sample.

Do predictions for test sample.

### Metrics

You can compare models using:

Mean absolute error

$$MAE = \frac{1}{20}\sum_{t=81}^{100} |y_t - \hat y_t|$$

Mean squared error:

$$MSE = \frac{1}{20}\sum_{t=81}^{100} (y_t - \hat y_t)^2$$


Mean absolute percentage error

$$MAPE = \frac{1}{20}\sum_{t=81}^{100} |y_t - \hat y_t|/|y_t|$$

Symmetric mean absolute percentage error

$$SMAPE = \frac{1}{20}\sum_{t=81}^{100} |y_t - \hat y_t|/s_t$$

where $s_t = 0.5|y_t| + 0.5|\hat y_t|$.





### Cross-validation


















