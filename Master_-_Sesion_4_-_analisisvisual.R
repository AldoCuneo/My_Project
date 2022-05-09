require("tidyr")
require("dplyr")

# Lectura de datos
myfile <- tempfile(fileext = ".rda")
download.file(url = "https://github.com/r-net-tools/security.datasets/raw/master/net.security/cves.rda",
              destfile = myfile)
load(file = myfile)
cves.raw <- cves

# Resumen basico
dim(cves.raw)
names(cves.raw)
str(cves.raw)
summary(cves.raw)

# Vamos a analizar el riesgo comparando valores CVSSv3 a lo largo del tiempo.

## Selección de datos y tratamiento de NA's
# cves <- cves.raw[grep(pattern = "ftp", x = cves.raw$description, ignore.case = T),]
cves <- cves %>% select(cve.id, starts_with("cvss3"), published.date)
df <- tidyr::drop_na(cves)
df.na <- cves[!(row.names(cves) %in% row.names(df)), ]
dim(df)
dim(df.na)

# Exploración de publicación segun si estan todos los datos completos
par(mfrow = c(3, 1), mar = c(4, 4, 2, 1))
hist(x = as.Date.POSIXlt(cves$published.date), col = "blue",
     breaks = "month", format = "%d %b %Y", freq = T,
     main = "CVE publication", xlab = "Publication date")

hist(x = as.Date.POSIXlt(df$published.date), col = "blue",
     breaks = "month", format = "%d %b %Y", freq = T,
     main = "CVE complete variables", xlab = "Publication date")

hist(x = as.Date.POSIXlt(df.na$published.date), col = "green",
     breaks = "month", format = "%d %b %Y", freq = T,
     main = "CVE incomplete variables", xlab = "Publication date")


# Exploració del score de riesgo
par(mfrow = c(1, 3), mar = c(2, 4, 2, 4))
hist(x = df$cvss3.score, breaks = 10, col = "green", main = "CVSSv3 Score distribution")
abline(v = 7.2, lwd = 3)
rug(df$cvss3.score)
boxplot(df$cvss3.score, col = "blue", main = "CVSSv3 Score distribution")
abline(h = 7.2)
barplot(height = table(df$cvss3.av), col = "wheat", main = "Access Vector distribution")

# Exploración de riesgo y access vector
## Múltiples boxplots
par(mfrow = c(1,1))
boxplot(cvss3.score ~ cvss3.av, data = df, col = "red")
## Múltiples histogramas
par(mfrow = c(2, 1), mar = c(4, 4, 2, 1))
hist(subset(df, cvss3.ac == "HIGH")$cvss3.score, col = "green", xlab = "score",
     main = "CVSSv3 Score distribution with high complexity", breaks = 20)
abline(v = median(df$cvss3.score), col = "magenta", lwd = 4)
hist(subset(df, cvss3.ac == "LOW")$cvss3.score, col = "green", xlab = "score",
     main = "CVSSv3 Score distribution with low complexity", breaks = 20)
abline(v = median(df$cvss3.score), col = "magenta", lwd = 4)
