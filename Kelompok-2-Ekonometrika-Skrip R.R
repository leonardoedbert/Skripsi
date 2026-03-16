#install.packages("tseries")
#install.packages("readr")
#install.packages("ARDL")

# Import Library
library(tseries)
library(readr)
library(dynlm)
library(car)
library(fBasics)
library(ARDL)
library(lmtest)

# Load data
setwd("C:\\Users\\Leonardo\\Documents\\Kuliah\\Ekonometrika\\Kelompok-2-Tugas (untuk cv)")
getwd()
ls()
rm(list=ls(all=TRUE))
data <- read.csv("data_gabungan.csv")  # ganti sesuai nama file kamu
summary(data)

### Plot Deret Waktu dan Statistika Deskriptif
# Ubah ke time series (quarterly, freq = 4)
ts_pce <- ts(data$PCECC96, start = c(1959, 1), frequency = 4)
ts_inc <- ts(data$A229RX0, start = c(1959, 1), frequency = 4)
ts_gdp <- ts(data$GDPC1, start = c(1959, 1), frequency = 4)
ts_cpi <- ts(data$CPIAUCSL, start = c(1959, 1), frequency =4)

sum(is.na(ts_cpi))
# Hitung rata-rata tanpa NA
mean_cpi <- mean(ts_cpi, na.rm = TRUE)
# Ganti NA dengan rata-rata
ts_cpi[is.na(ts_cpi)] <- mean_cpi

# Plot time series
# Membagi area plot menjadi 2 baris dan 2 kolom
par(mfrow = c(2, 2))

# Plot PCE
plot(ts_pce,
     main = "Personal Consumption Expenditures (PCE)",
     ylab = "PCE (dalam miliar USD)",
     xlab = "Tahun")
# Plot Income
plot(ts_inc,
     main = "Disposable Personal Income (DPI)",
     ylab = "DPI (dalam miliar USD)",
     xlab = "Tahun")
# Plot GDP
plot(ts_gdp,
     main = "Gross Domestic Product (GDP)",
     ylab = "GDP (dalam miliar USD)",
     xlab = "Tahun")
# Plot CPI
plot(ts_cpi,
     main = "Consumer Price Index (CPI)",
     ylab = "Index",
     xlab = "Tahun")

# Mengembalikan ke default (opsional tapi disarankan)
par(mfrow = c(1,1))

# Statistika Deskriptif
basicStats(data$PCECC96)
basicStats(data$A229RX0)
basicStats(data$GDPC1)
basicStats(data$CPIAUCSL)

##=============================================================================
##=============================================================================

### Uji Stasioneritas
# Uji ADF pada data tanpa Differencing
adf.test(ts_pce)
adf.test(ts_inc)
adf.test(ts_gdp)
adf.test(ts_cpi)

# Proses Differencing
diff_pce <- diff(ts_pce)
diff_inc <- diff(ts_inc)
diff_gdp <- diff(ts_gdp)
diff_cpi <- diff(ts_cpi)

# Uji ADF pada data yang sudah di-Differencing
adf.test(diff_pce)
adf.test(diff_inc)
adf.test(diff_gdp)
adf.test(diff_cpi)
adf.test(diff(log(ts_cpi)), k = 1)
adf.test(diff(log(ts_cpi)), k = 2)

##=============================================================================
##=============================================================================

### Pemilihan Lag Optimum
library(dynlm)
library(tidyverse)

min_aic <- Inf
best_model <- NULL
best_order <- c()

# Menggunakan Grid search untuk menentukan Lag Optimum: p = lag Y, q1 = lag X1, q2 = lag X2
for (p in 1:3) {
  for (q1 in 0:3) {
    for (q2 in 0:3) {
      for (q3 in 0:3) {
        
        formula <- as.formula(
          paste("ts_pce ~",
                paste0("L(ts_pce, 1:", p, ") + ",
                       "L(ts_inc, 0:", q1, ") + ",
                       "L(ts_gdp, 0:", q2, ") + ",
                       "L(ts_cpi, 0:", q3, ")"))
        )
        
        model <- dynlm(formula)
        current_aic <- AIC(model)
        
        if (current_aic < min_aic) {
          min_aic <- current_aic
          best_model <- model
          best_order <- c(p, q1, q2, q3)
        }
      }
    }
  }
}

best_order
summary(best_model)
cat("Best ARDL lag structure is ARDL(",
    best_order[1], ",",
    best_order[2], ",",
    best_order[3], ",",
    best_order[4], ")",
    "with AIC =", min_aic, "\n")
# Diperoleh order optimum (1,2,3)

##=============================================================================
##=============================================================================

### Uji Kointegrasi
library(zoo)
library(ARDL)

# Ubah kolom waktu jadi format kuartalan
data$DATE <- as.yearqtr(data$observation_date, format = "%m/%d/%Y")

df <- zoo(cbind(pce = data$PCECC96,
                inc = data$A229RX0,
                gdp = data$GDPC1,
                cpi = data$CPIAUCSL),
          order.by = data$DATE)

#any(duplicated(data$DATE))
#data[duplicated(data$DATE), ]
#data$DATE <- as.yearqtr(data$observation_date, format = "%Y-%m-%d")
#head(data$DATE)
#any(is.na(data$DATE))


model_ardl <- ardl(pce ~ inc + gdp + cpi, data = df, order = c(1, 2, 3, 0))
summary(model_ardl)

model_ardl2 <- ardl(pce ~ inc + gdp, data = df, order = c(1, 2, 3))
summary(model_ardl2)

hasil_bounds <- bounds_f_test(model_ardl, case = 3)
hasil_bounds

##=============================================================================
##=============================================================================

### Uji Asumsi Klasik
dwtest(model_ardl)
bptest(model_ardl)
jarque.bera.test(residuals(model_ardl))
vif(model_ardl)

##=============================================================================
##=============================================================================

### Pembentukan ARDL dengan Metode Koyck 
ts_pce <- ts(data$PCECC96, start = c(1959, 1), frequency = 4)
ts_inc <- ts(data$A229RX0, start = c(1959, 1), frequency = 4)
ts_gdp <- ts(data$GDPC1, start = c(1959, 1), frequency = 4)
L.pce <- stats::lag(ts_pce, k = -1)  # k = -1 artinya lag ke belakang satu periode

# Membuat lag data
inc.new = ts_inc[-1]
pce.new = ts_pce[-1]
gdp.new = ts_gdp[-1]
L.pce.new = L.pce[-length(ts_pce)]
reg.adl = lm(pce.new~L.pce.new+inc.new+gdp.new)
summary(reg.adl)

