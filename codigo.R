library(readxl)
require("tidyr")
require("dplyr")

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

# GRAFICO SMB ?????






## NO USAR ##
#dataframe_order <- spread(df.company,"autonomous_system.name","hosts")
#dataframe_order$`<NA>` <- NULL
#dataframe_no_NA <- tidyr::drop_na(dataframe_order)
