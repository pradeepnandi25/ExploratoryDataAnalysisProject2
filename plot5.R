##--------------------------------------------------------------------------------------
# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
##--------------------------------------------------------------------------------------

# Load the data table and ggplot2 library
library("data.table")
library("ggplot2")

# Set and get the working directory.
setwd("./")
path <- getwd()

# Declare all the local variables
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
sourceFileName <- "dataFiles.zip"

download.file(url, destfile = paste(path, sourceFileName, sep = "/"))

# Unziped the source data
unzip(zipfile = sourceFileName)

# Load the NEI & SCC data frames.
NEI <- data.table::as.data.table(x = readRDS("summarySCC_PM25.rds"))
SCC <- data.table::as.data.table(x = readRDS("Source_Classification_Code.rds"))

# Gather the subset of the NEI data which corresponds to vehicles
vehiclesSCC <- SCC[grepl("vehicle", SCC$SCC.Level.Two, ignore.case = TRUE), SCC]
vehiclesNEI <- NEI[NEI[, SCC] %in% vehiclesSCC,]

# Subset the vehicles NEI data to Baltimore's fip
baltimoreVehiclesNEI <- vehiclesNEI[fips == "24510",]

# Destination file to save the Emission graph
png(filename = "plot5.png")

# Create the ggplot with following parameters
ggplot(baltimoreVehiclesNEI,aes(factor(year), Emissions)) +
        geom_bar(stat = "identity", fill = "#FF9999", width = 0.75) +
        labs(x = "year", y = expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
        labs(title = expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore from 1999-2008"))

# Close the stream device.
dev.off()
