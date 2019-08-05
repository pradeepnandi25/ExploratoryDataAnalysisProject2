##--------------------------------------------------------------------------------------
# Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?
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

# Subset coal combustion related NEI data
combustionRelated <- grepl("comb", SCC[, SCC.Level.One], ignore.case = TRUE)
coalRelated <- grepl("coal", SCC[, SCC.Level.Four], ignore.case = TRUE) 
combustionSCC <- SCC[combustionRelated & coalRelated, SCC]
combustionNEI <- NEI[NEI[,SCC] %in% combustionSCC]

# Destination file to save the Emission graph
png(filename = "plot4.png")

# Create the ggplot with following parameters
ggplot(combustionNEI,aes(x = factor(year),y = Emissions/10^5)) +
        geom_bar(stat = "identity", fill = "#FF9999", width = 0.75) +
        labs(x = "year", y = expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
        labs(title = expression("PM"[2.5]*" Coal Combustion Source Emissions Across US from 1999-2008"))

# Close the scream device.
dev.off()