##--------------------------------------------------------------------------------------
# Of the four types of sources indicated by the \color{red}{\verb|type|}type 
# (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen 
# decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases 
# in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.
##--------------------------------------------------------------------------------------

# Load the data table and ggplot2 library
library("data.table")
library("ggplot2")

# Declare all the local variables
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
sourceFileName <- "dataFiles.zip"

# Set and get the working directory.
setwd("./")
path <- getwd()

# Download the source data for analysis
download.file(url, destfile = paste(path, sourceFileName, sep = "/"))

# Unziped the source data
unzip(zipfile = sourceFileName)

# Read and load the SCC and NEI data frames into memory.
SCC <- data.table::as.data.table(x = readRDS("Source_Classification_Code.rds"))
NEI <- data.table::as.data.table(x = readRDS("summarySCC_PM25.rds"))

# Subset NEI data by Baltimore
baltimoreNEI <- NEI[fips=="24510",]

# Destination file to save the Emission graph
png(filename = "plot3.png")

# Create the ggplot with following parameters
ggplot(baltimoreNEI, aes(factor(year), Emissions, fill = type)) +
        geom_bar(stat="identity") +
        theme_bw() + guides(fill = FALSE)+
        facet_grid(.~type, scales = "free", space="free") + 
        labs(x="year", y = expression("Total PM"[2.5]*" Emission (Tons)")) + 
        labs(title = expression("PM"[2.5]*" Emissions, Baltimore City 1999-2008 by Source Type"))

# Close the scream device.
dev.off()