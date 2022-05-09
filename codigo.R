library(readxl)
require("tidyr")
require("dplyr")
library(ggplot2)

pe_smb_by_company <- read_excel("SMB_PERU.xlsx", sheet = "autonomous_system.name")
pe_smb_by_city <- read_excel("SMB_PERU.xlsx", sheet = "location.city")
pe_smb_by_os.vendor <- read_excel("SMB_PERU.xlsx", sheet = "operating_system.vendor")
pe_smbv1_by_company <- read_excel("SMBv1_PERU.xlsx", sheet = "autonomous_system.name")
pe_smbv1_by_city <- read_excel("SMBv1_PERU.xlsx", sheet = "location.city")
pe_smbv1_by_os.vendor <- read_excel("SMBv1_PERU.xlsx", sheet = "operating_system.vendor")
latam_smb_by_company <- read_excel("SMB_LATAM.xlsx", sheet = "autonomous_system.name")
latam_smb_by_country <- read_excel("SMB_LATAM.xlsx", sheet = "location.country")
latam_smb_by_os.vendor <- read_excel("SMB_LATAM.xlsx", sheet = "operating_system.vendor")
latam_smbv1_by_company <- read_excel("SMBv1_LATAM.xlsx", sheet = "autonomous_system.name")
latam_smbv1_by_country <- read_excel("SMBv1_LATAM.xlsx", sheet = "location.country")
latam_smbv1_by_os.vendor <- read_excel("SMBv1_LATAM.xlsx", sheet = "operating_system.vendor")
head("latam_smb_by_os")

# GRAFICO SMB PERU POR ISP
df.company <- as.data.frame(pe_smb_by_company, header = FALSE)
df.company.NA <- tidyr::drop_na(df.company)
n <- 1;N <- 10
par(mfrow = c(1, 1), mar = c(18, 4, 1, 1))
barplot(height = df.company.NA$hosts[n:N],names = df.company.NA$autonomous_system.name[n:N],las = 2, col = "black", main = "SMB by Company")

# GRAFICO SMB LATAM POR PAIS
df.latam.country <- as.data.frame(latam_smb_by_country, header = FALSE)
df.latam.country.NA <- tidyr::drop_na(df.latam.country)
n <- 1;N <- 10
par(mfrow = c(1, 1), mar = c(10, 4, 1, 1))
barplot(height = df.latam.country.NA$hosts,names = df.latam.country.NA$location.country,las = 2, col = "black", main = "SMB by Company")

# GRAFICO DONUT TOP 5 LATAM SMB
# Create data
df.latam.top5 <- df.latam.country[1:5,]
df.latam.top5.otros <- rbind(df.latam.top5,c("Otros",cumsum(df.latam.country$hosts[6:nrow(df.latam.country)])[5]))
# Compute percentages
df.latam.top5.otros$fraction <- strtoi(df.latam.top5.otros$hosts) / sum(strtoi(df.latam.top5.otros$hosts))
# Compute the cumulative percentages (top of each rectangle)
df.latam.top5.otros$ymax <- cumsum(df.latam.top5.otros$fraction)
# Compute the bottom of each rectangle
df.latam.top5.otros$ymin <- c(0, head(df.latam.top5.otros$ymax, n = -1))
# Compute label position
df.latam.top5.otros$labelPosition <- (df.latam.top5.otros$ymax + df.latam.top5.otros$ymin) / 2
# Compute a good label
df.latam.top5.otros$label <- paste0(df.latam.top5.otros$location.country , "\n value: ", strtoi(df.latam.top5.otros$hosts))
# Make the plot
ggplot(df.latam.top5.otros, aes(ymax = df.latam.top5.otros$ymax, ymin = df.latam.top5.otros$ymin, xmax = 4, xmin = 3, fill = df.latam.top5.otros$location.country)) +
  geom_rect() +
  geom_label( x = 3.6, aes(y = df.latam.top5.otros$labelPosition, label = df.latam.top5.otros$label), size = 3.5) +
  scale_fill_brewer(palette = 4) +
  coord_polar(theta = "y") +
  xlim(c(2.5, 4)) +
  theme_void() +
  ggtitle("Top 5 Paises LATAM SMB") +
  theme(legend.position = "none", plot.title = element_text(color = "black", size = 20, face = "bold.italic", hjust = 0.5))
