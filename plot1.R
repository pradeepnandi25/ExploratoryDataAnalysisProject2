##--------------------------------------------------------------------------------------
# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
# Using the base plotting system, make a plot showing the total PM2.5 emission from 
# all sources for each of the years 1999, 2002, 2005, and 2008.
##--------------------------------------------------------------------------------------

# Load the data table library
library("data.table")

# Declare all the local variables
var_Yrs <- "Years"
var_Emi <- "Emissions"
mainTitle <- "Emissions over the Years"
filename <- "plot1.png"

# Get the default working directory
path <- getwd()

url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
sourceFileName <- "dataFiles.zip"
download.file(url, destfile = paste(path, sourceFileName, sep = "/"))

# Unziped the source data
unzip(zipfile = sourceFileName)

# Read and load the SCC and NEI data frames into memory.
SCC <- data.table::as.data.table(x = readRDS(file = "Source_Classification_Code.rds"))
NEI <- data.table::as.data.table(x = readRDS(file = "summarySCC_PM25.rds"))

# Prevents histogram from printing in scientific notation
NEI[, Emissions := lapply(.SD, as.numeric), .SDcols = c(var_Emi)]

totalNEI <- NEI[, lapply(.SD, sum, na.rm = TRUE), .SDcols = c(var_Emi), by = year]

# Destination file to save the Emission graph
png(filename)

# Create the bar plot with following parameters
barplot(totalNEI[, Emissions], names = totalNEI[, year], xlab = var_Yrs, ylab = var_Emi, main = mainTitle)

# Close the scream device.
dev.off()