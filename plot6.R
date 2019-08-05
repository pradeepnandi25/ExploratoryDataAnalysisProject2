##--------------------------------------------------------------------------------------
# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor 
# vehicle sources in Los Angeles County, California (\color{red}{\verb|fips == "06037"|}fips=="06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?
##--------------------------------------------------------------------------------------

# Load the data table and ggplot2 library
library("data.table")
library("ggplot2")

# Declare all the local variables
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
sourceFileName <- "dataFiles.zip"

path <- getwd()

# Download the file from online source
download.file(url, destfile = paste(path, sourceFileName, sep = "/"))

# Unziped the source data
unzip(zipfile = "dataFiles.zip")

# Read and load the SCC and NEI data frames into memory.
SCC <- data.table::as.data.table(x = readRDS(file = "Source_Classification_Code.rds"))
NEI <- data.table::as.data.table(x = readRDS(file = "summarySCC_PM25.rds"))

# Gather the subset of the NEI data which corresponds to vehicles
condition <- grepl("vehicle", SCC[, SCC.Level.Two], ignore.case = TRUE)
vehiclesSCC <- SCC[condition, SCC]
vehiclesNEI <- NEI[NEI[, SCC] %in% vehiclesSCC,]

# Subset the vehicles NEI data by each city's fip and add city name.
vehiclesBaltimoreNEI <- vehiclesNEI[fips == "24510",]
vehiclesBaltimoreNEI[, city := c("Baltimore City")]

vehiclesLANEI <- vehiclesNEI[fips == "06037",]
vehiclesLANEI[, city := c("Los Angeles")]

# Combine data.tables into one data.table
bothNEI <- rbind(vehiclesBaltimoreNEI, vehiclesLANEI)

# Destination file to save the Emission graph
png("plot6.png")

# Create the ggplot with following parameters
ggplot(bothNEI, aes(x = factor(year), y = Emissions, fill = city)) +
        geom_bar(aes(fill = year),stat = "identity") +
        facet_grid(scales = "free", space = "free", .~city) +
        labs(x = "year", y = expression("Total PM"[2.5]*" Emission (Kilo-Tons)")) + 
        labs(title = expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore & LA, 1999-2008"))

# Close the stream device.
dev.off()